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
    echo -e "\t\t\t c.  ";
    echo -e "\t\t\t d.  ";
    echo -e "\t\t\t e.  "; 
    echo -e "\t\t\t f.  ";
    echo -e "\t\t\t g.  ";
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

decidir () {
    echo $1;
    while true; do
        echo "desea ejecutar? (s/n)";
            read respuesta;
            case $respuesta in
                [Nn]* ) break;;
                   [Ss]* ) eval $1
                break;;
                * ) echo "Por favor tipear S/s ó N/n.";;
            esac
    done
}



#------------------------------------------------------
# FUNCTIONES del MENU
#------------------------------------------------------


a_funcion () {
		
	imprimir_encabezado "\tOpción a.  Datos de Red";
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
	IPBroadcast=$(ip route show | grep -i "via " -m 1|awk 'N=3 {print $N}')
	IPBroadcast=${IPBroadcast/%[0-9][0-9][0-9]/*}
	IPBroadcast=${IPBroadcast/%[0-9][0-9]/*}
	IPBroadcast=${IPBroadcast/%[0-9]/*}	
	sudo nmap -sP $IPBroadcast | grep -B 1 "for "
	
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
        f|F) f_funcion;;
        g|G) g_funcion;;
        q|Q) break;;
        *) malaEleccion;;
    esac
    esperar;
done


