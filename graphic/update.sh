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

# Inicio una variable de si se ha reiniciado el programa a false
reiniciar=false
# Hago un cd al directorio anterior para situarme en la raiz del script
cd ..
# Miramos si hay algo nuevo subido
git remote update &> /dev/null
# Guardamos la linea donde pone si está up-to-date o is behind
ultimaVersion=$(git status -uno | head -2 | tail -1 | grep "is behind")
if [ $? -eq 0 ]
then
  # Mostramos un mensaje para avisar de la nueva actualización
	zenity --question --title="¡Nueva actualización disponible!" --ok-label="Si" --cancel-label="No" --text="Hay una nueva versión de este script y se recomienda actualizar.\n\nQuieres descargarla y así tener las últimas mejoras?"
  if [ $? -eq 0 ]
  then
    # Si es así, hacemos un pull y le actualizamos el script
  	git pull | tee >(zenity --progress --title="Actualizando" --pulsate --no-cancel --auto-close --text="Actualizando ... Por favor espere.")
    zenity --info --title="Actualización finalizada" --ok-label="Reiniciar" --text="La actualización ha acabado. Reinicie el script para continuar."
		reiniciar=true
  else
    # En el caso que seleccione que no, muestro un mensaje.
    zenity --warning --title="No se actualizará" --text="No se va a actualizar (aunque se recomienda)."
  fi
fi
