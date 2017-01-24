#!/bin/bash
# Fichero: autopush.sh
# Autor: Víctor Molina Ferreira (victor)
# Fecha: 16/03/16
# Versión: 2.1.6

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

#  Descripción: Subida de los cambios a un repositorio git (ejecutar el script donde se tenga el .git)

#####################
# Colores de los mensajes
ERROR='\033[0;31m'
OK='\033[0;32m'
WARNING='\033[1;33m'
NC='\033[0m'
# Get the current version
CURRENTVERSION=$(grep '# Versión:' $0 | cut -d: -f 2 | head -1)
CURRENTVERSION=${CURRENTVERSION//[[:blank:]]/}
# Cogemos los datos del archivo .conf
source $( dirname "${BASH_SOURCE[0]}" )/user.conf
# Cogemos las variables de idioma
source $( dirname "${BASH_SOURCE[0]}" )/lang/${LANGUAGE}.po

###########
# Body script
####################

echo "Easy Push v$CURRENTVERSION"

if $show_author; then echo "$AUTHORMESSAGE: Víctor Molina [victormln.com] <contact@victormln.com> "; fi;
# Si están activadas las actualizaciones automáticas
# Doy permiso al update.sh
chmod +x $( dirname "${BASH_SOURCE[0]}" )/update.sh

if [ "$1" == "--update" ]
then
	echo -e "$SEARCHINGUPDATESMSG"
elif [ "$1" == "--conf" ]
then
	echo -e "$CONFIGURATIONMSG"
  $default_editor $( dirname "${BASH_SOURCE[0]}" )/user.conf
	exit 0
fi

# Comprobaré si hay alguna versión nueva del programa autopush
# y lo mostraré en pantalla
source $( dirname "${BASH_SOURCE[0]}" )/update.sh

# Comprobamos si existe un .git, si no existe, mostraremos un mensaje y saldremos
if [ ! -e .git ]
then
	echo -e "$NOGITMSG"
	exit 2
fi
# Guardamos en una variable si hay cambios comprobando si hay 3 lineas
# al hacer un git status
hayCambios=$(git status | wc -l)

# En caso de que haya exactamente 3 lineas en el gitstatus,
# significará que no hay nada para añadir o commitear
if [ $hayCambios -eq 3 ]
then
	echo -e "$NOCHANGESMSG"
	exit 3
fi

# Añadimos todos los archivos para subir
git add --all | tee >(echo "$ADDINGFILESMSG")
echo -e "$ALLFILESADDEDMSG"

IFS=''
if [ -z "$commit" ]
then
  # Si el usuario nos ha pasado por parametros un mensaje, lo pondremos como commit
  if [ $# -ne 0 ]
  then
    commit=""
    for var in "$@"
    do
        commit="$commit $var"
    done
  # Sino, le pediremos que mensaje quiere de commit
  else
    # Mostramos un mensaje interactivo donde introduciremos el mensaje
    # a hacer commit
    echo "$INPUTCOMMITMESSAGE"
    read commit
    if [ $? -ne 0 ]
    then
    	exit 1
    fi
  fi
else
	if $allow_edit_default_commit
	then
		read -e -i $commit commit
	fi
fi
# Realizamos el commit con el mensaje puesto en el campo de texto anterior
git commit -m "$commit"

# Guardamos el nombre de la branch actual, para luego hacer un push
# con ese nombre
branch=$(git rev-parse --abbrev-ref HEAD)
# Hacemos un push a origin
git push -u origin $branch

# Mostramos un mensaje conforme ha ido todo bien
# (aquí podria comprobar con un status si es cierto)
if [ $? -eq 0 ]
then
  echo -e "$UPLOADCHANGESDONEMSG"
  # Si tiene activadas las notificaciones, mostraremos un mensaje de Ok
  if $popup_push
  then
    # Mostrabamos un mensaje si los cambios se habian subido bien
    # Añadimos una notificación si se han realizado las subidas al repositorio correctamente
  	zenity --notification --window-icon="info" --text="$CHANGESUPLOADEDMSG" &> /dev/null &
  fi
fi
