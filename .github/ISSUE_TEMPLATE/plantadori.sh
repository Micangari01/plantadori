#!/bin/bash

# Obtém a lista de versões disponíveis do Alpine Linux
VERSIONS_URL="https://dl-cdn.alpinelinux.org/alpine"
AVAILABLE_VERSIONS=$(wget -qO- $VERSIONS_URL | grep -oP 'v\d+\.\d+(\.\d+)?(?=/releases/)')

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
AVAILABLE_ARCHITECTURES=$(wget -qO- $ARCHITECTURES_URL | grep -oP '(?<=/releases/)\w+')

# Exibe a lista de arquiteturas disponíveis para a versão escolhida
echo "Arquiteturas disponíveis para a versão $ALPINE_VERSION:"
echo "$AVAILABLE_ARCHITECTURES"
echo ""

# Solicita ao usuário que escolha uma arquitetura
read -p "Digite o tipo de processador (exemplo: x86_64): " ARCHITECTURE

ALPINE_URL="https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/releases/${ARCHITECTURE}/alpine-${FLAVOR}-${ALPINE_VERSION}-${ARCHITECTURE}.iso"
ALPINE_SHA256="${ALPINE_URL}.sha256"
ALPINE_GPG="${ALPINE_URL}.asc"

echo "Baixando a imagem do Alpine Linux do endereço: $ALPINE_URL"
wget -P /mnt $ALPINE_URL

echo "Baixando o arquivo SHA256 do endereço: $ALPINE_SHA256"
wget -P /mnt $ALPINE_SHA256

echo "Baixando o arquivo GPG do endereço: $ALPINE_GPG"
wget -P /mnt $ALPINE_GPG

# Verificação da imagem do Alpine Linux
echo "Verificando a integridade da imagem do Alpine Linux..."
cd /mnt
sha256sum -c $(basename $ALPINE_SHA256)

# Desmonta a partição raiz do pendrive
umount /mnt

# Executa o MiçangáriOS diretamente do Git e acessa a partição de armazenamento persistente
# Coloque aqui o código para executar o MiçangáriOS do Git e acessar a partição de armazenamento persistente

