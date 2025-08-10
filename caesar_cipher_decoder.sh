#!/usr/bin/env bash

# Check if running in a VS Code debugging session
if [ -t 0 ]; then
    # Only use 'read' if running in an interactive terminal
    read -p "Give your text to work with: " input
    read -p "What do you want to do: encrypt / decrypt ? " mode
fi

# Define array with letters of alphabet
upper_array=({A..Z})
lower_array=({a..z})

counter=1

for i in {1..25}
do
    # Uppercase array
    upper_pos0=${upper_array[0]}
    unset 'upper_array[0]'
    upper_array+=("$upper_pos0")
    echo
    upper_array=("${upper_array[@]}")
    str_array_upper=$(IFS=; echo "${upper_array[*]}")

    # Lowercase array
    lower_pos0=${lower_array[0]}
    unset 'lower_array[0]'
    lower_array+=("$lower_pos0")
    echo
    lower_array=("${lower_array[@]}")
    str_array_lower=$(IFS=; echo "${lower_array[*]}")

    if [ "$mode" == "encrypt" ]; then # To encrypt the input
        translated_text=$(echo $input | tr 'A-Za-z' $str_array_upper$str_array_lower)
    else # To decrypt the input
        translated_text=$(echo $input | tr $str_array_upper$str_array_lower 'A-Za-z')
    fi

    echo "$counter: $translated_text"
    ((counter++))

    sleep 0.5
done


