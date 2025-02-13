#!/bin/bash

# Define the PSQL variable for database connection
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Display the welcome message
echo -e "\n~~~~~ periodic_table ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

echo "Please provide an element as an argument."

}

MAIN_MENU  # Call the function
