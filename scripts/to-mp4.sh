# Compress a video to H.264/AAC MP4 at or below a target size.
#
# Usage: to-mp4 <input> <max-mb> [output.mp4]

usage() {
  echo "Usage: to-mp4 <input> <max-mb> [output.mp4]" >&2
  echo "  Encode INPUT as H.264/AAC MP4 no larger than MAX-MB megabytes." >&2
  echo "  Default output: <stem>-<max-mb>mb.mp4 next to the input." >&2
  exit 2
}

file_size() {
  if stat -c%s "$1" >/dev/null 2>&1; then
    stat -c%s "$1"
  else
    stat -f%z "$1"
  fi
}

human_mb() {
  awk -v s="$1" 'BEGIN { printf "%.2f", s / 1024 / 1024 }'
}

if [[ $# -lt 1 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
fi
if [[ $# -lt 2 ]]; then
  usage
fi

input=$1
max_mb=$2

if ! awk -v n="$max_mb" 'BEGIN { exit !(n ~ /^[0-9]+(\.[0-9]+)?$/ && n > 0) }'; then
  echo "to-mp4: max-mb must be a positive number" >&2
  exit 1
fi

if [[ ! -f "$input" ]]; then
  echo "to-mp4: input not found: $input" >&2
  exit 1
fi

stem=${input##*/}
stem=${stem%.*}
input_dir=$(dirname "$input")
output=${3:-"$input_dir/${stem}-${max_mb}mb.mp4"}

if [[ -e "$output" && ! -f "$output" ]]; then
  echo "to-mp4: output is not a regular file: $output" >&2
  exit 1
fi
mkdir -p "$(dirname "$output")"

duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input")
if [[ -z "$duration" || "$duration" == "N/A" ]]; then
  echo "to-mp4: could not read duration from $input" >&2
  exit 1
fi

height=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$input")
if [[ -z "$height" || "$height" == "N/A" ]]; then
  echo "to-mp4: no video stream in $input" >&2
  exit 1
fi

audio_idx=$(ffprobe -v error -select_streams a:0 -show_entries stream=index -of csv=p=0 "$input" || true)
has_audio=0
if [[ -n "$audio_idx" ]]; then
  has_audio=1
fi

target_bytes=$(awk -v mb="$max_mb" 'BEGIN { printf "%.0f", mb * 1024 * 1024 }')
current=$(file_size "$input")

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
tmpout=$tmpdir/out.mp4
passlog=$tmpdir/pass

try_remux() {
  ffmpeg -y -hide_banner -loglevel error \
    -i "$input" -c copy -movflags +faststart "$tmpout" || return 1
  local s
  s=$(file_size "$tmpout")
  [[ "$s" -le "$target_bytes" ]]
}

if [[ "$current" -le "$target_bytes" ]] && try_remux; then
  mv -f "$tmpout" "$output"
  echo "Wrote $output ($(human_mb "$(file_size "$output")") MB, remux)"
  exit 0
fi

audio_k=0
if [[ "$has_audio" -eq 1 ]]; then
  audio_k=128
  if awk -v mb="$max_mb" 'BEGIN { exit !(mb < 8) }'; then
    audio_k=64
  fi
fi

video_k=$(awk -v target="$target_bytes" -v dur="$duration" -v ak="$audio_k" '
  BEGIN {
    usable_k = (target * 0.93 * 8) / dur / 1000
    vk = usable_k - ak
    if (vk < 50) vk = 50
    printf "%.0f", vk
  }
')

vf_args=()
if [[ "$video_k" -lt 400 && "$height" -gt 480 ]]; then
  vf_args=(-vf "scale=-2:480")
elif [[ "$video_k" -lt 800 && "$height" -gt 720 ]]; then
  vf_args=(-vf "scale=-2:720")
fi

encode() {
  local vk=$1
  local buf=$((vk * 2))
  local audio_args=()

  if [[ "$has_audio" -eq 1 ]]; then
    audio_args=(-c:a aac -b:a "${audio_k}k" -ac 2)
  else
    audio_args=(-an)
  fi

  echo "to-mp4: pass 1/2 (${vk} kbps video, ${audio_k} kbps audio)" >&2
  ffmpeg -y -hide_banner -loglevel error -stats \
    -i "$input" \
    -c:v libx264 -preset medium -profile:v high \
    -b:v "${vk}k" -maxrate "${vk}k" -bufsize "${buf}k" \
    -pix_fmt yuv420p \
    "${vf_args[@]}" \
    -pass 1 -passlogfile "$passlog" \
    -an -f null /dev/null

  echo "to-mp4: pass 2/2" >&2
  ffmpeg -y -hide_banner -loglevel error -stats \
    -i "$input" \
    -c:v libx264 -preset medium -profile:v high \
    -b:v "${vk}k" -maxrate "${vk}k" -bufsize "${buf}k" \
    -pix_fmt yuv420p \
    -movflags +faststart \
    "${vf_args[@]}" \
    -pass 2 -passlogfile "$passlog" \
    "${audio_args[@]}" \
    "$tmpout"
}

attempt=1
max_attempts=3
while [[ "$attempt" -le "$max_attempts" ]]; do
  encode "$video_k"
  out_size=$(file_size "$tmpout")
  if [[ "$out_size" -le "$target_bytes" ]]; then
    mv -f "$tmpout" "$output"
    echo "Wrote $output ($(human_mb "$out_size") MB)"
    exit 0
  fi

  if [[ "$attempt" -eq "$max_attempts" ]]; then
    echo "to-mp4: still $(human_mb "$out_size") MB after ${max_attempts} attempts (target ${max_mb} MB)" >&2
    exit 1
  fi

  video_k=$(awk -v vk="$video_k" -v out="$out_size" -v target="$target_bytes" '
    BEGIN {
      next_vk = vk * (target / out) * 0.92
      if (next_vk < 50) next_vk = 50
      printf "%.0f", next_vk
    }
  ')
  echo "to-mp4: $(human_mb "$out_size") MB over target, retrying at ${video_k} kbps" >&2
  attempt=$((attempt + 1))
done
