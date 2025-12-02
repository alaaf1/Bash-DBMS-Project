

:'

#!/usr/bin/bash

function validate_name() {
    if [[ -n $1 ]]; then
        if [[ $1 =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]; then
            echo "true"
        else
            echo "false"
        fi
    else
        echo "false"
    fi
}

function add_cols() {
    local colnames=("${!1}") # Pass colnames as an array to the function
    local colname
    local doexist=false

    colname=$(zenity --title="Column Name" --text="Please enter column $2 name: " --entry)
    result=$(validate_name "$colname")

    if [[ $result == "true" ]]; then
        for var in "${colnames[@]}"; do
            if [[ $var == $colname ]]; then
                doexist=true
                break
            fi
        done

        if [[ $doexist == true ]]; then
            zenity --error --text="Column already exists!"    
        else
            colnames+=("$colname")
        fi
    else
        zenity --error --text="Column Name Invalid! Please enter a valid name again"
        add_cols colnames
    fi
}

function ask_count() {
    while true; do
        colscount=$(zenity --title="Columns Count" --text="Please enter columns count: " --entry)
        if [[ $colscount -gt 0 && $colscount =~ ^[0-9]+$ ]]; then
            return 0
        else
            zenity --error --text="Invalid column count. Please try again."
        fi
    done
}

# Main script logic
tablename=$(zenity --title="Create Table" --text="Please enter table name: " --entry)
tablename2="$tablename.data"
iscreated=false
colnames=()

if (( $? == 0 )); then
    if [[ -n $tablename ]]; then
        declare -i exist=0
        for var in $(ls); do
            if [[ "$tablename2" == "$var" ]]; then
                exist=1
                zenity --error --text="Table already exists"    
                break
            fi
        done

        if (( exist == 0 )); then
            if [[ $tablename =~ ^[A-Za-z][A-Za-z0-9_]*$ ]]; then
                touch ./"$tablename.data"
                touch ./"$tablename.meta"
                iscreated=true
                zenity --info --text="Table created successfully"
            else
                zenity --error --text="Table name is invalid"    
            fi
        fi
    else
        zenity --error --text="Table name is empty"
    fi
else
    exit 1
fi

if [[ $iscreated == true ]]; then
    result=$(ask_count)
    if [[ $? -eq 0 ]]; then
        for ((i=1; i<=colscount; i++)); do
            add_cols colnames "$i"
        done
    else
        zenity --error --text="Columns Count is invalid"
    fi
else
    exit 1
fi

echo "${colnames[@]}"
'




