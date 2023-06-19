#!/bin/bash

# Variáveis de configuração
PENDRIVE_DEV=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | awk '$2 == "8G" && $3 == "disk" && $4 == "" {print $1}')
ALPINE_ISO="alpine-linux-extended.iso"
PROFILE_FILE="/mnt/profile.txt"

# Função para obter o endereço GIT
get_git_address() {
    read -p "Informe o endereço GIT para download da imagem do MiçangáriOS: " GIT_ADDRESS
    echo "$GIT_ADDRESS"
}

# Verifica se o pendrive foi identificado corretamente
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
    GIT_ADDRESS=$(grep "GIT_ADDRESS" "$PROFILE_FILE" | cut -d'=' -f2)
else
    # Obtém o endereço GIT para download da imagem do MiçangáriOS
    echo "Arquivo de perfil não encontrado. Será necessário obter o endereço GIT."
    GIT_ADDRESS=$(get_git_address)
fi

# Configuração do arquivo de configuração MAINPAGE do GIT
cat > /mnt/git_config.cfg <<EOL
# Configurações do usuário do MiçangáriOS
GIT_USERNAME="seu_nome_de_usuário"
GIT_PASSWORD="sua_senha_de_acesso"

# Links para servidores e serviços adequados
LINK_SERVIDOR1="https://servidor1.com"
LINK_SERVIDOR2="https://servidor2.com"
EOL

# Código para download da imagem do MiçangáriOS do endereço GIT
echo "Baixando a imagem do MiçangáriOS do endereço GIT: $GIT_ADDRESS"
# Coloque aqui o código para fazer o download da imagem do MiçangáriOS do endereço GIT

# Desmonta a partição raiz do pendrive
umount /mnt

# Executa o MiçangáriOS diretamente do GIT e acessa a partição de armazenamento persistente
# Coloque aqui o código para executar o MiçangáriOS do GIT e acessar a partição de armazenamento persistente

