#!/bin/bash

#------------------------------------------------------
# PALETA DE COLORES
#------------------------------------------------------
#setaf para color de letras/setab: color de fondo
    red=`tput setaf 1`;
    green=`tput setaf 2`;
    blue=`tput setaf 4`;
    bg_blue=`tput setab 4`;
    reset=`tput sgr0`;
    bold=`tput setaf bold`;

#------------------------------------------------------
# VARIABLES GLOBALES
#------------------------------------------------------
proyectoActual="$(pwd)";
proyectos="";

#------------------------------------------------------
# DISPLAY MENU
#------------------------------------------------------
imprimir_menu () {

       imprimir_encabezado "\t  S  U  P  E  R  -  M  E  N U ";
    
    echo -e "\t\t El proyecto actual es:";
    echo -e "\t\t $proyectoActual";
    echo -e "\t\t";
    echo -e "\t\t Opciones:";
    echo "";
    echo -e "\t\t\t a.  Datos de Red";
    echo -e "\t\t\t b.  Escaneo de Red";
    echo -e "\t\t\t c.  Loguearse a dispositivo";
    echo -e "\t\t\t d.  Copiar archivo de host remoto a servidor";
    echo -e "\t\t\t e.  Copiar archivo de servidor a host remoto"; 
    echo -e "\t\t\t q.  Salir";
    echo "";
    echo -e "Escriba la opción y presione ENTER";
}

#------------------------------------------------------
# FUNCTIONES AUXILIARES
#------------------------------------------------------

imprimir_encabezado () {

    clear;
    #Se le agrega formato a la fecha que muestra
    #Se agrega variable $USER para ver que usuario está ejecutando
    echo -e "`date +"%d-%m-%Y %T" `\t\t\t\t\t USERNAME:$USER";
    echo "";
    #Se agregan colores a encabezado
    echo -e "\t\t ${bg_blue} ${red} ${bold}-------------------------------------------------------------\t${reset}";
    echo -e "\t\t ${bold}${bg_blue}${red}$1\t\t${reset}";
    echo -e "\t\t ${bg_blue} ${red} ${bold}-------------------------------------------------------------\t${reset}";
    echo "";
    
}

esperar () {
    echo "";
    echo -e "Presione enter para continuar";
    read ENTER ;
}

malaEleccion () {
    echo -e "Selección Inválida ..." ;
}


#------------------------------------------------------
# FUNCTIONES del MENU
#------------------------------------------------------


a_funcion () {
		
	imprimir_encabezado "\tOpción a.  Datos de Red";
	echo "Datos de su Red: "
	echo ""

	DireccionRed=$(ifconfig | grep -i "inet" -m 1|awk 'N=2 {print $N}')
	IPRouter=$(ip route show | grep -i "via " -m 1|awk 'N=3 {print $N}')
	Ip=$(dig +short myip.opendns.com @resolver1.opendns.com) 

	#dig: nos permite  hacer dns para obtener informacion de nombre de dominio

	echo Mi Direccion ip publica es: "$Ip"
	echo Mi Direccion de red es: "$DireccionRed"
	echo La Direccion del router es: "$IPRouter"
	
	}
	
b_funcion() {

	imprimir_encabezado "\t0pción b. Escaneo de Red";
	echo "Ingrese su contraseña para ver los dispositivos conectados a su Red"
	echo ""

	IPBroadcast=$(ip route show | grep -i "via " -m 1|awk 'N=3 {print $N}')
	IPBroadcast=${IPBroadcast/%[0-9][0-9][0-9]/*}
	IPBroadcast=${IPBroadcast/%[0-9][0-9]/*}
	IPBroadcast=${IPBroadcast/%[0-9]/*}
	
	sudo nmap -sP $IPBroadcast | grep -B 1 "for "
	
	}

c_funcion() {

	imprimir_encabezado "\t0pción c. Loguearse a dispositivo";
	echo "Ingrese los datos necesarios para logearse en el servidor"
	echo ""

	read -p "Ingrese el puerto: " puerto
	read -p "Ingrese el usuario: " usuario	
	read -p "Ingrese la ip del servidor: " ip

	echo ""
	echo "Para salir del servidor escriba 'exit'"
	echo ""

	ssh -X $puerto $usuario@$ip

	}

d_funcion() {

	imprimir_encabezado "\t0pción d. Copiar archivo de host remoto a servidor";
	echo "Ingrese los datos necesarios para copiar un archivo en el servidor"
	echo ""

	read -p "Ingrese el path y nombre del archivo: " archivo
	read -p "Ingrese el path donde desea guardar el archivo: " ubicacion
	read -p "Ingrese el usuario: " usuario	
	read -p "Ingrese la ip del servidor: " ip
	echo ""

	scp $archivo $usuario@$ip:$ubicacion

	}

e_funcion() {

	imprimir_encabezado "\t0pción e. Copiar archivo de servidor a host remoto";
	echo "Ingrese los datos encesarios para copiar un archivo desde el servidor"
	echo ""

	read -p "Ingrese el path y nombre del archivo: " archivo
	read -p "Ingrese el path donde desea guardar el archivo: " ubicacion
	read -p "Ingrese el usuario: " usuario	
	read -p "Ingrese la ip del servidor: " ip
	echo ""

	scp $usuario@$ip:$archivo $ubicacion

	}
		

#------------------------------------------------------
# LOGICA PRINCIPAL
#------------------------------------------------------
while  true
do

    # 1. mostrar el menu
      imprimir_menu;
    # 2. leer la opcion del usuario
    read opcion;
    
    case $opcion in
        a|A) a_funcion;;
        b|B) b_funcion;;
        c|C) c_funcion;;
        d|D) d_funcion;;
        e|E) e_funcion;;
        q|Q) break;;
        *) malaEleccion;;
    esac
    esperar;
done


