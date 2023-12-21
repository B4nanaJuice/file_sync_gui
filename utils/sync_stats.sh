if [ ! -f .history ]; then
    touch .history
fi

if [ $(grep $(date +"%d-%m-%y") .history | wc -l) -eq 0 ]; then 
    echo $(date +"%d-%m-%y") 1 >> .history
else 
    date=$(date +"%d-%m-%y")
    count=$(grep $date .history | awk '{print $2}')
    count=$((count + 1))
    sed -i "s/^\($date\) [0-9]*$/\1 $count/g" .history
fi