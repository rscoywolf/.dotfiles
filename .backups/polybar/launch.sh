#!/bin/sh

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
num_monitors=$(xrandr --query | grep " connected" | wc -l)

# Get the names of the connected monitors
monitor1=$(xrandr --query | grep " connected" | head -n 1 | cut -d " " -f 1)
monitor2=$(xrandr --query | grep " connected" | tail -n 1 | cut -d " " -f 1)

# Set the monitor setting for each bar
sed -i "/^\[bar\/bar1\]/,/^\[bar\/bar2\]/ s/^\(monitor\s*=\s*\).*$/\1$monitor1/" ~/.config/polybar/config.ini
sed -i "/^\[bar\/bar2\]/,/^\[module\// s/^\(monitor\s*=\s*\).*$/\1$monitor2/" ~/.config/polybar/config.ini

# Launch the appropriate number of bars
if [ "$num_monitors" -eq 1 ]; then
    polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
elif [ "$num_monitors" -eq 2 ]; then
    polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
    polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown
fi

echo "Bars launched..."
