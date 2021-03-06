#!/bin/bash
# Fitxer: autopush_graphic.sh
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

# Cogemos los datos del archivo .conf
source $( dirname "${BASH_SOURCE[0]}" )/user.conf
# Si están activadas las actualizaciones automáticas
if $search_ota
then
  # Doy permiso al update.sh
  chmod +x $( dirname "${BASH_SOURCE[0]}" )/update.sh
  # Comprobaré si hay alguna versión nueva del programa autopush
  # y lo mostraré en pantalla
  source $( dirname "${BASH_SOURCE[0]}" )/update.sh
  # Si no tiene la ultima version y ha actualizado, volvemos a ejecutar el script
  if ! $tieneUltimaVersion
  then
    # Iniciamos de nuevo el script para ejecutar el script actualizado
    exec $( dirname "${BASH_SOURCE[0]}" )/autopush.sh
  fi
fi

# Comprobamos si existe un .git, si no existe, mostraremos un mensaje y saldremos
if [ ! -e .git ]
then
	zenity --error --title="Error .git" --text="No hay ningún .git en este directorio."
	exit 2
fi

# Guardamos en una variable si hay cambios comprobando si hay 3 lineas
# al hacer un git status
hayCambios=$(git status | wc -l)
# En caso de que haya exactamente 3 lineas en el gitstatus,
# significará que no hay nada para añadir o commitear
if [ $hayCambios -eq 3 ]
then
	zenity --warning --title="No hay cambios" --text="No se han encontrado cambios a subir."
	exit 3
fi

# Añadimos todos los archivos para subir
git add --all | tee >(zenity --progress --pulsate --title="Añadiendo archivos" --no-cancel --auto-close --text="Añadiendo archivos (git add --all)...")

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
    commit=$(zenity --entry --title="Mensaje del commit" --text="Introduce el mensaje del commit:" --entry-text "P.e: Añadidas mejoras")
    # Si el usuario ha cancelado el commit, saldremos del script
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
git push -u origin $branch | tee >(zenity --progress --title="Subiendo cambios" --pulsate --no-cancel --auto-close --text="Subiendo cambios... Por favor, espere.")

# Mostramos un mensaje conforme ha ido todo bien
# (aquí podria comprobar con un status si es cierto)
if [ $? -eq 0 ]
then
  zenity --info --title="Cambios subidos correctamente" --text="Se han subido todos los cambios correctamente."
  # Si tiene activadas las notificaciones, mostraremos un mensaje de Ok
  if $popup_push
  then
    # Mostrabamos un mensaje si los cambios se habian subido bien
    # Añadimos una notificación si se han realizado las subidas al repositorio correctamente
  	zenity --notification --window-icon="info" --text="Cambios subidos correctamente" &> /dev/null &
  fi
fi
