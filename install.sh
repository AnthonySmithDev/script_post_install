#!/usr/bin/env bash

source "src/lib.sh"

function apt_install {
	sudo apt install -y $1
}
function set_alias() {
	echo "alias $1='$2'" >>~/.zshrc
}

function set_var() {
	echo "export $1=$2" >>~/.zshrc
}

function setup_zsh {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	zsh_plugins="$HOME/.oh-my-zsh/custom/plugins"

	git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_plugins/zsh-syntax-highlighting"
	echo 'omz plugin enable zsh-syntax-highlighting'

	git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_plugins/zsh-autosuggestions"
	echo 'omz plugin enable zsh-autosuggestions'

	git clone https://github.com/jeffreytse/zsh-vi-mode "$zsh_plugins/zsh-vi-mode"
	echo 'omz plugin enable zsh-vi-mode'
}
function install_zsh {
	apt_install "zsh"
	lib::setup "Oh My Zsh" "zsh" setup_zsh
	sudo reboot
}
lib::install "ZSH" "zsh" install_zsh

function install_starship {
	curl -sS https://starship.rs/install.sh | sh

	setup_starship() {
		starship_config="$HOME/.config/starship.toml"

		echo 'eval "$(starship init zsh)"' >>~/.zshrc
		cp "./config/starship.toml" "$starship_config"
	}
	lib::setup "Oh My Zsh" "zsh" setup_starship
}
lib::install "Starship" "starship" install_starship

function install_zoxide {
	curl -sS https://webinstall.dev/zoxide | bash

	setup_zoxide() {
		echo 'eval "$(zoxide init zsh)"' >>~/.zshrc
		echo 'export PATH="/home/anthony/.local/bin:$PATH"' >>~/.zshrc
	}
	lib::setup "Zoxide" "zoxide" setup_zoxide
}
lib::install "Zoxide" "zoxide" install_zoxide

function install_regolith {
	# Register the Regolith public key to your local apt:
	wget -qO - https://regolith-linux.github.io/package-repo/regolith.key | sudo tee /etc/apt/trusted.gpg.d/regolith.asc

	# Add the repository URL to your local apt:
	echo deb "[arch=amd64] https://regolith-release-ubuntu-jammy-amd64.s3.amazonaws.com jammy main" |
		sudo tee /etc/apt/sources.list.d/regolith.list

	# Update apt and install Regolith
	sudo apt update
	apt_install regolith-desktop
}
lib::install "Regolith Desktop" "i3" install_regolith

function install_docker_engine {
	curl -fsSL https://get.docker.com | sh
	sudo usermod -aG docker $USER
}
lib::install "Docker Engine" "docker" install_docker_engine

function install_docker_compose {
	sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
}
lib::install "Docker Compose" "docker-compose" install_docker_compose

function install_nodejs {
	curl -L https://git.io/n-install | bash
}
lib::install "NodeJS" "node" install_nodejs

function tools_nodejs {
	npm install -g httpyac
	npm install -g gitmoji-cli
	npm install -g bash-language-server
}
lib::tool "NodeJS Tools" "npm" tools_nodejs

function install_python {
	apt_install python3-pip
	apt_install python3-venv

	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
}
lib::install "Python" "python3" install_python

function tools_python {
	pipx install httpie
	pipx install http-prompt
	pipx install litecli
	pipx install mycli
}
lib::tool "Python Tools" "pipx" tools_python

function install_golang {
	curl -sSL https://git.io/g-install | sh -s
}
lib::install "Golang" "go" install_golang

function tools_golang {
	go_dev() {
		go install golang.org/x/tools/gopls@latest
		go install mvdan.cc/sh/v3/cmd/shfmt@latest
		go install github.com/go-delve/delve/cmd/dlv@latest

		go install github.com/jesseduffield/lazygit@latest
		go install github.com/jesseduffield/lazydocker@latest

		set_alias "lzg" "lazygit"
		set_alias "lzd" "lazydocker"
	}
	lib::pack "Golang Dev" go_dev

	go_others() {
		go install github.com/cointop-sh/cointop@latest
		go install github.com/muesli/duf@latest
		go install github.com/gokcehan/lf@latest
		go install github.com/knipferrc/fm@latest
		go install github.com/cheat/cheat/cmd/cheat@latest
	}
	lib::pack "Golang Others" go_others
}
lib::tool "Golang Tools" "go" tools_golang

function install_rust {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}
lib::install "Rust" "rustup" install_rust

function tools_rust {
	rust_dev() {
		cargo install amber
		cargo install exa
		cargo install ttyper
		cargo install fd-find
		cargo install ripgrep
	}
	lib::pack "Rust Dev" rust_dev

	rust_others() {
		cargo install xh
		cargo install broot
		cargo install gping
		cargo install procs
		cargo install du-dust
		cargo install git-delta
		cargo install grex
		cargo install felix
		cargo install bat --locked
		cargo install pueue --locked
		cargo install bottom --locked
		cargo install xplr --locked --force
	}
	lib::pack "Rust Others" rust_others
}
lib::tool "Rust Tools" "cargo" tools_rust

function install_flatpak {
	apt_install flatpak
	apt_install gnome-software-plugin-flatpak
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
lib::install "Flatpak" "flatpak" install_flatpak

function tools_flatpak {
	flatpak install flathub com.google.Chrome
	flatpak install flathub com.brave.Browser

	flatpak install flathub us.zoom.Zoom
	flatpak install flathub com.microsoft.Teams
	flatpak install flathub com.discordapp.Discord

	flatpak install flathub com.usebottles.bottles
	flatpak install flathub org.videolan.VLC
}
lib::tool "Flatpak Tools" "flatpak" tools_flatpak

function install_helix {
	cargo_bin="$HOME/.cargo/bin"

	helix_dir="$HOME/.config/helix"
	helix_config="$helix_dir/config.toml"
	helix_repo="$HOME/Documents/Github/helix"

	git clone "https://github.com/helix-editor/helix.git" "$helix_repo"
	cargo install --path "$helix_repo/helix-term"

	mkdir "$helix_dir"
	cp -r "$helix_repo/runtime/" "$cargo_bin"
	cp "./config/helix.toml" "$helix_config"

	sudo update-alternatives --install "/usr/bin/editor" editor "$cargo_bin/hx" 100
}
lib::install "Helix editor" "hx" install_helix

function install_zellij {
	zellij_dir="$HOME/.config/zellij"
	zellij_config="$zellij_dir/config.yaml"
	zellij_repo="$HOME/Documents/Github/zellij"

	git clone "https://github.com/zellij-org/zellij.git" "$zellij_repo"
	cargo install --path "$zellij_repo"

	mkdir "$zellij_dir"
	cp "./config/zellij.yaml" "$zellij_config"
	cp -r "$zellij_repo/example/themes/" "$zellij_dir"
}
lib::install "Zellij" "zellij" install_zellij

function setup_git {
	git config --global color.ui true
	git config --global init.defaultBranch main

	git config --global user.name "Anthony Smith"
	git config --global user.email "anthonyasdeveloper@gmail.com"
}
lib::setup "Git" "git" setup_git

function install_github {
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
	sudo apt update
	sudo apt install gh
}
lib::install "Githu Cli" "gh" install_github
