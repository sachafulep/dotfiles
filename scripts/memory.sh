string=$(free -m | grep Mem)
usage=$(echo $string | tr " " "\n" | sed -n '3p')

echo $usage