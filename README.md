# ic-designspace-installer
Kaoile's IC Design Space using Open-Source EDA Tools

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

### Install

Clone the repository (for other users, use `https`).

``` sh
git clone git@github.com:kenrendell/ic-designspace-installer.git "${HOME}"
# or
git clone https://github.com/kenrendell/ic-designspace-installer.git "${HOME}"
```

Source/execute `env/profile.sh` to initialize the required environment variables and aliases.

``` sh
# For bash users
echo '. "${HOME}/ic-designspace-installer/env/profile.sh"' >> "${HOME}/.bashrc"

# For zsh users
echo '. "${HOME}/ic-designspace-installer/env/profile.sh"' >> "${ZDOTDIR:-"${HOME}"}/.zshrc"
```
