#!/bin/bash

# Define the PSQL variable for database connection
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Display the welcome message
echo -e "\n~~~~~ periodic_table ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]; then
    echo -e "\n$1"
  fi

  echo "Please provide an element as an argument."
  read INPUT

  PRINT_ELEMENT "$INPUT"
}

PRINT_ELEMENT() {
  INPUT=$1
  if [[ ! $INPUT =~ ^[0-9]+$ ]]; then
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT';") | sed 's/ //g')
  else
    ATOMIC_NUMBER=$INPUT
  fi

  # Get element data
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                   FROM elements 
                   JOIN properties USING(atomic_number) 
                   JOIN types USING(type_id) 
                   WHERE atomic_number::TEXT = '$ATOMIC_NUMBER' 
                   OR symbol = '$INPUT' 
                   OR name = '$INPUT';")

  # Check if element exists
  if [[ -z $ELEMENT ]]; then
    echo -e "\nI don't have a record for that element."

    echo -e "\nwhat's the symbol for this element?"
    read SYMBOL

    echo -e "\nWhat is its name?"
    read NAME

    echo -e "\nWhat is its atomic number?"
    read ATOMIC_NUMBER

    echo -e "\nWhat is its atomic mass?"
    read ATOMIC_MASS

    echo -e "\nWhat is its melting point (°C)?"
    read MELTING_POINT

    echo -e "\nWhat is its boiling point (°C)?"
    read BOILING_POINT

    echo -e "\nWhat is its metal type?"
    read METAL_TYPE

    # Get Metal Type ID
    METAL_TYPE_ID=$($PSQL "SELECT type_id FROM types WHERE type = '$METAL_TYPE';")

    # Insert new element
    INSERT_SYMBOL_RESULT=$($PSQL "INSERT INTO elements(atomic_number, name, symbol) VALUES('$ATOMIC_NUMBER', '$NAME', '$SYMBOL');")

    # Insert element properties
    INSERT_PROPERTIES_RESULT=$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
                                      VALUES('$ATOMIC_NUMBER', '$ATOMIC_MASS', '$MELTING_POINT', '$BOILING_POINT', '$METAL_TYPE_ID');")
  
     # **Fetch the newly inserted element data*
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                     FROM elements 
                     JOIN properties USING(atomic_number) 
                     JOIN types USING(type_id) 
                     WHERE atomic_number = '$ATOMIC_NUMBER';")
  fi

  # Parse the query result into variables
  IFS="|" read -r ATOMIC_NUMBER SYMBOL NAME METAL_TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT"

  # Display element information
  echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $METAL_TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT°C and a boiling point of $BOILING_POINT°C."
}

# Call the function
MAIN_MENU
