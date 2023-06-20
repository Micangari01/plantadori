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
    echo "Escolha uma opção para o Servidor 1:"
    echo "1. MiçangáriOS 01 (https://github.com/Micangari01/plantadori.git)"
    echo "2. Servidor Personalizado"
    read -p "Digite o número da opção desejada: " server_option
    
    case $server_option in
        1)
            LINK_SERVIDOR1="https://github.com/Micangari01/plantadori.git"
            ;;
        2)
            read -p "Digite o URL do servidor personalizado: " LINK_SERVIDOR1
            ;;
        *)
            echo "Opção inválida. Usando Servidor Personalizado por padrão."
            read -p "Digite o URL do servidor personalizado: " LINK_SERVIDOR1
            ;;
    esac
    
    echo "$LINK_SERVIDOR1"
}

# Verifica se o pendrive foi identificado corretamente
PENDRIVE_DEV=$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | awk '$2 == "8G" && $3 == "disk" && $4 == "" {print $1}')
read -p "O pendrive foi identificado como ${PENDRIVE_DEV}. Deseja prosseguir? (s/n): " choice
if [ "$choice" != "s" ]; then
    read -p "Informe o caminho completo para o dispositivo do pendrive: " PENDRIVE_DEV
fi

# Monta a partição raiz do pendrive
if ! mount "${PENDRIVE_DEV}1" /mnt; then
    echo "Erro ao montar a partição raiz do pendrive."
    exit 1
fi

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
cd vpnserver || exit 1
make i_read_and_agree_the_license_agreement || exit 1

# Verifica se o arquivo de perfil existe
if [ -e "$PROFILE_FILE" ]; then
    # Carrega as configurações do perfil existente e inicia o sistema
    # Coloque aqui o código para carregar as configurações do perfil
    echo "Arquivo de perfil encontrado. Carregando as configurações..."
    if ! GIT_USERNAME=$(grep "GIT_USERNAME" "$PROFILE_FILE" | cut -d'=' -f2); then
        echo "Erro ao obter o nome de usuário do Git do arquivo de perfil."
        exit 1
    fi
    if ! GIT_PASSWORD=$(grep "GIT_PASSWORD" "$PROFILE_FILE" | cut -d'=' -f2); then
        echo "Erro ao obter a senha de acesso do Git do arquivo de perfil."
        exit 1
    fi
    if ! LINK_SER

VIDOR1=$(grep "LINK_SERVIDOR1" "$PROFILE_FILE" | cut -d'=' -f2); then
        echo "Erro ao obter o endereço do servidor 1 do arquivo de perfil."
        exit 1
    fi
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
# Obtém a lista de versões disponíveis do Alpine Linux
VERSIONS_URL="https://dl-cdn.alpinelinux.org/alpine"
AVAILABLE_VERSIONS=$(wget -qO- "$VERSIONS_URL" | grep -oP 'v\d+\.\d+(\.\d+)?(?=/releases/)')

# Exibe a lista de versões disponíveis para o usuário escolher
echo "Versões disponíveis do Alpine Linux:"
echo "$AVAILABLE_VERSIONS"
echo ""

# Solicita ao usuário que escolha uma versão
read -p "Digite a versão do Alpine Linux (exemplo: 3.14.2): " ALPINE_VERSION

# Obtém a lista de opções de flavor disponíveis
AVAILABLE_FLAVORS=("standard" "extended" "netboot" "rpi" "uboot" "minirootfs" "virt" "xen")

# Exibe a lista de opções de flavor disponíveis para o usuário escolher
echo "Flavors disponíveis:"
for flavor in "${AVAILABLE_FLAVORS[@]}"; do
  echo "$flavor"
done
echo ""

# Solicita ao usuário que escolha um flavor
read -p "Digite o flavor desejado (exemplo: standard): " FLAVOR

# Obtém a lista de arquiteturas disponíveis para a versão escolhida
ARCHITECTURES_URL="$VERSIONS_URL/v$ALPINE_VERSION/releases"
AVAILABLE_ARCHITECTURES=$(wget -qO- "$ARCHITECTURES_URL" | grep -oP '(?<=/releases/)\w+')

# Exibe a lista de arquiteturas disponíveis para a versão escolhida
echo "Arquiteturas disponíveis para a versão $ALPINE_VERSION:"
#!/bin/bash

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
# Obtém a lista de versões disponíveis do Alpine Linux
VERSIONS_URL="https://dl-cdn.alpinelinux.org/alpine"
AVAILABLE_VERSIONS=$(wget -qO- "$VERSIONS_URL" | grep -oP 'v\d+\.\d+(\.\d+)?(?=/releases/)')

# Exibe a lista de versões disponíveis para o usuário escolher
echo "Versões disponíveis do Alpine Linux:"
echo "$AVAILABLE_VERSIONS"
echo ""

# Solicita ao usuário que escolha uma versão
read -p "Digite a versão do Alpine Linux (exemplo: 3.14.2): " ALPINE_VERSION

# Verifica se a versão escolhida está presente na lista de versões disponíveis
if [[ ! "$AVAILABLE_VERSIONS" =~ (^|[[:space:]])"$ALPINE_VERSION"($|[[:space:]]) ]]; then
    echo "Versão inválida. Selecione uma versão disponível."
    umount /mnt
    exit 1
fi

# Obtém a lista de opções de flavor disponíveis
AVAILABLE_FLAVORS=("standard" "extended" "netboot" "rpi" "uboot" "minirootfs" "virt" "xen")

# Exibe a lista de opções de flavor disponíveis para o usuário escolher
echo "Flavors disponíveis:"
for flavor in "${AVAILABLE_FLAVORS[@]}"; do
    echo "$flavor"
done
echo ""

# Solicita ao usuário que escolha um flavor
read -p "Digite o flavor desejado (exemplo: standard): " FLAVOR

# Verifica se o flavor escolhido está presente na lista de flavors disponíveis
if [[ ! " ${AVAILABLE_FLAVORS[*]} " =~ (^|[[:space:]])"$FLAVOR"($|[[:space:]]) ]]; then
    echo "Flavor inválido. Selecione um flavor disponível."
    umount /mnt
    exit 1
fi

# Obtém a lista de arquiteturas disponíveis
ARCHITECTURES_URL="$VERSIONS_URL/v$ALPINE_VERSION/releases/$FLAVOR"
AVAILABLE_ARCHITECTURES=$(wget -qO- "$ARCHITECTURES_URL" | grep -oP '(?<=href=")[^"]+(?=/")')

# Exibe a lista de arquiteturas disponíveis para o usuário escolher
echo "Arquiteturas disponíveis:"
echo "$AVAILABLE_ARCHITECTURES"
echo ""

# Solicita ao usuário que escolha uma arquitetura
read -p "Digite o tipo de processador (exemplo: x86_64): " ARCHITECTURE

# Verifica se a arquitetura escolhida está presente na lista de arquiteturas disponíveis
if [[ ! " ${AVAILABLE_ARCHITECTURES[*]} " =~ (^|[[:space:]])"$ARCHITECTURE"($|[[:space:]]) ]]; then
    echo "Arquitetura inválida. Selecione uma arquitetura disponível."
    umount /mnt
    exit 1
fi

ALPINE_URL="$ARCHITECTURES_URL/$ARCHITECTURE/alpine-${FLAVOR}-${ALPINE_VERSION}-${ARCHITECTURE}.iso"
ALPINE_SHA256="${ALPINE_URL}.sha256"
ALPINE_GPG="${ALPINE_URL}.asc"

echo "Baixando a imagem do Alpine Linux do endereço: $ALPINE_URL"
if ! wget -P /mnt "$ALPINE_URL"; then
    echo "Erro ao baixar a imagem do Alpine Linux."
    umount /mnt
    exit 1
fi

echo "Baixando o arquivo SHA256 do endereço: $ALPINE_SHA256"
if ! wget -P /mnt "$ALPINE_SHA256"; then
    echo "Erro ao baixar o arquivo SHA256."
    umount /mnt
    exit 1
fi

echo "Baixando o arquivo GPG do endereço: $ALPINE_GPG"
if ! wget -P /mnt "$ALPINE_GPG"; then
    echo "Erro ao baixar o arquivo GPG."
    umount /mnt
    exit 1
fi

# Verificação da imagem do Alpine Linux
echo "Verificando a integridade da imagem do Alpine Linux..."
cd /mnt || exit 1
if ! sha256sum -c "$(basename "$ALPINE_SHA256")"; then
    echo "Erro na verificação da integridade da imagem do Alpine Linux."
    umount /mnt
    exit 1
fi

# Desmonta a partição raiz do pendrive
umount /mnt

cat > /mnt/git_config.cfg <<EOL
# Configurações do usuário do MiçangáriOS
GIT_USERNAME="$GIT_USERNAME"
GIT_PASSWORD="$GIT_PASSWORD"

# Links para servidores e serviços adequados
LINK_SERVIDOR1="$LINK_SERVIDOR1"
LINK_SERVIDOR2="http://localhost"
EOL

# Código para download da imagem do Alpine Linux, arquivos SHA256 e GPG
# Obtém a lista de versões disponíveis do Alpine Linux
VERSIONS_URL="https://dl-cdn.alpinelinux.org/alpine"
AVAILABLE_VERSIONS=$(wget -qO- "$VERSIONS_URL" | grep -oP 'v\d+\.\d+(\.\d+)?(?=/releases/)')

# Exibe a lista de versões disponíveis para o usuário escolher
echo "Versões disponíveis do Alpine Linux:"
echo "$AVAILABLE_VERSIONS"
echo ""

# Solicita ao usuário que escolha uma versão
read -p "Digite a versão do Alpine Linux (exemplo: 3.14.2): " ALPINE_VERSION

# Verifica se a versão escolhida está presente na lista de versões disponíveis
if [[ ! "$AVAILABLE_VERSIONS" =~ (^|[[:space:]])"$ALPINE_VERSION"($|[[:space:]]) ]]; then
    echo "Versão inválida. Selecione uma versão disponível."
    umount /mnt
    exit 1
fi

# Obtém a lista de opções de flavor disponíveis
AVAILABLE_FLAVORS=("standard" "extended" "netboot" "rpi" "uboot" "minirootfs" "virt" "xen")

# Exibe a lista de opções de flavor disponíveis para o usuário escolher
echo "Flavors disponíveis:"
for flavor in "${AVAILABLE_FLAVORS[@]}"; do
    echo "$flavor"
done
echo ""

# Solicita ao usuário que escolha um flavor
read -p "Digite o flavor desejado (exemplo: standard): " FLAVOR

# Verifica se o flavor escolhido está presente na lista de flavors disponíveis
if [[ ! " ${AVAILABLE_FLAVORS[*]} " =~ (^|[[:space:]])"$FLAVOR"($|[[:space:]]) ]]; then
    echo "Flavor inválido. Selecione um flavor disponível."
    umount /mnt
    exit 1
fi

# Obtém a lista de arquiteturas disponíveis
ARCHITECTURES_URL="$VERSIONS_URL/v$ALPINE_VERSION/releases/$FLAVOR"
AVAILABLE_ARCHITECTURES=$(wget -qO- "$ARCHITECTURES_URL" | grep -oP '(?<=href=")[^"]+(?=/")')

# Exibe a lista de arquiteturas disponíveis para o usuário escolher
echo "Arquiteturas disponíveis:"
echo "$AVAILABLE_ARCHITECTURES"
echo ""

# Solicita ao usuário que escolha uma arquitetura
read -p "Digite o tipo de processador (exemplo: x86_64): " ARCHITECTURE

# Verifica se a arquitetura escolhida está presente na lista de arquiteturas disponíveis
if [[ ! " ${AVAILABLE_ARCHITECTURES[*]} " =~ (^|[[:space:]])"$ARCHITECTURE"($|[[:space:]]) ]]; then
    echo "Arquitetura inválida. Selecione uma arquitetura disponível."
    umount /mnt
    exit 1
fi

ALPINE_URL="$ARCHITECTURES_URL/$ARCHITECTURE/alpine-${FLAVOR}-${ALPINE_VERSION}-${ARCHITECTURE}.iso"
ALPINE_SHA256="${ALPINE_URL}.sha256"
ALPINE_GPG="${ALPINE_URL}.asc"

echo "Baixando a imagem do Alpine Linux do endereço: $ALPINE_URL"
if ! wget -P /mnt "$ALPINE_URL"; then
    echo "Erro ao baixar a imagem do Alpine Linux."
    umount /mnt
    exit 1
fi

echo "Baixando o arquivo SHA256 do endereço: $ALPINE_SHA256"
if ! wget -P /mnt "$ALPINE_SHA256"; then
    echo "Erro ao baixar o arquivo SHA256."
    umount /mnt
    exit 1
fi

echo "Baixando o arquivo GPG do endereço: $ALPINE_GPG"
if ! wget -P /mnt "$ALPINE_GPG"; then
    echo "Erro ao baixar o arquivo GPG."
    umount /mnt
    exit 1
fi

# Verificação da imagem do Alpine Linux
echo "Verificando a integridade da imagem do Alpine Linux..."
cd /mnt || exit 1
if ! sha256sum -c "$(basename "$ALPINE_SHA256")"; then
    echo "Erro na verificação da integridade da imagem do Alpine Linux."
    umount /mnt
    exit 1
fi

# Desmonta a partição raiz do pendrive
umount /mnt
