#! /usr/bin/bash
colnames=()
coltypes=()
colpk=()
function validate_name(){
if [[ -n $1 ]]
	then
			if [[ $1 =~ ^[A-Za-z][A-Za-z0-9_]*$ ]] 
			then
			isvalid=true
			else
			isvalid=false
			fi
	else
		isvalid=false
	fi 	
echo $isvalid
}

function add_col(){			
while true
do
        	colname=$(zenity --title="Column Name" --text="Please enter column name: " --entry)
        	if [[ $? -eq 0 ]]
       	then
      
        		valid=$(validate_name "$colname")
        		if [[  $? -eq 0 ]]
        		then
        		if [[ $valid == true ]] 
        		then
            			doexist=false
            			for var in ${colnames[@]}
            			do
                			if [[ $colname == $var ]]
                			then
                    			doexist=true
                			fi
            			done

            			if [[ $doexist == true ]]
            			then
                			zenity --error --text="Column already exists! Please enter a name that does not exist" 
                			
            			else
            				
                			colnames+=("$colname")
                			while true
                			do
                			typechoice=$(zenity --list --title="Choose Data Type:" --column="Data Types" "INT" "VARCHAR" )
                			if [[ $? -eq 0 && -n $typechoice ]]
                			then
                			    coltypes+=("$typechoice")
                			    break
                			else
                			    zenity --error --text="Please choose Data Type"
                			fi
                			done
                			break
            			fi
        		else
            			zenity --error --text="Column Name Invalid! Please enter a valid name."
        		fi
        		fi
        	else
        		break
        	fi
done
}

function ask_count(){
    while true
    do
        colscount=$(zenity --title="Columns Count" --text="Please enter columns count: " --entry)
        if [[ $colscount -gt 0 && $colscount =~ ^[0-9]+$ ]]
        then
            echo $colscount
            break
        else
            zenity --error --text="Please enter a valid number greater than 0"
        fi
    done
}

iscreated=false
tablename=$(zenity --title="create table" --text="Please enter table name: " --entry)
if (( $? == 0 ))
then
	tablename2="$tablename.data"
	if [[ -n $tablename ]]
	then
		declare -i exist=0
		for var in $(ls) 
		do
			if [[ "$tablename2" == "$var" ]] 
			then
			exist=1
			zenity --error --text="Table already exists"	
			break
			fi
		done
		if (( $exist==0 )) 
		then
			if [[ $tablename =~ ^[A-Za-z][A-Za-z0-9_]*$ ]] 
			then
			touch ./"$tablename.data"
			touch ./"$tablename.meta"
			iscreated=true
			zenity --info --text="Table created successfully"
			else
			zenity --error --text="Table name is invalid"	
			fi
		fi
			
			
	else
	zenity --error --text="Table name is empty "
	fi 				
else
echo help
exit 1			
fi

if [[ $iscreated == "true" ]]
then
echo helpcreated
	declare -i result=0
	result=$(ask_count)
	if [[ $result -gt 0 ]]
	then
		for ((i=1; i<=(($result)) ; i++ ))
		do
			add_col
			echo $i
		done
		while true
		do
			pkchoice=$(zenity --list --title="Please choose column to be primary key" --column="Columns" ${colnames[@]})
		
			if [[ $? -eq 0 && -n $pkchoice ]]
			then
		    	colpk+=("$pkchoice")
		    	break
			else
			zenity --error --text="Please choose a primary key"
			fi
			done
	else
	zenity --error --text="Columns Count is invalid"	
	fi
else 
exit 1
fi

printf "%s|" "${colnames[@]}" >$tablename.data
sed -i '$ s/|$//' $tablename.data
echo "">>$tablename.data

printf "%s|" "${colnames[@]}" >$tablename.meta
sed -i '$ s/|$//' $tablename.meta
echo "">>$tablename.meta
printf "%s|" "${coltypes[@]}" >>$tablename.meta
sed -i '$ s/|$//' $tablename.meta
echo "">>$tablename.meta

printf "%s|" "${colpk[@]}" >>$tablename.meta
sed -i '$ s/|$//' $tablename.meta
echo "">>$tablename.meta



