#! /bin/bash


# Rename all file paths to shorter names
clean=$(locate clean_file.txt)
entered=$(locate entered_file.txt)
count=$(locate count_output.txt)
percentage=$(locate percentage_output.txt)
sorted=$(locate sorted_output.txt)


# Clean all files
> $clean
> $entered
> $count
> $percentage
> $sorted


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
tr -cd "[:alpha:]" < $processing_file | tr "[:upper:]" "[:lower:]" > "$clean"


# Count total amount of charcters
total_count=$(cat "$clean" | wc -c)


# Put enters after each character
cat "$clean" | sed 's/./&\n/g' > "$entered"


# Sort the characters
for i in {a..z};
  do
  letter_count=$(cat "$entered" | tr -cd "$i" | wc -c)
  echo "$i: $letter_count" >> "$count"
 # Calculate percentage occurrence
  percentage_occurrence=$(echo "scale=3; $letter_count / $total_count * 100" | bc)
 # Remove trailing zeros
  if [[ "$percentage_occurrence" =~ 00+$ ]]; then
    percentage_occurrence=$(echo "$percentage_occurrence" | sed 's/00+$//')
  fi


# Print in readable format
  echo "$i: $percentage_occurrence%" >> "$percentage"
  done


# Sort them by amount of occurrences
cat "$percentage" | sort -n -r  -t ":" -k 2 > "$sorted"
cat "$sorted"

###############################################################################################





