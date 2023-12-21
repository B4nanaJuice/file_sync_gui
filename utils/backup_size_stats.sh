resp="{"
for d in $(ls .backup/); do 
    size=$(find .backup/$d/ -type f | xargs ls -l | awk '{s+=$5} END{print s}')
    files=$(find .backup/$d/ -type f | wc -l)
    resp="$resp \"$d\": {\"count\":$files,\"size\":$size}," 
done
echo "$resp}" | sed 's/,}$/}/g'