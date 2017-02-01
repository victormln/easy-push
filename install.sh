#!/bin/bash
# Hace una instalación del easy-push en modo gráfico y en modo terminal

# Mensajes de color
ERROR='\033[0;31m'
OK='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Creo un alias para el modo grafico y modo terminal
actualDir=$(pwd)
echo "alias gp=\"$actualDir/terminal/autopush.sh\"" >> ~/.bashrc
echo "alias gpg=\"$actualDir/graphic/autopush.sh\"" >> ~/.bashrc
echo -e "${OK}[OK]${NC} Instalación finalizada."
echo -e "Reinicie este terminal y ejecute ${BLUE}gp -v${NC} para comprobar que se ha instalado correctamente."
exit
