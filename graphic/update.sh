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
ultimaVersion=$(curl -s https://raw.githubusercontent.com/victormln/easy-push/master/terminal/user.conf | tail -1 | cut -d'=' -f 2) > /dev/null
ultimaVersionSinPuntos=$( echo $ultimaVersion | tr -d ".")
# Miramos que versión tiene el usuario actualmente
versionActualSinPuntos=$(cat $( dirname "${BASH_SOURCE[0]}" )/user.conf | tail -1 | cut -d'=' -f 2 | tr -d ".")
# Comprobamos si la versionActual es igual o mas grande que la ultimaVersion
# es igual a la versionActual.
if [ $(echo "$versionActualSinPuntos>=$ultimaVersionSinPuntos" | bc) == "1" ]
then
	tieneUltimaVersion=true
else
  # Mostramos un mensaje para avisar de la nueva actualización
	zenity --question --title="¡Nueva actualización disponible!" --ok-label="Si" --cancel-label="No" --text="Hay una nueva versión de este script y se recomienda actualizar.\n\nQuieres descargarla y así tener las últimas mejoras?"
  if [ $? -eq 0 ]
  then
		directorioActual=$(pwd)
		# Nos colocamos en el directorio del script, para actualizarlo
		cd "$( dirname "${BASH_SOURCE[0]}" )"
		cd ..
    # Si es así, hacemos un pull y le actualizamos el script
  	git pull | tee >(zenity --progress --title="Nueva versión disponible" --pulsate --no-cancel --auto-close --text="Actualizando ... Por favor espere.")
		# Cambiamos al directorio donde el usuario tiene sus cambios
		cd $directorioActual
		zenity --info --title="Actualización finalizada" --ok-label="Reiniciar" --text="La actualización ha acabado. Reinicie el script para continuar."
  else
    # En el caso que seleccione que no, muestro un mensaje.
    zenity --warning --title="No se actualizará" --text="No se va a actualizar (aunque se recomienda)."
		# Damos por su puesto que tiene la ultima version,
		# para que el script no entre en bucle
		tieneUltimaVersion=true
  fi
fi
