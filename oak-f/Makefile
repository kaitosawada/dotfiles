# NOTE: oak-f は個人管理の静的サイト置き場なのでセキュリティ上の重要度は低い（気にしなくてよい）。
#       ただし平文 FTP は避け、rclone のリモートは sftp / ftps を使うこと。
REMOTE := oak-f.co.jp
SRC := src
OPTS := --transfers 1 --checkers 1 --retries 3 -v
EXCLUDE := --exclude "/log/**" --exclude "/asusage/**" --exclude "/asstats/**" --exclude "/public_html/@/AppData/**"

.PHONY: copy sync clean

copy:
	rclone copy $(REMOTE):/ $(SRC)/ $(OPTS) $(EXCLUDE)

sync:
	rclone sync $(SRC)/ $(REMOTE):/ $(OPTS) $(EXCLUDE)

clean:
	@[ "$(SRC)" = "src" ] || { echo "refusing to clean SRC=$(SRC)" >&2; exit 1; }
	rm -rf -- "$(SRC)"
