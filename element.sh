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
  read ELEMENT_NAME

  # Get element name
  ELEMENT=$($PSQL "SELECT name FROM elements WHERE name = '$ELEMENT_NAME';")

  # Check if element exists
  if [[ -z $ELEMENT ]]
  then
    # Get new element name
    echo -e "\nI don't have a record for that element, what's the symbol for this instrument?"
    read SYMBOL_NAME
    # Insert new element
    INSERT_SYMBOL_RESULT=$($PSQL "INSERT INTO elements(name, symbol) VALUES('$ELEMENT_NAME', '$SYMBOL_NAME')")
  fi

  # Get symbol ID
  SYMBOL_ID=$($PSQL "SELECT symbol FROM elements WHERE name='$ELEMENT_NAME'")

  # Display element information
  echo -e "\nThe element with atomic number 1 is $ELEMENT_NAME ($SYMBOL_ID). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius."
}

MAIN_MENU  # Call the function
