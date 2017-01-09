#!/bin/bash
# Fitxer: autopush.sh
# Autor: Víctor Molina Ferreira (victor)
# Data: 16/03/16
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

#  Descripción: Subida de los cambios a un repositorio git (ejecutar el script donde se tenga el .git)

#####################
# Colores de los mensajes
ERROR='\033[0;31m'
OK='\033[0;32m'
WARNING='\033[1;33m'
NC='\033[0m'
# Guardo el directorio actual donde se hará el push,
# para no perder la referencia
directorioActual=$(pwd)
# Cambio al directorio del script para poder ejecutar el update.sh
cd "$( dirname "${BASH_SOURCE[0]}" )"
# Cogemos los datos del archivo .conf
source user.conf
# Si están activadas las actualizaciones automáticas
if $search_ota
then
  # Doy permiso al update.sh
  chmod +x update.sh
  # Comprobaré si hay alguna versión nueva del programa autopush
  # y lo mostraré en pantalla
  source update.sh
  # Si ha querido actualizar, reiniciaremos el script
  if $reiniciar
  then
    # Volvemos a poner la variable reiniciar a false
    reiniciar=false
    # Iniciamos de nuevo el script para ejecutar el script actualizado
    exec $( dirname "${BASH_SOURCE[0]}" )/terminal/autopush.sh
    # Cambio al directorio que estaba el usuario (donde quiere hacer el push)
    cd $directorioActual
  fi
fi

# Comprobamos si existe un .git, si no existe, mostraremos un mensaje y saldremos
if [ ! -e .git ]
then
	echo -e "${ERROR}[ERROR] ${NC}No hay ningún .git"
	exit 2
fi
# Guardamos en una variable si hay cambios comprobando si hay 3 lineas
# al hacer un git status
hayCambios=$(git status | wc -l)

# En caso de que haya exactamente 3 lineas en el gitstatus,
# significará que no hay nada para añadir o commitear
if [ $hayCambios -eq 3 ]
then
	echo -e "${WARNING}[AVISO] ${NC}No se han encontrado cambios a subir."
	exit 3
fi

# Añadimos todos los archivos para subir
git add --all | tee >(echo "Añadiendo archivos al commit ...")
echo -e "${OK}[OK] ${NC}Todos los archivos añadidos correctamente."

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
    echo "Introduce el mensaje del commit (P.e: Añadidas mejoras):"
    read commit
    if [ $? -ne 0 ]
    then
    	exit 1
    fi
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
  echo -e "${OK}[OK] ${NC}Se han subido todos los cambios correctamente."
  # Si tiene activadas las notificaciones, mostraremos un mensaje de Ok
  if $popup_push
  then
    # Mostrabamos un mensaje si los cambios se habian subido bien
    # Añadimos una notificación si se han realizado las subidas al repositorio correctamente
  	zenity --notification --window-icon="info" --text="Cambios subidos correctamente" &> /dev/null &
  fi
fi
