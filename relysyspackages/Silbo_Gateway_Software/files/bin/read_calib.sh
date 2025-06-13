#!bin/bash
 
. /usr/local/bin/Testscripts/current_resistance.txt

. /usr/local/bin/Testscripts/testscriptconfig.cfg

NoOfChannels=$(uci get analoginputconfig.analoginputconfig.NoOfInputs)
ChannelType1=$(uci get analoginputconfig.analoginputconfig.ChannelType1)
ChannelType2=$(uci get analoginputconfig.analoginputconfig.ChannelType2)
ChannelType3=$(uci get analoginputconfig.analoginputconfig.ChannelType3)
ChannelType4=$(uci get analoginputconfig.analoginputconfig.ChannelType4)



if [ -z "$CurDevResistance_1" ]; then
    CurDevResistance_1=$defCurDevResistance
    CurDevResistance_1=$(echo "$CurDevResistance_1 * 100000" | bc)
else
   CurDevResistance_1=$(echo "$CurDevResistance_1 * 100000" | bc)
fi

if [ -z "$CurDevResistance_2" ]; then
    CurDevResistance_2=$defCurDevResistance
    CurDevResistance_2=$(echo "$CurDevResistance_2 * 100000" | bc)    
else
    CurDevResistance_2=$(echo "$CurDevResistance_2 * 100000" | bc)
fi

if [ -z "$CurDevResistance_3" ]; then
    CurDevResistance_3=$defCurDevResistance
    CurDevResistance_3=$(echo "$CurDevResistance_3 * 100000" | bc)   
else
    CurDevResistance_3=$(echo "$CurDevResistance_3 * 100000" | bc)
fi

if [ -z "$CurDevResistance_4" ]; then
    CurDevResistance_4=$defCurDevResistance
    CurDevResistance_4=$(echo "$CurDevResistance_4 * 100000" | bc)    
else
    CurDevResistance_4=$(echo "$CurDevResistance_4 * 100000" | bc)
fi

StoreResistances() 
{
	
CurDevResistance1=$CurDevResistance_1
 
	local var1=${CurDevResistance1:0:2}
	local var2=${CurDevResistance1:2:2}
	local var3=${CurDevResistance1:4:2}
	local var4=${CurDevResistance1:6:2}
	printf "\x$var1\x$var2\x$var3\x$var4" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0x200))
CurDevResistance2=$CurDevResistance_2
 
	local var1=${CurDevResistance2:0:2}
	local var2=${CurDevResistance2:2:2}
	local var3=${CurDevResistance2:4:2}
	local var4=${CurDevResistance2:6:2}
	printf "\x$var1\x$var2\x$var3\x$var4" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0x210))
CurDevResistance3=$CurDevResistance_3
 
	local var1=${CurDevResistance3:0:2}
	local var2=${CurDevResistance3:2:2}
	local var3=${CurDevResistance3:4:2}
	local var4=${CurDevResistance3:6:2}
	printf "\x$var1\x$var2\x$var3\x$var4" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0x220))
CurDevResistance4=$CurDevResistance_4
 
	local var1=${CurDevResistance4:0:2}
	local var2=${CurDevResistance4:2:2}
	local var3=${CurDevResistance4:4:2}
	local var4=${CurDevResistance4:6:2}
	printf "\x$var1\x$var2\x$var3\x$var4" | dd conv=notrunc of=/tmp/factory.bin bs=1 seek=$((0x230))
}
 
 
ReadResistances() {
    # Read the stored resistance hex values from flash
    local res1_hex=$(hexdump -v -n 4 -s 0x200 -e '4/1 "%02X"' /tmp/factory.bin)
  CurDevResistance1=$(echo "scale=4; $res1_hex / 100000" | bc)
    echo "CurDevResistance_1=$CurDevResistance1"
	uci set ADCUtilityConfigGeneric.adcutilityconfig.CurDevResistance_1=$CurDevResistance1
	uci commit ADCUtilityConfigGeneric
    local res2_hex=$(hexdump -v -n 4 -s 0x210 -e '4/1 "%02X"' /tmp/factory.bin)
  CurDevResistance2=$(echo "scale=4; $res2_hex / 100000" | bc)
    echo "CurDevResistance_2=$CurDevResistance2"
	uci set ADCUtilityConfigGeneric.adcutilityconfig.CurDevResistance_2=$CurDevResistance2
	uci commit ADCUtilityConfigGeneric    
    local res3_hex=$(hexdump -v -n 4 -s 0x220 -e '4/1 "%02X"' /tmp/factory.bin)
  CurDevResistance3=$(echo "scale=4; $res3_hex / 100000" | bc)
    echo "CurDevResistance_3=$CurDevResistance3"
	uci set ADCUtilityConfigGeneric.adcutilityconfig.CurDevResistance_3=$CurDevResistance3
	uci commit ADCUtilityConfigGeneric    
    local res4_hex=$(hexdump -v -n 4 -s 0x230 -e '4/1 "%02X"' /tmp/factory.bin)
  CurDevResistance4=$(echo "scale=4; $res4_hex / 100000" | bc)
    echo "CurDevResistance_4=$CurDevResistance4"
	uci set ADCUtilityConfigGeneric.adcutilityconfig.CurDevResistance_4=$CurDevResistance4
	uci commit ADCUtilityConfigGeneric    
}
 
ReadResistances

exit 0


