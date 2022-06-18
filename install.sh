#!/bin/bash

GREEN='\033[0;32m'
RESET='\033[0m'

echo -e "${GREEN}Welcome to Setup Script for Fedora Workstation!${RESET}"
echo -e $"${GREEN}Script to install some programs and tools in Fedora Workstation!${RESET}\n"

echo -e $"${GREEN}Making dnf faster (with deltarpm and fastestmirror)...${RESET}\n"
echo "fastestmirror=true
deltarpm=true" | sudo tee -a /etc/dnf/dnf.conf > /dev/null
echo $"Ok!\n"

echo -e $"${GREEN}Updating system...${RESET}\n"
sudo dnf update -y
echo $"Ok!\n"

echo -e $"${GREEN}Installing RPM Fusion repositories...${RESET}\n"
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf groupupdate core -y
echo $"Ok! \n"

echo -e $"${GREEN}Updating system...${RESET}\n"
sudo dnf update -y
echo $"Ok!\n"

echo -e $"${GREEN}Installing Codecs...${RESET}\n"
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf groupupdate sound-and-video -y
echo $"Ok! \n"

echo -e $"${GREEN}Adding Flatpak repository...${RESET}\n"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo $"Ok!\n"

echo -e $"${GREEN}Installing Discord and Spotify, both Flatpak...${RESET}\n"
flatpak install discord spotify
echo $"Ok!\n"

echo -e $"${GREEN}Installing Oh My Zsh with plugins(zsh-autosuggestions and zsh-syntax-highlighting) and theme(powerlevel10k)...${RESET}\n"
sudo dnf install zsh autojump sqlite -y
echo
sudo usermod $USER -s /bin/zsh
echo
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
cp -f .p10k.zsh .zsh_history .zshrc ~
echo $"Ok!\n"

echo -e $"${GREEN}Installing OpenJDK17, NodeJs, Yarn...${RESET}\n"
sudo dnf install java-17-openjdk-devel java-17-openjdk-headless java-17-openjdk-javadoc nodejs -y
echo
sudo npm install --global yarn
echo
yarn config set prefix ~/.local
echo
sudo npm upgrade --global yarn
echo $"Ok!\n"

echo -e $"${GREEN}Installing Visual Studio Code, Intellij IDEA Ultimate 2022.1.2, Insomnia 2022.4.1...${RESET}\n"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
echo
sudo dnf update -y
echo
sudo dnf install code -y
echo
wget https://download.jetbrains.com/idea/ideaIU-2022.1.2.tar.gz
echo
tar -xzvf ideaIU-2022.1.2.tar.gz > /dev/null
sudo mv `find . -name "idea-IU*"` /opt/intellij
sudo ln -rs /opt/intellij/bin/idea.sh /usr/bin/intellij
rm -f `find . -name "idea-IU*"`
echo $'After running this script, run "intellij" on terminal, and create desktop entry\n'
wget https://github.com/Kong/insomnia/releases/download/core%402022.4.1/Insomnia.Core-2022.4.1.rpm
echo
sudo dnf install ./Insomnia.Core-2022.4.1.rpm -y
rm -f Insomnia.Core-2022.4.1.rpm
echo $"Ok!\n"

echo -e $"${GREEN}Installing Google Chrome, Transmisson(BitTorrent client gtk), GNOME Power Manager, GNOME Tweaks, Telegram...${RESET}\n"
sudo dnf install google-chrome-stable transmission-gtk gnome-power-manager gnome-tweaks telegram-desktop -y
echo $"Ok!\n"

echo -e $"${GREEN}Installing Steam and Lutris...${RESET}\n"
sudo dnf install steam lutris -y
echo $"Ok!\n"
