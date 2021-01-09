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
	sleep 5
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
		meta_table=meta
                tab_name=$table_name$extintion
	        meta_name=$table_name$meta_table$extintion
		cd $path	
                touch $tab_name
		touch $meta_name
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
	             echo -e "You must enter the PK\n" 
	             echo Please enter the name of column you want to be PK
                     read PK
		elif [[ $PK =~ [/.:\|\-] ]]
	        then
	             echo -e "You can't use . \ : - |\n"
		     echo Please enter the name of column you want to be PK
                     read PK
                elif [[ $PK =~ ^[a-z] || $PK =~ ^[A-Z] ]]
		then
	             meta=$PK$seperator
	        else
	             echo -e "You can't use number or special character\n"
		     echo Please enter the name of column you want to be PK
                     read PK
                fi
                while   [[ $counter -lt $num_col ]]
		do 
	             echo Please enter the name of the next column
		     read name_col
		     if [[ $name_col = "" ]]
                     then
                          echo -e "invalid entry\n" 
                          echo Please enter the name of column 
                          read name_col
                     elif [[ $name_col =~ [/.:\|\-] ]]
                     then
                          echo -e "You can't use . \ : - |\n"
                          echo Please enter the name of column 
                          read name_col
		      elif [[ $name_col =~ ^[0-9] ]]
		      then
                          echo -e "You can't use number or special character\n"
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
			echo $meta>>$meta_name
			echo $table_name>>$meta_name
			echo $num_col>>$meta_name
		        echo Table created successfully
			sleep 1
			table_menu
                      
        else
	    echo "You can't use number or special character"
	fi
}
function drop_table
{ 
	echo please enter table name 
	read Table_name
	ext=.csv
        Meta=meta
	meta_table_name=$Table_name$Meta$ext
	table_Name=$Table_name$ext
	cd DataBase 2>>/dev/null
	if [[ -f $meta_table_name ]]
	then
	     rm $meta_table_name
	     rm $table_Name
	     if [[ -f $meta_table_name && -f $table_Name ]]
             then
		     echo Table not droped 
		     sleep 1 
		     drop_table
	     else
		     echo Table droped successfully
		     sleep 1
		     table_menu
	     fi
        else
		echo Table not exist already!
		sleep 1 
		table_menu
	fi
}
function insert_to_table
{
	echo Please enter table name 
	read Table_Name
	ext=.csv
	meta_name=meta
	data_table=$Table_Name$ext
	meta_table=$Table_Name$meta_name$ext
	cd $path 2>/dev/null
	if [[ -f  $data_table && -f $meta_table ]]
	then
		typeset -i count
		count=1
		number_col=`tail -n 1 $meta_table`
        	sep=","
		data=""
       		while [[ $count -le $number_col ]]
		do
			if [[ $count == 1 ]]
			then
			    echo Please enter data of Primary Key column
                            read PK_data
                            while [[ $PK_data == "" ]]
                            do
                       	      echo -e  "This column is the PK can't be null\n"
                              echo Please enter data
                              read PK_data
                            done
			    data=$PK_data$sep
			    (( count++ ))
		       else
			    echo Please enter the data of next col
			    read D_col
			    if [[ $count == $number_col ]]
			    then
				data=$data$D_col
				(( count++ ))
			    else 
				data=$data$D_col$sep
				(( count++ ))
			    fi
		    fi	    
		done
		echo $data>>$data_table
		echo Data successfully inserted
	        sleep 1	
		echo "Do you want to insert new row (Y|N)"
		read answer
		sleep 1
		if [[ $answer == 'Y' || $answer == 'y' ]]
		then
			echo How many row you want to enter 
			read row 
			typeset -i counter_row
			typeset -i counter_col
                        counter_row=1
			counter_col=1
			while [ $counter_row -le $row ]
			do
			  while [ $counter_col -le $number_col ]
			  do
			     if [[ $counter_col == 1 ]]
			     then 
			        echo Please enter data of Primary Key column
                                read pk_data
                                while [[ $pk_data == "" ]]
                                do
                                echo -e  "This column is the PK can't be null\n"
                                echo Please enter data
                                read pk_data
                                done
                                Data=$pk_data$sep
				(( counter_col++ ))
			     else
				 echo Please enter the next column data
				 read data_col
				 if [[ $counter_col == $number_col ]]
				 then
					 Data=$Data$data_col
					 (( counter_col++ ))
				 else 
					Data=$Data$data_col$sep
					(( counter_col++ ))
				 fi
			     fi
                             done 
			     (( counter_row++ ))
			     echo $Data>>$data_table
			     Data=""
		     done
		     echo Data inserted successfully
		     sleep 1
		     table_menu
		elif [[ $answer == 'N' || $answer == 'n' ]]
		then	
			table_menu
		else
			echo Invalid entry 
			sleep 1 
			table_menu
		fi
	else 
		echo Table not exist!
		sleep 1
		insert_to_table
	fi   	
}
function list_table
{
        cd DataBase/$path 2>/dev/null
	cd $path 2>/dev/null 
        ls -p  2>/dev/null | grep -v /
        echo -e "\n"
        sleep 5
        table_menu
}
function delete_from_table
{
	echo Enter table name
	read TableName
	EXT=.csv
	Table_Name=$TableName$EXT
	cd $path 2>>/dev/null
	if [ -f $Table_Name ]
	then
	       echo please enter PK of record you want to remove 
               read rm_record
	      result=`awk -F, '{if($1=='$rm_record'){print NR}}' $Table_Name`
	      if [[ $result = "" ]]
	      then
		      echo Record not found 
	      else
	              sed -i ''$result'd' $Table_Name
		      echo Record removed successfully
		      echo "Do you want to remove another record [Y|N]"
		      read return_to
		      if [[ $return_to == 'Y' || $return_to == 'y' ]]
		      then
			      delete_from_table
		      elif [[ $return_to == 'N' || $return_to == 'n' ]]
		      then
			      table_menu
		      else
			      echo Invalid entry 
			      sleep 1
			      table_menu
		      fi
	      fi
	else
		echo Table not exist!
		sleep 1
		delete_from_table
	fi
}
function select_all
{
        echo Enter table name
        read TableName
        EXT=.csv
        Meta=meta
        Table_Name=$TableName$EXT
        Meta_Table=$TableName$Meta$EXT
        cd $path 2>>/dev/null
        if [ -f $Table_Name ]
        then
            typeset -i counter
            counter=1
            col=`tail -1 $Meta_Table`
            while [[ $counter -le $col ]]
            do
               header[$counter]=`head -1 "$Meta_Table" | cut -d, -f$counter`
               (( counter++ ))
            done
            echo ${header[@]} 
            column -c 5 -t -s "," $Table_Name 
	    echo -e "\n\n1-Table Menu\n2-Main Menu\n"
	    echo please enter choose:
	    read ans
	    case $ans in
	       1) table_menu
		       ;;
	       2) menu
		       ;;
	       *) echo Invalid Entry ; menu
		       ;;
	    esac

       else
          echo Table not exist!
	  sleep 1
	  select_all
       fi
}
function select_record
{
        echo Enter table name
        read TableName
        EXT=.csv
        Meta=meta
        Table_Name=$TableName$EXT
        Meta_Table=$TableName$Meta$EXT
        cd $path 2>>/dev/null
	if [ -f $Table_Name ]
        then
            echo please enter PK of the record you want to select
            read rm_record
            check=`awk -F, '{if($1=='$rm_record'){print $0}}' $Table_Name`
            if [[ $check = "" ]]
            then
                echo Record not found
            else
                typeset -i counter
                counter=1
                col=`tail -1 $Meta_Table`
                while [[ $counter -le $col ]]
                do
                 header[$counter]=`head -1 "$Meta_Table" | cut -d, -f$counter`
                 (( counter++ ))
                done
                echo ${header[*]}

                result=`awk -F, '{if($1=='$rm_record'){print NR}}' $Table_Name`
                column -t -s "," $Table_Name | head -$result | tail -1
           fi
	  else
              echo Table not exist!
              sleep 1
              select_from_table
          fi
}
function select_from_table
{
	clear
	echo -e "1-Select all table\n2-Select record from table\n3-Table Menu"
	echo Please choose number:
	read number
	case $number in
		1) select_all
			;;
		2) select_record
			;;
		3) table_menu
			;;
		*) echo Invaled entry
		        sleep 1	
		       	select_from_table
			;;
	esac
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
		2) list_table
			;;
		3) drop_table
			;;
		4) insert_to_table	
			;;
		5) select_from_table
			;;
		6) delete_from_table
			;;
		7) menu
			;;
		*) echo Invalid number please enter number from 1 to 7
		       sleep 1
	               table_menu	       
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
	     cd DataBase/$DB 2>/dev/null
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
     
 
