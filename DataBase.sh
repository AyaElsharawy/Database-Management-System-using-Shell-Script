#!/usr/bin/bash
clear
DataBases=`mkdir DataBase 2>/dev/null`
echo Welcom to DBMS
path=""
function create
{
                echo enter name of database you want to create: 
                read name
		if [[ $name = "" ]]
		then 
			echo Please enter name:
		        sleep 1 
		        create
		
	        elif [[  $name =~ [/.:\|\-] ]]
		then 
			echo "You can't use these special characters . \ : - |"
			sleep 1 
			create 
		elif [[ $name =~ ^[a-z] || $name =~ ^[A-Z] ]]
		then
                    mkdir  DataBase/$name 2>/dev/null
                    if [[ $? == 0 ]]  
                    then
                        echo -e "Database created successfully\n"
			sleep 1
               	    else
                       	echo -e  "Database exist please enter another name\n"
                        create
                    fi
                     menu
		 elif [[ -d $name ]]
		 then 
			 echo Database exist!,please enter another name
			 sleep 1 
			 create 
		 else 
			 echo You cant use number or special character  
		 fi
		 menu
}
function list
{
        cd DataBase 2>/dev/null
       	ls -d */ 2>/dev/null | cut -f1 -d'/'
        echo -e "\n"
	sleep 10
        menu
}
function remove
{
	cd DataBase 2>/dev/null
	echo Databaes you have :
        ls -d */ 2>/dev/null|cut -f1 -d'/'
        echo  Please enter Name of Database you want to Delete:
        read removed
	if [[ $removed = "" ]]
	then 
		echo Invalid entry 
		sleep 1 
		remove
	
	elif [[ -d $removed ]]
	then
        	`rm -r $removed 2>/dev/null` 
	   	 echo -e "Database Deleted Successfully\n"
	else 
	    echo -e "Database not exist already!\n"
	fi 
        sleep 1
	menu

}
function create_table 
{
	echo Please enter Table name 
	read table_name
	if [[ -f $table_name ]]
	then 
		echo Table is exist!
		sleep 1 
		create_table
	elif [[ $table_name = "" ]]
	then
		echo Invalid entry 
		sleep 1 
		create_table
	elif [[ $table_name =~ [/.:\|\-] ]]
	then 
		echo "You can't use these special character . / : - |"
		sleep 1 
		create_table
	elif [[ $table_name =~ ^[a-z] || $table_name =~ ^[A-Z] ]]
        then	
	        extintion=.csv
	        tab_name=$table_name$extintion
	        #cd DataBase/$path	
                touch $tab_name
                echo Please enter number of column
		read num_col
		typeset -i counter
		counter=1
		seperator=","
		meta=""
	        let end=$num_col-1
		echo Please enter the name of column you want to be PK 
		read PK 
		if [[ $PK = "" ]]
		then
	             echo You must enter the PK 
	             echo Please enter the name of column you want to be PK
                     read PK
		elif [[ $PK =~ [/.:\|\-] ]]
	        then
	             echo "You can't use . \ : - |"
		     echo Please enter the name of column you want to be PK
                     read PK
                elif [[ $PK =~ ^[a-z] || $PK =~ ^[A-Z] ]]
		then
	             meta=$PK$seperator
	        else
	             echo "You can't use number or special character"
		     echo Please enter the name of column you want to be PK
                     read PK
                fi
                while   [[ $counter -lt $num_col ]]
		do 
	             echo Please enter the name of the next column
		     read name_col
		     if [[ $name_col = "" ]]
                     then
                          echo invalid entry 
                          echo Please enter the name of column 
                          read name_col
                     elif [[ $name_col =~ [/.:\|\-] ]]
                     then
                          echo "You can't use . \ : - |"
                          echo Please enter the name of column 
                          read name_col
		      elif [[ $name_col =~ ^[0-9] ]]
		      then
                          echo "You can't use number or special character"
                          echo Please enter the name of column
                          read name_col
                      elif [[ $name_col =~ ^[a-z] || $name_col =~ ^[A-Z] ]]
                      then 
		            if [[ $counter == $end ]]
		            then
				meta=$meta$name_col
				counter=$counter+1
                            else  
				meta=$meta$name_col$seperator
				counter=$counter+1
                             fi
		       fi
		        done
			echo $meta>>$tab_name
			echo $tab_name>>$tab_name
			echo $num_col>>$tab_name
		        echo Table created successfully
			sleep 1
			table_menu
                      
        else
	    echo "You can't use number or special character"
	fi
}
function table_menu
{
	clear
	echo -e "1-Create Table\n2-List Table\n3-Drop Table\n4-Insert into Table\n5-Select from Table\n6-Delete from Table\n7-Main Menu "
	echo Please enter number:
	read table_num
	case $table_num in
		1) create_table 
			;;
		2) echo list
			;;
		3) echo drop
			;;
		4) echo insert 
			;;
		5) echo select
			;;
		6) echo delete
			;;
		7) menu
			;;
		*) echo Invalid number please enter number from 1 to 7 
			;;
	esac
} 
function connect
{
	echo Please enter name of Database:
	read DB
	cd DataBase 2>/dev/null
	if [ -d $DB ]
	then 
	     path=$DB
	     cd ~/shell/Database-Management-System-using-Shell-Script/DataBase/$DB 2>/dev/null
	     if [ $?==0 ]
             then 
		table_menu
	     fi
        else
	    echo Database not exist!
            sleep 1
	    menu
	fi

}

function menu
{
	clear 
        echo -e  "1-Create Database\n2-List Database\n3-Connect Database\n4-Drop Database\n5-Exit\n" 
        echo Please enter number:
        read choice
                case $choice in
                        1) create
                                ;;
                        2) list
                                ;;
                        3) connect
                                ;;
                        4) remove
                                ;;
                        5) exit
                                ;;
                        *) echo Please enter number from 1 to 5 only
                                ;;
                esac
}
menu
     
 
