if [ "$(pidof polybar)" ] 
then
  killall polybar
else
  polybar -r cpu & polybar -r memory & polybar -r date & polybar -r volume & polybar -r time 
fi
