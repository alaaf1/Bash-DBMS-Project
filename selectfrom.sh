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
IFS='|' read -r -a colnames <<< "$(head -n 1 "$tabledata")"
zenity_input=()
for col in "${colnames[@]}"
do
  zenity_input+=("FALSE" "$col" "$col")
done
selected=$(zenity --list \
  --title="Select Columns to Display" \
  --text="Choose columns:" \
  --checklist \
  --column="Select" --column="ID" --column="Column" \
  "${zenity_input[@]}")
if [ $? -eq 0 ]
then
  IFS='|' read -ra chosen_cols <<< "$selected"
  IFS='|' read -ra all_cols <<< "$(head -n 1 "$tabledata")"
  indices=()
  for sel in "${chosen_cols[@]}"; do
    for i in "${!all_cols[@]}"; do
      if [ "${all_cols[$i]}" == "$sel" ]; then
        indices+=("$i")
        break
      fi
    done
  done
  output=""

  # Header
  out_header=()
  for i in "${indices[@]}"; do
    out_header+=("${all_cols[$i]}")
  done
  output+=$(printf "%s|" "${out_header[@]}")
  output=${output%|}
  output+="\n"

  # Data rows
  tail -n +2 "$tabledata" | while IFS='|' read -ra row; do
    out_row=()
    for i in "${indices[@]}"; do
      out_row+=("${row[$i]}")
    done
    output+=$(printf "%s|" "${out_row[@]}")
    output=${output%|}
    output+="\n"
  done
  zenity --text-info \
    --title="Selected Columns" \
    --width=600 --height=400 \
    --editable \
    <<< "$output"

else
  zenity --info --text="No columns selected."
fi
fi
