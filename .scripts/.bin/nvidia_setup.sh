monitor1=$(xrandr --query | grep " connected" | head -n 1 | cut -d " " -f 1)
monitor2=$(xrandr --query | grep " connected" | tail -n 1 | cut -d " " -f 1)
num_monitors=$(xrandr --query | grep " connected" | wc -l)

if [ "$num_monitors" -eq 1 ]; then
	nvidia-settings --assign CurrentMetaMode="$monitor1: nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
elif [ "$num_monitors" -eq 2 ]; then
	nvidia-settings --assign CurrentMetaMode="$monitor2: nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }, $monitor1: nvidia-auto-select +1920+0 { ForceFullCompositionPipeline = On }"
fi
