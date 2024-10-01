SCRIPT_DIR="$(pwd)"

rm -rf "$HOME/.config/home-manager"
mkdir "$HOME/.config/home-manager"
cp -rs "${SCRIPT_DIR}"/home-manager/* "$HOME/.config/home-manager"
