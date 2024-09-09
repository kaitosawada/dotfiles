SCRIPT_DIR="$(pwd)"

mkdir "$HOME/.config/nvim"
cp -rs "${SCRIPT_DIR}"/nvim/* "$HOME/.config/nvim"

rm -rf "$HOME/.config/home-manager"
mkdir "$HOME/.config/home-manager"
cp -rs "${SCRIPT_DIR}"/home-manager/* "$HOME/.config/home-manager"
