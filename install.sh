#!/bin/bash
# Hace una instalación del easy-push en modo gráfico y en modo terminal

# Mensajes de color
ERROR='\033[0;31m'
OK='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Creo un alias para el modo grafico y modo terminal
actualDir=$(pwd)
actualShell=$(echo $SHELL | grep zsh)
if [ $? -eq 0 ]
then
    actualShell="zshrc"
else
    actualShell="bashrc"
fi
echo "alias gp=\"$actualDir/terminal/autopush.sh\"" >> ~/.$actualShell
echo "alias gpg=\"$actualDir/graphic/autopush.sh\"" >> ~/.$actualShell
echo -e "${OK}[OK]${NC} Instalación finalizada."
echo -e "Reinicie este terminal y ejecute ${BLUE}gp -v${NC} para comprobar que se ha instalado correctamente."
exit
