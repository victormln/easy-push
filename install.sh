#!/bin/bash
# Hace una instalación del easy-push en modo gráfico y en modo terminal

# Creo un alias para el modo grafico y modo terminal
actualDir=$(pwd)
echo "alias gp=\"$actualDir/terminal/autopush.sh\"" >> ~/.bashrc
echo "alias gpg=\"$actualDir/graphic/autopush.sh\"" >> ~/.bashrc
