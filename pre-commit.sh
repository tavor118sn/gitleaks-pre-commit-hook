#!/bin/sh
#
# An example hook script to verify what is about to be committed.
# Called by "git commit" with no arguments.  The hook should
# exit with non-zero status after issuing an appropriate message if
# it wants to stop the commit.
#
# Get the current platform (linux, darwin, or msys for Windows)
OS=$(uname | tr '[:upper:]' '[:lower:]')

# Check if gitleaks is already installed
if ! command -v gitleaks &> /dev/null; then
    echo "Gitleaks is not installed. Installing..."

    # Install gitleaks based on the operating system
    if [ "$OS" == "linux" ]; then
        echo "Installing gtitleaks using source code. Remove the 'gtitleaks' from '/usr/local/bin' to uninstall it."

        # Temporary directory for cloning
        TMP_DIR=$(mktemp -d)

        # Clone the repository into the temporary directory
        git clone https://github.com/zricethezav/gitleaks.git "$TMP_DIR"

        # Navigate to the cloned repository
        cd "$TMP_DIR" || exit

        # Run make build
        make build

        # Directory for the final binary
        BIN_DIR="/usr/local/bin"

        # Copy the built binary to the bin directory
        cp gitleaks "$BIN_DIR"

        # Clean up: Remove the temporary directory
        rm -rf "$TMP_DIR"

        echo "Gitleaks installed successfully."

    elif [ "$OS" == "darwin" ]; then
        echo "Installin using brew. To uninstall use `brew uninstall gitleaks`."
        brew install gitleaks
    else
        echo "Unsupported operating system: $OS"
        exit 1
    fi

    echo "Gitleaks installed successfully."

    echo "Enabling Gitleaks by default"
    git config gitleaks.enabled true

else
    echo "Gitleaks is already installed. To disable check, run: git config hooks.gitleaks false"
fi

# Check if gitleaks is enabled in git config
GITLEAKS_ENABLED=$(git config --get hooks.gitleaks)

# Run gitleaks if enabled
if [ "$GITLEAKS_ENABLED" = true ]; then
    gitleaks protect -v --staged
    exit_code=$(gitleaks protect -v --staged 2>&1)
    if [ $? -eq 1 ]; then
        echo "\nWarning: gitleaks has detected sensitive information in your changes."
        echo "To disable the gitleaks precommit hook run the following command:"
        echo "    git config hooks.gitleaks false"
        exit 1
    fi
else
    echo "Gitleaks is disabled. To enable, run: git config hooks.gitleaks true"
fi

exit 0