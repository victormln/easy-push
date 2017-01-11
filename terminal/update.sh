#!/bin/bash
# Fitxer: update.sh
# Autor: Víctor Molina Ferreira (victor)
# Data: 26/12/2016
# Versión: 1.0

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

#  Descripción: Comprueba si el script está a la ultima version

tieneUltimaVersion=false
# Conseguimos la ultima version que hay en github y le quitamos los puntos
ultimaVersion=$(curl -s https://raw.githubusercontent.com/victormln/easy-push/master/terminal/user.conf | tail -1 | cut -d'=' -f 2 | tr -d ".") &> /dev/null
# Miramos que versión tiene el usuario actualmente
versionActual=$(cat $( dirname "${BASH_SOURCE[0]}" )/user.conf | tail -1 | cut -d'=' -f 2 | tr -d ".")
echo $ultimaVersion
echo $versionActual
# Comprobamos si la ultimaVersion que hay disponible
# es menor o igual a la versionActual
# así yo como desarrollador, puedo subir una versión más nuevas sin que interfiera
if [ $(echo "$ultimaVersion<=$versionActual" | bc) == "1" ]
then
	tieneUltimaVersion=true
	echo "Tiene la ultima version disponible"
else
	# Mostramos un mensaje para avisar de la nueva actualización
	echo "##################################################"
	echo -e "${WARNING}¡NUEVA ACTUALIZACIÓN!${NC}"
	echo "##################################################"
  echo "Hay una nueva versión de este script y se recomienda actualizar."
  echo "Quieres descargarla y así tener las últimas mejoras? y/n o s/n"
  # Preguntamos si quiere actualizar
  read actualizar
  if [ $actualizar == "s" ] || [ $actualizar == "y" ]
  then
    # Si es así, hacemos un pull y le actualizamos el script
  	git pull | tee >(echo "Actualizando... Por favor, espere ...")
    echo -e "${OK}[OK] ${NC}La actualización ha acabado, por favor, vuelva a iniciar el script.";
  else
    # En el caso que seleccione que no, muestro un mensaje.
    echo -e "${WARNING}¡AVISO!${NC} NO se actualizará (aunque se recomienda)."
  fi
fi
