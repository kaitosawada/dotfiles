if [ "$(uname)" != "Darwin" ] ; then
	echo "Not macOS!"

    echo "macOS!"

    # Install xcode
    xcode-select --install > /dev/null

    # Install brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null
fi
