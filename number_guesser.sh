#! /bin/bash

lower_border=$1
upper_border=$2

while true;
do
  if [[ $lower_border -gt $upper_border ]] || [[ $((upper_border - lower_border)) -le 5 ]] || [[ -z $lower_border ]] || [[ -z $upper_border ]];
  then
    echo "Your borders must be in the correct order and have a difference greater than 5"
    read -p "Give new borders in this order: \"lower_border\" \"upper_border\": " lower_border upper_border
  else
    break
  fi
done

correct_value=$((RANDOM % (upper_border - lower_border + 1) + lower_border))

#echo $correct_value

# Checking part
while true;
do
  read -p "Guess the number between $lower_border - $upper_border: " guess

  if [[ $guess -eq $correct_value ]];
  then
    echo "Your guess is correct, the correct number was $correct_value"
    echo "Congratulations, you've won!!"
    echo "
    _____.___.                                     ._._.
    \__  |   | ____  __ __  __  _  ______   ____   | | |
     /   |   |/  _ \|  |  \ \ \/ \/ /  _ \ /    \  | | |
     \____   (  <_> )  |  /  \     (  <_> )   |  \  \|\|
     / ______|\____/|____/    \/\_/ \____/|___|  /  ____
     \/                                        \/   \/\/
    "
    break
  elif [[ $guess -lt $correct_value ]];
  then
    echo "Your guess is incorrect, guess higher!"
  elif [[ $guess -gt $correct_value ]];
  then
    echo "Your guess is incorrect, guess lower!"
  fi
done
