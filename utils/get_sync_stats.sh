resp="{"

if [ ! -f .history ]; then
    touch .history
fi

while read date count; do 
    resp="${resp}\"${date}\": ${count}, "
done < .history

resp=$(echo $resp} | sed 's/, }$/}/g')

echo $resp