headphoneSink=$(pactl list short sinks | grep Schiit)
headphoneSinkID=${headphoneSink:0:1}

volumeLine=$(pactl list sinks | perl -000ne 'if(/Sink #'"$headphoneSinkID"'/){/(Volume:.*)/; print "$1\n"}')
muteLine=$(pactl list sinks | perl -000ne 'if(/Sink #'"$headphoneSinkID"'/){/(Mute:.*)/; print "$1\n"}')

if [[ "$muteLine" == *"yes"* ]]; then
    echo "0"
else
    volumeLinePart=$(echo $volumeLine | cut -d "%" -f 1) 
    volume=$(echo $volumeLinePart | rev | cut -d ' ' -f1 | rev)
    echo "${volume}"
fi
