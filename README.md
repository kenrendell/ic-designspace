# IC Design Space Installer

IC Design Space installer to help in workspace setup for IC design with open-source EDA tools.

## Configuration

### Nix

Nix package manager will be used to install IC design tools. Install [Nix](https://docs.determinate.systems/getting-started/individuals#install) from [Determinate Systems](https://determinate.systems/nix/), since it has SELinux support.

``` sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

Enable and start `nix-daemon` systemd service.

``` sh
sudo systemctl enable --now nix-daemon.service
```

To upgrade nix, run the following command:

``` sh
sudo -i nix upgrade-nix
```

### Initialize Environment

Clone the repository (for other users, use `https`).

``` sh
git clone git@github.com:kenrendell/ic-designspace-installer.git "${HOME}/ic-designspace-installer"
# or
git clone https://github.com/kenrendell/ic-designspace-installer.git "${HOME}/ic-designspace-installer"
```

Source/execute `env/profile.sh` to initialize the required environment variables and aliases.

``` sh
# For bash users
printf '\n. "${HOME}/ic-designspace-installer/env/profile.sh"\n' >> "${HOME}/.bashrc"

# For zsh users
printf '\n. "${HOME}/ic-designspace-installer/env/profile.sh"\n' >> "${ZDOTDIR:-"${HOME}"}/.zshrc"
```

### Install Nix Packages

Install the nix packages defined in `nixpkgs/flake.nix` with `nix_profile_*` aliases from `env/aliases.sh`.

``` sh
nix_profile_switch
```

> If there are new packages added to `nixpkgs/flake.nix`, run `nix_profile_switch`.

To update nix packages, run the following:

``` sh
nix_profile_update # removes `nixpkgs/flake.lock`
nix_profile_switch
```

> The file `nixpkgs/flake.lock` is used in version locking of nix packages, removing it will force an update to nix packages when `nix_profile_switch` is executed.
