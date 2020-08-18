# handshake_automation
Automatización de captura de handshake.

# info
El script está escrito en bash y es un proceso automatizado de un uso sencillo de aircrack-ng 

# Instalacion / uso
git clone https://github.com/MMAGANADEBIA/handshake_automation.git

cd handshake_automation

bash handhsake_automation.sh

# Problemas
Al elegir la desencriptación con diccionario puede que en algunas distros no permita detener el proceso con ctrl + c, por lo que si cierra la ventana verá que no
puede conectarse de nuevo a la red, esto es porque la interfaz sigue en modo monitor, solucione con: sudo airmon-ng stop wlan0mon.

Puede que el adminsitrador de red tampoco se inicie, por lo que puede solucionarlo con: sudo NetworkManager start
