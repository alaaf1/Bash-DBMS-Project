#! /usr/bin/bash
function list_dbs(){
touch databases.txt
echo -n "" > databases.txt
declare -i dbcount=0
for var in $(ls)
do
if [[ -d $var ]]
then
	if [[ $var =~ ^[.].*$ ]]
	then
	continue
	else
	dbcount=$dbcount+1
	echo $var >> databases.txt
	fi
fi
done
echo $dbcount
}

function list_tables(){
touch tables.txt
echo -n "" > tables.txt
declare -i tablecount=0
for var in $(ls )
do
if [[ -f $var ]]
then
	if [[ $var =~ ^[.].*$ || $var =~ .*\.meta$ || $var =~ ^tables.txt$ ]]
	then
	continue
	else
	tablecount=$tablecount+1
	echo "$var" | sed 's/\.data$//' >> tables.txt
	fi
fi
done
echo $tablecount
}

function findPK_index(){
colnames=()
pk=0
IFS='|' read -a colnames<<<$(sed -n '1p' "$1.meta")
pk=$(sed -n '3p' "$1.meta")
for i in ${!colnames[@]}
do
if [[ ${colnames[$i]} == $pk ]]
then
echo $i
break
else
echo -1
fi
done
}
function validate_input(){
IFS='|' read -a colnames<<<$(sed -n '1p' "$3.meta")
IFS='|' read -a coltypes<<<$(sed -n '2p' "$3.meta")
IFS='|' read -a pk<<<$(sed -n '3p' "$3.meta")
if [[ ${coltypes[$1]} == INT ]]
then
	if [[ $2 =~ ^[0-9]+$ ]]
	then
	echo true
	else
	echo false
	fi

elif [[ ${coltypes[$1]} == VARCHAR ]]
then
	if [[ $2 =~ [^|]+ ]]
	then
	echo true
	else
	echo false
	fi
fi
}

