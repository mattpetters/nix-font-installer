# Nix Font Installer

A flexible and easy-to-use script for installing local fonts in Nix environments. This script supports both individual font files and directories containing multiple fonts.

## Features

- Install single font files or entire directories of fonts
- Supports both .ttf and .otf font formats
- Automatically updates font cache after installation
- Verifies successful font installation
- Compatible with NixOS and other Nix-based systems

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/mattpetters/nix-font-installer.git
   ```

## Usage

### Installing a single font file:

```
./nix-font-installer.sh "My Custom Font" /path/to/font.ttf
```

### Installing multiple fonts from a directory:

```
./nix-font-installer.sh "My Font Collection" /path/to/font/directory
```

## How It Works

1. The script creates a temporary Nix expression to package the font(s).
2. It copies the specified font file(s) to a temporary directory.
3. The Nix expression is evaluated and the fonts are installed into your Nix profile.
4. The font cache is updated to make the new fonts immediately available.
5. The script verifies the installation by listing the newly installed fonts.

## Requirements

- Nix package manager
- `fc-cache` (usually comes pre-installed on most systems)

## License

Distributed under the MIT License. See `LICENSE` file for more information.


## Contact

[@mattpetters_](https://x.com/mattpetters_)

