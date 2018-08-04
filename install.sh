#!/bin/bash

# Bootstraps environment I use on daily basis
# Installs all required software and symlinks config files from
# repository to the system

# Exit on error and print all commands
set -ex

# Get this script's directory
readonly DOT_SRC=$(cd "$(dirname "$0")"; pwd)


function create_dirs() {
    echo "Create dirs ..."
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/share"
    mkdir -p "$HOME/.local/bin"
}


function install_packages() {
    # Update system
    echo "Update packages ..."
    sudo dnf upgrade -y

    # Packages
    sudo dnf install -y \
        bzip2-devel \
        curl \
        cmake \
        doxygen \
        gcc \
        gcc-c++ \
        libffi-devel \
        openssl-devel \
        pcre-devel \
        readline-devel \
        sqlite-devel \
        util-linux-user \
        wget \
        zlib-devel

    # WM packages
    echo "Install window manager ..."
    sudo dnf install -y \
        alsa-utils \
        awesome \
        arandr \
        brightnessctl \
        dunst \
        ImageMagick \
        i3 \
        i3lock \
        i3status \
        lxpolkit \
        vicious \
        xcompmgr \
        xss-lock

    # Code editing packages
    echo "Install software for development ..."
    sudo dnf install -y \
        ctags \
        git \
        make \
        neovim \
        ripgrep

    # Editorconfig core
    cwd=$(pwd)
    cd /tmp
    git clone https://github.com/editorconfig/editorconfig-core-c.git
    cd editorconfig-core-c
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr . && make && sudo make install
    cd /tmp && rm -rf editorconfig-core-c
    cd "$cwd"
    unset cwd

    # Shell
    echo "Install shell tools ..."
    sudo dnf install -y \
        tmux \
        zsh
}


function install_pyenv() {
    echo "Install pyenv ..."
    local pyenv_dir="$HOME/.pyenv"
    local plugin_dir="${pyenv_dir}/plugins"
    local pyenv_repo='git://github.com/pyenv/pyenv.git'
    local pyenv_virtualenv_repo='git://github.com/pyenv/pyenv-virtualenv.git'
    local pyenv_update_repo='git://github.com/pyenv/pyenv-update.git'

    if [ -d "${pyenv_dir}" ]; then
        rm -rf "${pyenv_dir}"
    fi

    # Clone everything
    git clone "${pyenv_repo}" "${pyenv_dir}"
    git clone "${pyenv_virtualenv_repo}" "${plugin_dir}/pyenv-virtualenv"
    git clone "${pyenv_update_repo}" "${plugin_dir}/pyenv-update"

    # Initialize pyenv
    export PYENV_ROOT="${pyenv_dir}"
    export PATH="${pyenv_dir}/bin:$PATH"
    eval "$(pyenv init -)"

    # Install python interpreters
    echo "Install python interpreters ..."
    pyenv install 2.7.15
    pyenv install 3.6.6

    # Create utilitary virtualenvs
    echo "Create utilitary interpreters ..."
    pyenv virtualenv 2.7.15 neovim-2
    pyenv virtualenv 3.6.6 neovim-3

    for py_env in 'neovim-2' 'neovim-3'; do
        pyenv activate "${py_env}"
        pip install -U neovim jedi
        source deactivate || pyenv deactivate || deactivate
    done
}


function install_nvm() {
    echo "Install nvm ..."
    local nvm_dir="$HOME/.nvm"
    local nvm_version="v0.33.11"
    local nvm_install_url="https://raw.githubusercontent.com"
    nvm_install_url+="/creationix/nvm/${nvm_version}/install.sh"

    if [ -d "${nvm_dir}" ]; then
        rm -rf "${nvm_dir}"
    fi

    curl -o- "${nvm_install_url}" | bash

    # activate nvm
    export NVM_DIR="$nvm_dir"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    echo "Install latest stable node ..."
    nvm install --lts

    echo "Install development packages ..."
    nvm use default
    npm install -g \
        gitmoji-cli \
        neovim \
        prettier \
        yarn

    unset NVM_DIR
}


function install_sdkman() {
    echo "Install sdkman (java toolbelt) ..."
    local sdkman_url="https://get.sdkman.io"
    local sdkman_dir="$HOME/.sdkman"

    if [ -e "${sdkman_dir}" -o -h "${sdkman_dir}" ]; then
        rm -rf "${sdkman_dir}"
    fi

    curl -s "${sdkman_url}" | bash
}


function install_rustup() {
    echo "Install rustup ..."
    curl https://sh.rustup.rs -sSf | sh
}


function install_stack() {
    echo "Install haskell stack ..."
    curl -sSL https://get.haskellstack.org/ | sh || stack upgrade
    stack setup
    stack install ghc-mod
}


function install_nvim() {
    echo "Install neovim configuration ..."
    local nvim_config_dir="$HOME/.config/nvim"
    local vim_plug_file="$HOME/.local/share/nvim/site/autoload/plug.vim"

    if [ -e "${nvim_config_dir}" -o -h "${nvim_config_dir}" ]; then
        rm -r "${nvim_config_dir}"
    fi

    if [ ! -e "${vim_plug_file}" -a ! -h "${vim_plug_file}" ]; then
        curl -fLo "${vim_plug_file}" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    ln -s "${DOT_SRC}/editors/nvim" "${nvim_config_dir}"
    nvim -c 'PlugInstall' -c 'PlugUpgrade' -c 'PlugUpdate' -c 'qa'
}


function install_tmux() {
    echo "Install tmux configuration ..."
    local tpm_repo='git://github.com/tmux-plugins/tpm.git'
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [ -e "$HOME/.tmux.conf" -o -h "$HOME/.tmux.conf" ]; then
        rm "$HOME/.tmux.conf"
    fi
    if [ -e "${tpm_dir}" -o -h "${tpm_dir}" ]; then
        rm -rf "${tpm_dir}"
    fi

    git clone "${tpm_repo}" "${tpm_dir}"
    ln -s "${DOT_SRC}/tmux/.tmux.conf" "$HOME/.tmux.conf"

    local readonly session_name="dotfiles-$(date +%s)"
    tmux new-session -s "${session_name}" "${tpm_dir}/bindings/install_plugins"
}


function install_i3() {
    echo "Install i3 window manager configuration ..."
    local i3_conf_dir="$HOME/.config/i3"
    local i3status_conf_dir="$HOME/.config/i3status"
    local dunst_conf_dir="$HOME/.config/dunst"
    local wallpapers_dir="$HOME/.local/share/wallpapers"

    for dir in \
        "${i3_conf_dir}" \
        "${i3status_conf_dir}" \
        "${dunst_conf_dir}" \
        "${wallpapers_dir}"
    do
        if [ -e "${dir}" -o -h "${dir}" ]; then
            rm -r "${dir}"
        fi
    done

    ln -s "${DOT_SRC}/wm/wallpapers" "${wallpapers_dir}"
    ln -s "${DOT_SRC}/wm/i3" "${i3_conf_dir}"
    ln -s "${DOT_SRC}/wm/i3status" "${i3status_conf_dir}"
    ln -s "${DOT_SRC}/wm/dunst" "${dunst_conf_dir}"
}


function install_awesome() {
    echo "Install awesome window manager configuration ..."
    local awesome_conf_dir="$HOME/.config/awesome"

    if [ -e "${awesome_conf_dir}" -o -h "${awesome_conf_dir}" ]; then
        rm -r "${awesome_conf_dir}"
    fi

    ln -s "${DOT_SRC}/wm/awesome" "${awesome_conf_dir}"
}


function install_zsh() {
    echo "Install zsh configuration ..."
    local ohmyzsh_dir="$HOME/.oh-my-zsh"
    local zshrc="$HOME/.zshrc"
    local ohmyzsh_custom="${ohmyzsh_dir}/custom"
    local ohmyzsh_repo="git://github.com/robbyrussell/oh-my-zsh.git"
    local spaceship_repo="git://github.com/denysdovhan/spaceship-prompt.git"

    for file in "${ohmyzsh_dir}" "${zshrc}"; do
        if [ -e "${file}" -o -h "${file}" ]; then
            rm -rf "${file}"
        fi
    done

    # Oh My Zsh
    echo "Install Oh My Zsh ..."
    git clone --depth=1 "${ohmyzsh_repo}" "${ohmyzsh_dir}"

    # Spaceship theme
    echo "Install spaceship theme ..."
    mkdir -p "${ohmyzsh_custom}/themes"
    git clone "${spaceship_repo}" "${ohmyzsh_custom}/themes/spaceship-prompt"
    ln -s \
        "${ohmyzsh_custom}/themes/spaceship-prompt/spaceship.zsh-theme" \
        "${ohmyzsh_custom}/themes/spaceship.zsh-theme"

    # Symlink aliases
    echo "Install aliases ..."
    local readonly ohmyzsh_aliases="${ohmyzsh_custom}/aliases.zsh"
    if [ -e "${ohmyzsh_aliases}" -o -h "${ohmyzsh_aliases}" ]; then
        rm -r "${ohmyzsh_custom}/aliases.zsh"
    fi
    ln -s "${DOT_SRC}/zsh/aliases.zsh" "${ohmyzsh_aliases}"

    # ~/.zshrc
    echo "Symlink .zshrc ..."
    ln -s "${DOT_SRC}/zsh/.zshrc" "${zshrc}"

    echo "Change user shell ..."
    chsh -s /bin/zsh || echo 'Shell was not changed'
}


function main() {
    create_dirs
    install_packages

    install_i3
    install_awesome

    install_pyenv
    install_nvm
    install_rustup
    install_sdkman
    install_stack

    install_nvim
    install_tmux
    install_zsh
}

# Run everything
main
