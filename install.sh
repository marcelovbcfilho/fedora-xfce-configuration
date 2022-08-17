#!/bin/bash

# Upgrading os
echo "Upgrading..."
sudo dnf upgrade -y

# Adding RPM Fusion
echo "Adding RPM Fusion..."
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf upgrade -y

# Installing media codecs (youtube/twitch lives and some video file compatibility)
echo "Installing media codecs..."
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y

# Installing docker
echo "Installing docker..."
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo -y
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Installing plank
echo "Installing plank..."
sudo dnf install plank -y

# Installing maven
echo "Installing maven..."
sudo dnf install maven -y

# XFCE Global menu configuration
echo "Installing XFCE Global menu plugin..."
sudo echo "[copr:copr.fedorainfracloud.org:jcornuz:xfce-global-menu]
name=Copr repo for xfce-global-menu owned by jcornuz
baseurl=https://download.copr.fedorainfracloud.org/results/jcornuz/xfce-global-menu/fedora-rawhide-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/jcornuz/xfce-global-menu/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1" >> /etc/yum.repos.d/jcornuz-xfce-global-menu-fedora-rawhide.repo
sudo dnf upgrade -y
sudo dnf install xfce4-vala-panel-appmenu-plugin -y

# XFCE Fix for global menu
xfconf-query -c xsettings -p /Gtk/ShellShowsMenubar -n -t bool -s true
xfconf-query -c xsettings -p /Gtk/ShellShowsAppmenu -n -t bool -s true

# ZSH and Oh my zsh
echo "Installing zsh and Oh my zsh..."
sudo dnf install git -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Manually update the .zshrc ZSH_THEM to \"powerlevel10k/powerlevel10k\""
echo "Manually update the .zshrc plugins to include \"(git npm zsh-autosuggestions zsh-syntax-highlighting history)\""

# SDK Man
echo "Installing SDK Man..."
curl -s "https://get.sdkman.io" | bash

# Flathub and flathub beta
echo "Configuring flathub and flathub beta..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak update

# Installing default apps
echo "Installing default apps..."

echo "Intellij IDEA Ultimate..."
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Ultimate -y

echo "Android Studio..."
flatpak install flathub com.google.AndroidStudio -y

echo "GitHub Desktop..."
flatpak install flathub io.github.shiftey.Desktop -y

echo "Discord..."
flatpak install flathub com.discordapp.Discord -y

echo "Zulip..."
flatpak install flathub org.zulip.Zulip -y

echo "Slack..."
flatpak install flathub com.slack.Slack -y

echo "Insonia..."
flatpak install flathub rest.insomnia.Insomnia -y

echo "Godot..."
flatpak install flathub org.godotengine.Godot -y

# Default folders
echo "Creating Workspaces and default folders..."
mkdir ~/Workspaces
mkdir ~/Workspaces/Estudos
mkdir ~/Workspaces/Estudos/Godot

# Configuring ssh
echo "Configuring SSH please confirm location and requested info..."
ssh-keygen

# Customization
echo "Papirus icon theme..."
wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="$HOME/.icons" sh

echo "Adw theme..."
sudo dnf install ninja-build git meson sassc
mkdir ~/Downloads/adw
git clone https://github.com/lassekongo83/adw-gtk3.git ~/Downloads/adw
cd ~/Downloads/adw
meson -Dprefix="${HOME}/.local" build
ninja -C build install