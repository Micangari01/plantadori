#!/bin/bash

# Variáveis de configuração
PROFILE_FILE="/mnt/profile.txt"

# Função para obter as credenciais do Git
get_git_credentials() {
    read -p "Informe o nome de usuário do Git: " GIT_USERNAME
    read -s -p "Informe a senha de acesso do Git: " GIT_PASSWORD
    echo
}

# Função para obter o endereço do servidor 1
get_server1_address() {
    read -p "Informe o endereço do servidor 1: " LINK_SERVIDOR1
    echo "$LINK_SERVIDOR1"
}

# Verifica se o pendrive foi identificado corretamente
PENDRIVE_DEV=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | awk '$2 == "8G" && $3 == "disk" && $4 == "" {print $1}')
read -p "O pendrive foi identificado como ${PENDRIVE_DEV}. Deseja prosseguir? (s/n): " choice
if [ "$choice" != "s" ]; then
    read -p "Informe o caminho completo para o dispositivo do pendrive: " PENDRIVE_DEV
fi

# Monta a partição raiz do pendrive
mount "${PENDRIVE_DEV}1" /mnt

# Configuração do armazenamento persistente
sed -i 's/APPEND/root=\/dev\/sda1 persistence/' /mnt/syslinux/syslinux.cfg

# Configuração do servidor PXE
cat >> /mnt/boot/syslinux/syslinux.cfg <<EOL

LABEL pxe
  MENU LABEL PXE Server
  KERNEL /boot/vmlinuz-grsec
  APPEND initrd=/boot/initramfs-grsec alpine_dev=usbpersist modules=loop,cryptoloop,squashfs,sd-mod,usb-storage quiet
EOL

# Configuração do SoftEther VPN
wget "https://www.softether-download.com/files/softether/v4.36-9754-beta-2021.07.20-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.36-9754-beta-2021.07.20-linux-x64-64bit.tar.gz"
tar xzf softether-vpnserver-v4.36-9754-beta-2021.07.20-linux-x64-64bit.tar.gz
cd vpnserver
make i_read_and_agree_the_license_agreement

# Verifica se o arquivo de perfil existe
if [ -e "$PROFILE_FILE" ]; then
    # Carrega as configurações do perfil existente e inicia o sistema
    # Coloque aqui o código para carregar as configurações do perfil
    echo "Arquivo de perfil encontrado. Carregando as configurações..."
    GIT_USERNAME=$(grep "GIT_USERNAME" "$PROFILE_FILE" | cut -d'=' -f2)
    GIT_PASSWORD=$(grep "GIT_PASSWORD" "$PROFILE_FILE" | cut -d'=' -f2)
    LINK_SERVIDOR1=$(grep "LINK_SERVIDOR1" "$PROFILE_FILE" | cut -d'=' -f2)
else
    # Obtém as informações do Git e o endereço do servidor 1
    echo "Arquivo de perfil não encontrado. Será necessário obter as informações."
    get_git_credentials
    get_server1_address
fi

# Configuração do arquivo de configuração MAINPAGE do Git
cat > /mnt/git_config.cfg <<EOL
# Configurações do usuário do MiçangáriOS
GIT_USERNAME="$GIT_USERNAME"
GIT_PASSWORD="$GIT_PASSWORD"

# Links para servidores e serviços adequados
LINK_SERVIDOR1="$LINK_SERVIDOR1"
LINK_SERVIDOR2="http://localhost"
EOL

# Código para download da imagem do Alpine Linux, arquivos SHA256 e GPG
ALPINE_VERSION="3.14.2"
ARCHITECTURE="x86_64"
ALPINE_ISO="alpine-standard-${ALPINE_VERSION}-${ARCHITECTURE}.iso"
ALPINE_SHA256="${ALPINE_ISO}.sha256"
ALPINE_GPG="${ALPINE_ISO}.asc"

ALPINE_URL="https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/releases/${ARCHITECTURE}/${ALPINE_ISO}"
ALPINE_SHA256_URL="https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/releases/${ARCHITECTURE}/${ALPINE_SHA256}"
ALPINE_GPG_URL="https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/releases/${ARCHITECTURE}/${ALPINE_GPG}"

echo "Baixando a imagem do Alpine Linux do endereço: $ALPINE_URL"
wget -P /mnt $ALPINE_URL

echo "Baixando o arquivo SHA256 do endereço: $ALPINE_SHA256_URL"
wget -P /mnt $ALPINE_SHA256_URL

echo "Baixando o arquivo GPG do endereço: $ALPINE_GPG_URL"
wget -P /mnt $ALPINE_GPG_URL

# Verificação da imagem do Alpine Linux
echo "Verificando a integridade da imagem do Alpine Linux..."
cd /mnt
sha256sum -c $ALPINE_SHA256

# Desmonta a partição raiz do pendrive
umount /mnt

# Executa o MiçangáriOS diretamente do Git e acessa a partição de armazenamento persistente
# Coloque aqui o código para executar o MiçangáriOS do Git e acessar a partição de armazenamento persistente
