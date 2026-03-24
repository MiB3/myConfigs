#! /bin/bash

set -euxo pipefail

myFolder="$(dirname "$0")"
cd "$myFolder/.."

# Run shellcheck on all .sh files.
find . -type f -name "*.sh" -exec shellcheck {} +

# Other files.
shellcheck .zshrc