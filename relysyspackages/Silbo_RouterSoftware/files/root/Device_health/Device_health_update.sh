#!/bin/sh

rm /www/health_parameter.json
sleep 1
touch /www/health_parameter.json
chmod 777 /www/health_parameter.json
sleep 1

OutputJSON="/www/health_parameter.json"
echo "{" >> "$OutputJSON" # Start of JSON structure

input_config_file="/root/Device_health/JsonKeyParametersIndex.cfg"
output_config_file="/etc/config/Health_Jsonconfig"
local_value_file="/root/Device_health/Device_health_value.txt"
name_mapping_file="/root/Device_health/JsonKeyParameters.cfg"

# Read the entire content of localvalue.txt into a single variable
local_values=""
while IFS= read -r line; do
    local_values="$local_values$line,"
done < "$local_value_file"

# Remove the trailing comma
local_values="${local_values%,}"

# Initialize index
index=0
total_params=$(wc -l < "$input_config_file")
current_param=0

# Function to get the name mapping from JsonKeyParameters.cfg
get_param_name() {
    param=$1
    # Get the name without extra spaces or quotes
    name=$(grep "^$param=" "$name_mapping_file" | cut -d'=' -f2 | tr -d '"')
    echo "$name"
}

# Read each line from the input configuration file
while IFS= read -r line; do
    param=$(echo "$line" | xargs)  # Trim extra whitespace

    if [ -n "$param" ]; then
        # Find the corresponding key for the parameter
        key=$(awk -v RS="" '/JsonRs485Keyconfig/{print; exit}' "$output_config_file" | grep -E "option [^ ]+ '$param'" | awk '{print $2}' | tr -d "'")

        if [ -n "$key" ]; then
            number="${key#Key}"
        else
            number=""
        fi
        
        # Get the corresponding value from local values
        value=$(echo "$local_values" | cut -d',' -f"$((number + 1))")
        if [ -n "$value" ]; then
            echo "$param:$value" 
        else
            value="null" # Assign null if no value is found
        fi

        # Get the name from JsonKeyParameters.cfg
        param_name=$(get_param_name "$param")
        if [ -z "$param_name" ]; then
            param_name="$param"  # If no name is found, default to the param itself
        fi

        # Write the parameter name and its value to the JSON file
        current_param=$((current_param + 1))
        if [ "$current_param" -lt "$total_params" ]; then
            echo "  \"$param_name\":\"$value\"," >> "$OutputJSON"
        else
            echo "  \"$param_name\":\"$value\"" >> "$OutputJSON"  # No comma for the last parameter
        fi
        
        index=$((index + 1))
    fi
done < "$input_config_file"

echo "}" >> "$OutputJSON" # Close the JSON structure
