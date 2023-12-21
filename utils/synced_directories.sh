source $HOME/file_sync_gui/utils/data.sh
dir_a=$(cat $SYNCHRO_FILE | awk '{print $1}')
dir_b=$(cat $SYNCHRO_FILE | awk '{print $2}')
ref_date=$(date -d "$(awk '{print $3}' $SYNCHRO_FILE | sed 's/-/ /g')" +"%y%m%d%H%M%S")
date_a=$(date -d "$(find $dir_a -type f -exec stat \{} --printf="%y\n" \; | sort -n -r | head -n 1)" +"%y%m%d%H%M%S")
date_b=$(date -d "$(find $dir_b -type f -exec stat \{} --printf="%y\n" \; | sort -n -r | head -n 1)" +"%y%m%d%H%M%S")

# Trouver où que ça merde car les dates ne peuvent pas se comparer, ca execute le else à chaque fois
if [[ "$date_a" > "$ref_date" ]]; then
    changed_a=0
else
    changed_a=1
fi

if [[ "$date_b" > "$ref_date" ]]; then
    changed_b=0
else
    changed_b=1
fi

    
echo "{\"$(echo $dir_a | sed 's/^.*\///g')\": $changed_a, \"$(echo $dir_b | sed 's/^.*\///g')\": $changed_b}"