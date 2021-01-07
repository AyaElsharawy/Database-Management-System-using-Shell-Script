#!/usr/bin/bash
DataBases=`mkdir DataBase 2>/dev/null`
echo Welcom to DBMS
function create
{
                echo enter name of database you want to create 
                read name
                `mkdir  DataBase/$name 2>/dev/null`
                if [[ $? == 0 ]] #check if there any error 
                then
                        echo -e "Database created successfully\n"
                else
                        echo -e  "Database exist please enter another name\n"
                        create
                fi
                menu
}
function list
{
        cd DataBase
        ls -d */|cut -f1 -d'/'
        echo -e "\n"
        menu
}
function menu
{
        echo -e  "1-Create Database\n2-List Database\n3-Connect Database\n4-Drop Database\n5-Exit\n" 
        echo Please center number:
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
     

