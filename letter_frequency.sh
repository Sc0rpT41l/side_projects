#! /bin/bash

# Clean all files

> ./output_files/clean_file.txt
> ./output_files/entered_file.txt
> ./output_files/count_output.txt
> ./output_files/percentage_output.txt
> ./output_files/sorted_output.txt


# Read the given file
# Check if given file exists and is right format
while true; 
do
  read -p "Give your file to process: " processing_file
  # Check if the file exists
  if [[ -f "$processing_file" ]]; then
    # Check if the file is empty
    if file "$processing_file" | grep -q "empty"; then
      echo "The file is empty. Please provide a non-empty file."
      continue
    fi

    # Check if the file is a valid text file
    if file "$processing_file" | grep -Eq "ASCII text|UTF-8 Unicode text|ISO-8859 text|Non-ISO extended-ASCII text|Unicode text"; then
      echo "The file exists and is a valid file type."
      break
    else
      echo "The file exists but isn't a valid text file. Please try again."
    fi
  else
    echo "Please provide an existing file."
  fi
done


# Remove any junk
cat $processing_file | tr -cd "[:alpha:]" | tr "[:upper:]" "[:lower:]" > ./output_files/clean_file.txt


# Count total amount of charcters
total_count=$(cat ./output_files/clean_file.txt | wc -c)


# Put enters after each character
cat ./output_files/clean_file.txt | sed 's/./&\n/g' > ./output_files/entered_file.txt


# Sort the characters
for i in {a..z};
  do
  letter_count=$(cat ./output_files/entered_file.txt | tr -cd "$i" | wc -c)
  echo "$i: $letter_count" >> ./output_files/count_output.txt
 # Calculate percentage occurrence
  percentage_occurrence=$(echo "scale=3; $letter_count / $total_count * 100" | bc)
 # Remove trailing zeros
  if [[ "$percentage_occurrence" =~ 00+$ ]]; then
    percentage_occurrence=$(echo "$percentage_occurrence" | sed 's/00*$//') 
  fi


# Print in readable format
  echo "$i: $percentage_occurrence%" >> ./output_files/percentage_output.txt
  done


# Sort them by amount of occurrences
cat output_files/percentage_output.txt | sort -n -r  -t ":" -k 2 > output_files/sorted_output.txt 
cat output_files/sorted_output.txt

###############################################################################################





