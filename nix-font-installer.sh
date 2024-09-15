#!/bin/bash

# Check if required parameters are provided
if [ $# -lt 2 ]; then
    echo "Nix Local Font Installer - Install local fonts for Nix"
    echo "Usage: $0 <fontName> <pathToFontOrDirectory>"
    exit 1
fi

fontName="$1"
pathToFontOrDir="$2"

# Create a temporary directory for the Nix expression
tmpDir=$(mktemp -d)
trap 'rm -rf "$tmpDir"' EXIT

# Create a simple Nix expression to package the fonts
cat > "$tmpDir/default.nix" <<EOF
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "$fontName";
  src = ./.;
  installPhase = ''
    mkdir -p \$out/share/fonts/truetype
    cp -r *.{ttf,otf} \$out/share/fonts/truetype/ || true
  '';
}
EOF

# Function to copy fonts
copy_fonts() {
    local source="$1"
    if [ -f "$source" ]; then
        # Single file
        cp "$source" "$tmpDir/"
    elif [ -d "$source" ]; then
        # Directory
        find "$source" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "$tmpDir/" \;
    else
        echo "Error: '$source' is neither a file nor a directory."
        exit 1
    fi
}

# Copy font(s) to the temporary directory
copy_fonts "$pathToFontOrDir"

# Check if any fonts were copied
if [ ! "$(ls -A "$tmpDir"/*.{ttf,otf} 2>/dev/null)" ]; then
    echo "Error: No .ttf or .otf files found in the specified path."
    exit 1
fi

# Build and install the Nix package
nix-env -f "$tmpDir" -i

echo "Font(s) '$fontName' have been installed and are now available to Nix."

# Update the font cache
fc-cache -f -v

# Verify that the fonts have been installed
echo "Installed fonts:"
fc-list | grep -i "$fontName"

