# Easy push
ES: Te facilita todo el proceso de subir unos cambios a una rama de tu repositorio git,
 añadiendo todos los archivos (git add --all) y mostrando un mensaje donde
 introduciremos el texto del commit.
 <br/>En resumen, hace un push con un commit que escribiremos
 en modo gráfico o por terminal de todos los archivos modificados<br/>
EN: Make a push to your branch, adding all the modified files (git add --all) and shows a message where you can introduce
the text of the commit. In brief, make a push (in master) with a commit that we write in a graphic window.
# Installation/Execution
ES: Este script no se instala, se ejecuta. Para ejecutarlo simplemente le daremos permisos `chmod -x autopush.sh` y
lo ejecutaremos con `./autopush.sh`<br/>
EN: This script doesn't install on the pc, you have to execute it. For execute it, give permission to the file (execution) with the command `chmod -x autopush.sh`
after that, you can execute it and run it with: `./autopush.sh`
# Notes
ES: Te recomiendo que pongas el script en el archivo .bashrc para ejecutar el comando cuando quieras a través de un alias.<br/>
EN: I recommend to put the script into the file .bashrc for execute it wherever you are in the prompt through an alias.
```
alias gp="~/Downloads/easy-push/terminal/autopush.sh"
alias gpg="~/Downloads/easy-push/graphic/autopush.sh"
```
