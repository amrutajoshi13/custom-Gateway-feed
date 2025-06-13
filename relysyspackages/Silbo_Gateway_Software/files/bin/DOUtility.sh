

#!/bin/sh

sleep 3
dido_num=$(uci get digitalinputconfig.didogpioconfig.numberOfDido)
if [ "$dido_num" -eq 2 ]; then
	pin1=$(uci get digitalinputconfig.didogpioconfig.do1)
	pin2=$(uci get digitalinputconfig.didogpioconfig.do2)
	echo $pin1 > /sys/class/gpio/export
	echo $pin2 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio$pin1/direction
	echo out > /sys/class/gpio/gpio$pin2/direction
elif [ "$dido_num" -eq 4 ]; then
	pin1=$(uci get digitalinputconfig.didogpioconfig.do1)
	pin2=$(uci get digitalinputconfig.didogpioconfig.do2)
	pin3=$(uci get digitalinputconfig.didogpioconfig.do3)
	pin4=$(uci get digitalinputconfig.didogpioconfig.do4)
	echo $pin1 > /sys/class/gpio/export
	echo $pin2 > /sys/class/gpio/export
	echo $pin3 > /sys/class/gpio/export
	echo $pin4 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio$pin1/direction
	echo out > /sys/class/gpio/gpio$pin2/direction
	echo out > /sys/class/gpio/gpio$pin3/direction
	echo out > /sys/class/gpio/gpio$pin4/direction
else
	echo "dido_num is neither 2 nor 3."
fi
value=1
for gpio_port in $(seq 1 "$dido_num"); do

    DO_out=$(/root/DOUtilityIndividualTestComponent/DOUtilityIndividual "$gpio_port" "$value" 2>&1)
    last_line_DO=$(echo "$DO_out" | tail -n 1)
    # Extract the value from last_line_DO as before

    DI_out=$(/root/DIUtilityIndividualTestComponent/DIUtilityIndividual "$gpio_port" 2>&1)
    last_line_DI=$(echo "$DI_out" | grep -o -E "[0-9]+" | tail -n 1 | cut -d ' ' -f 4)

    if [[ "$last_line_DI" == "$value" ]]; then
        echo "DO $gpio_port: Expected $value and got $last_line_DI"
    else
        echo "DO $gpio_port: Expected $value but got $last_line_DI"
    fi
    sleep 1
done

sleep 5

value=0

for gpio_port in $(seq 1 "$dido_num"); do
    DO_out=$(/root/DOUtilityIndividualTestComponent/DOUtilityIndividual "$gpio_port" "$value" 2>&1)
    last_line_DO=$(echo "$DO_out" | tail -n 1)
    # Extract the value from last_line_DO as before

    DI_out=$(/root/DIUtilityIndividualTestComponent/DIUtilityIndividual "$gpio_port" 2>&1)
    last_line_DI=$(echo "$DI_out" | grep -o -E "[0-9]+" | tail -n 1 | cut -d ' ' -f 4)

    if [[ "$last_line_DI" == "$value" ]]; then
        echo "DO $gpio_port: Expected $value and got $last_line_DI"
    else
        echo "DO $gpio_port: Expected $value but got $last_line_DI"
    fi
    sleep 1
done
if [ "$dido_num" -eq 2 ]; then
	echo $pin1 > /sys/class/gpio/unexport
	echo $pin2 > /sys/class/gpio/unexport
else
	echo $pin1 > /sys/class/gpio/unexport
	echo $pin2 > /sys/class/gpio/unexport
	echo $pin3 > /sys/class/gpio/unexport
	echo $pin4 > /sys/class/gpio/unexport
fi
sleep 5



