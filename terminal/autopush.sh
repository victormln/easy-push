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

# Cogemos los datos del archivo .conf
source $( dirname "${BASH_SOURCE[0]}" )/user.conf

echo "Easy Push v$version"
if $show_author; then echo "Autor: Víctor Molina [victormln.com] <contact@victormln.com> "; fi;
# Si están activadas las actualizaciones automáticas
# Doy permiso al update.sh
chmod +x $( dirname "${BASH_SOURCE[0]}" )/update.sh
# Comprobaré si hay alguna versión nueva del programa autopush
# y lo mostraré en pantalla
source $( dirname "${BASH_SOURCE[0]}" )/update.sh

# Compruebo que sistema está usando para hacer ping
# Si es Linux o Mac
if [ "$(uname -s)" == "Linux" ] || [ "$(uname)" == "Darwin" ]; then
    # Do something under GNU/Linux platform
    ping -c 1 www.google.com > /dev/null
    has_internet=$(echo $?)
    # Si es Windows
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] ||
  [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under Windows NT platform
    ping -n 1 www.google.com > /dev/null
    has_internet=$(echo $?)
fi

# Si el ping se ha realizado correctamente es que tiene internet
# por lo que se buscaran actualizaciones
if [ $has_internet -eq 0 ]
then
  if $search_ota
  then
    tieneUltimaVersion=false
    # Conseguimos la ultima version que hay en github y le quitamos los puntos
    ultimaVersion=$(curl -s https://raw.githubusercontent.com/victormln/easy-push/master/terminal/user.conf | tail -1 | cut -d'=' -f 2) > /dev/null
    ultimaVersionSinPuntos=$( echo $ultimaVersion | tr -d ".")
    # Miramos que versión tiene el usuario actualmente
    versionActualSinPuntos=$(cat $( dirname "${BASH_SOURCE[0]}" )/user.conf | tail -1 | cut -d'=' -f 2 | tr -d ".")
    # Comprobamos si la versionActual es igual o mas grande que la ultimaVersion
    # es igual a la versionActual.
    if (( $versionActualSinPuntos>=$ultimaVersionSinPuntos ))
    then
    	tieneUltimaVersion=true
    else
    	directorioActual=$(pwd)
    	# Nos colocamos en el directorio del script, para actualizarlo
    	cd "$( dirname "${BASH_SOURCE[0]}" )"
    	cd ..
    	# Mostramos el mensaje de que hay una nueva actualización
    	echo "###########################################"
    	echo -e "${WARNING}¡NUEVA ACTUALIZACIÓN!${NC}"
    	echo "Tienes la versión: $version"
    	echo "Versión disponible: $ultimaVersion"
    	echo "###########################################"
    	# Si tiene las actualizaciones automaticas, no se le pide nada
    	if $automatic_update
    	then
    		# Si es así, hacemos un pull y le actualizamos el script
    		echo "Hay una nueva actualización y tienes activadas las descargas automáticas."
    		git pull | tee >(echo "Actualizando... Por favor, espere ...")
    		echo -e "${OK}[OK] ${NC}La actualización ha acabado, por favor, vuelva a iniciar el script.";
    	else
    	  echo "Hay una nueva versión de este script y se recomienda actualizar."
    	  echo "Quieres descargarla y así tener las últimas mejoras? y/n o s/n"
    	  # Preguntamos si quiere actualizar
    	  read actualizar
    	  if [ $actualizar == "s" ] || [ $actualizar == "y" ]
    	  then
    			directorioActual=$(pwd)
    			cd "$( dirname "${BASH_SOURCE[0]}" )"
    			cd ..
    	    # Si es así, hacemos un pull y le actualizamos el script
    	  	git pull | tee >(echo "Actualizando... Por favor, espere ...")
    			cd $directorioActual
    			echo -e "${OK}[OK] ${NC}La actualización ha acabado, por favor, vuelva a iniciar el script.";
    	  else
    	    # En el caso que seleccione que no, muestro un mensaje.
    	    echo -e "${WARNING}¡AVISO!${NC} NO se actualizará (aunque se recomienda)."
    			# Damos por su puesto que tiene la ultima version,
    			# para que el script no entre en bucle
    			tieneUltimaVersion=true
    	  fi
    	fi
    	# Cambiamos al directorio donde el usuario tiene sus cambios
    	cd $directorioActual
    fi
    # Si no tiene la ultima version y ha actualizado, volvemos a ejecutar el script
    if ! $tieneUltimaVersion
    then
      # Iniciamos de nuevo el script para ejecutar el script actualizado
      exec $( dirname "${BASH_SOURCE[0]}" )/autopush.sh
    fi
  fi
else
  echo -e "${WARNING}[AVISO] ${NC}No tienes internet. Para buscar actualizaciones se necesita internet."
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
