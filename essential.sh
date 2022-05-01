# Required dependencies for all softwares (important)
echo "Installing complete dependencies pack."
# sudo apt install -y software-properties-common apt-transport-https checkinstall libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libc6-dev libbz2-dev autoconf automake libtool make g++ unzip flex bison gcc libyaml-dev libreadline-dev zlib1g zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev libpq-dev libpcap-dev libmagickwand-dev libcurl4 libcurl4-openssl-dev mlocate imagemagick xdg-utils
sudo apt install -y build-essential manpages-dev
sudo apt install -y gobjc gfortran gnat

# Upgrade and Update Command
echo "Updating and upgrading before performing further operations."
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y

#Installing curl and wget
echo "Installing Curl and wget"
sudo apt install -y wget curl

#Installing dig and net-tools
echo "Installing DNS Utils and net-tools"
sudo apt install -y dnsutils net-tools

#Installing ADB and Fastboot
echo "Installing ADB and Fastboot"
sudo apt install -y android-tools-adb android-tools-fastboot

#Installing clipboards
echo "Installing Clipboards"
sudo apt install -y xsel xclip wl-clipboard

#Installing ssh server
echo "Installing SSH Server"
sudo apt-get install -y openssh-server

 #Installing Git
echo "Installing Git"
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt install -y git

