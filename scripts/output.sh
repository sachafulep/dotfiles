runningSink=$(pactl list short sinks | grep RUNNING)
headphoneSink=$(pactl list short sinks | grep Schiit)
speakerSink=$(pactl list short sinks | grep AudioQuest)
headphoneSinkID=${headphoneSink:0:1}
speakerSinkID=${speakerSink:0:1}

if [ "$runningSink" == "" ]; then
    runningSink=$(pactl list short sinks | grep IDLE)
fi

result=$(grep -c Schiit <<<"$runningSink")

if [ $result == 1 ]; then
    pacmd suspend-sink $headphoneSinkID 1
    pacmd suspend-sink $speakerSinkID 0
    pacmd set-default-sink $speakerSinkID
    pactl list short sink-inputs | while read stream; do
        streamId=$(echo $stream | cut '-d ' -f1)
        pactl move-sink-input "$streamId" "$speakerSinkID"
    done
else
    pacmd suspend-sink $speakerSinkID 1
    pacmd suspend-sink $headphoneSinkID 0
    pacmd set-default-sink $headphoneSinkID
    pactl list short sink-inputs | while read stream; do
        streamId=$(echo $stream | cut '-d ' -f1)
        pactl move-sink-input "$streamId" "$headphoneSinkID"
    done
fi
