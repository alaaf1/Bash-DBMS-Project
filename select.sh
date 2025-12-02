#!/usr/bin/bash
source ~/bashDBMS/helper.sh

result=$(list_tables)
if [[ $result -eq 0 ]]
then
    zenity --info --text="No Table Found!" 
else

    choice=$(zenity --list --title="Tables" --column="Tables" $(cat "tables.txt"))
    tablemeta="$choice.meta"
    tabledata="$choice.data"
    
    if [[ $? -eq 0 && -n $tablemeta ]]
    then
        IFS='|' read -a colnames <<< $(sed -n '1p' "$choice.meta")
        IFS='|' read -a coltypes <<< $(sed -n '2p' "$choice.meta")
        IFS='|' read -a pk <<< $(sed -n '3p' "$choice.meta")
        
        declare -i pkindex=$(findPK_index "$choice")
        declare -i i=0
       
        # Menu for selecting the operation
        select_choice=$(zenity --list --title="Select Option" --column="Options" "View All Rows" "Select by Columns" "Select by Row (PK)" --height=300 --width=400)
        
        case "$select_choice" in
            "View All Rows")
                tableData=()
                zen="zenity --list --title='Table: $choice' --height=400 --width=800"
                for col in "${colnames[@]}"
                do
                    zen+=" --column='$col'"
		    done
                  while IFS='|' read -ra row
                  do
    			tableData+=("${row[@]}")
			done < <(awk 'NR > 1 { print $0 }' "$tabledata")
			eval "$zen ${tableData[@]}"
                  ;;
                  
            "Select by Columns")
                # Select some specific columns
                selectedcols=()
                countcols=$(zenity --entry --title="Columns Count" --text="Please enter columns count")
                
                if [[ $? -eq 0 && -n "$countcols" ]]
                then
                	if [[ $countcols -gt 0 && $countcols -le ${#colnames[@]} ]]
                	then
                	
                	  for ((i=0; i<$countcols; i++))
                	  do
                	  while true
                	  do
                	  
                	  selectedcol=$(zenity --list --title="Select Columns from $choice" --column="Columns" ${colnames[@]})
                	  
                    if [[ $? -eq 0 && -n "$selectedcol" ]]
                    then
                    selectedcols+=("$selectedcol")
                    break
                    else
                    zenity --error --text="Please choose column"
                    fi
                	  done
                	  done
                	  
                	  colsindexes=()
                	  for col in "${selectedcols[@]}"
                    do
                	  	for col_index in "${!colnames[@]}"
                	  	do
                	  		if [[ "$col" == "${colnames[$col_index]}" ]]
                	  		then
                	  			colsindexes+=("$col_index")
                	  		fi
                	  	done
                    done
                    echo "colsindexes ${colsindexes[@]}"
                    # Prepare to show the selected columns
                    zen_col="zenity --list --title='Selected Columns from $choice' --height=400 --width=800"
                    
                    for col in "${selectedcols[@]}"
                    do
                        zen_col+=" --column='$col'"
                    done
                    
                    selected_data=""
                    while IFS='|' read -ra row
                    do
                        for index in "${colsindexes[@]}"
                        do
                            selected_data+="${row[$index]} "
                          
                        done
                    done < <(sed '1d' "$tabledata")
                    eval "$zen_col $selected_data"
                else
                zenity --error --text="Columns count must be > 0 and <= total columns count"
                fi
                else
                    zenity --error --text="No columns count specified!"
                fi
                ;;
                
            "Select by Row (PK)")

                pk_value=$(zenity --entry --title="Select by Row (PK)" --text="Please enter Primary Key value:")
                if [[ $? -eq 0 && -n $pk_value ]]
                then
                    valid=$(validate_input $pkindex $pk_value $choice)
                    if [[ $valid == true ]]
                    then
                    	declare -i pk_adjusted=$pkindex+1
                        selected_row=$(awk -F'|' -v pk="$pk_value" -v colindex="$pk_adjusted" 'NR>1 {if($colindex==pk) print $0}' "$tabledata")
                        if [[ -z $selected_row ]]
                        then
                        	
                            zenity --error --text="No row found with Primary Key: $pk_value"
                        else
                            zenity --list --title="Selected Row from $choice" --column="Columns" --column="Values" $(echo "$selected_row" | tr '|' '\n')
                        fi
                    else
                        zenity --error --text="Invalid Primary Key value entered."
                    fi
                else
                    zenity --error --text="Primary Key input canceled or empty."
                fi
                ;;
                
            *)
                zenity --error --text="Invalid option selected."
                ;;
        esac
    else
        zenity --error --text="Table meta data or data file not found!"
    fi
fi

