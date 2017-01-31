# Easy-push

ES: Te facilita todo el proceso de subir unos cambios a una rama de tu repositorio git,
 añadiendo todos los archivos (git add --all) y mostrando un mensaje donde
 introduciremos el texto del commit.
 <br/>En resumen, hace un push con un commit que escribiremos
 en modo gráfico o por terminal de todos los archivos modificados<br/>
EN: Make a push to your branch, adding all the modified files (git add --all) and shows a message where you can introduce
the text of the commit. In brief, make a push (in master) with a commit that we write in a graphic window.

Ejemplo para ejecutar el script
```shell
gp "Este es el mensaje del commit"
```

## Instalación

La instalación es muy básica, añade dos alias a tu .bashrc

```shell
git clone https://github.com/victormln/easy-push.git
cd easy-push
./install.sh
```

## Modo gráfico/terminal

Modo gráfico:
```shell
gpg "Mensaje del commit"
```

Modo terminal:
```shell
gp "Mensaje del commit"
```

## Configuración

Se pueden configurar varios parámetros. Por ejemplo que no busque actualizaciones automáticas, cambiar el idioma o poner un commit por defecto. Si se abre el archivo **user.conf** se podrán acceder a todas las configuraciones.

## Uso

Este script tiene varios metodos de ejecutarse. Explicaré los comandos para el modo terminal
```shell
gp "Mensaje del commit"
```
OR:
```shell
gp
```

Todos los argumentos disponibles:

|Argumento           |Abreviado|Significado                                   |Uso|
| ------------- | ---- | ---------------------------------------- |----------|
|`"Mensaje del commit"`       |     | Se pondrá este mensaje del commit        |`gp "Mensaje del commit"`  |
|`--help`       |`-h`     | Muestra los comandos disponibles         |`gp --help`  |
|`--conf`     |  | Abre/edita el archivo de configuración del script  |`gp --conf`      |
|`--update`     |  | Busca actualizaciones disponibles.  |`gp --update`      |
|     |`-v`  | Muestra la versión instalada del script.  |`gp -v`      |
