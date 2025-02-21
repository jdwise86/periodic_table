#!/bin/bash

# Define the PSQL variable for database connection
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# First check that we got an argument, if not print the specified message and exit.
if [[ -z $1 ]];then
  echo "Please provide an element as an argument."
  exit 0
fi


  # Get element data
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                   FROM elements 
                   JOIN properties USING(atomic_number) 
                   JOIN types USING(type_id) 
                   WHERE atomic_number::TEXT = '$1' 
                   OR symbol = '$1' 
                   OR name = '$1';")

  # Check if element exists
  if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit 0
  fi
   # echo -e "\nwhat's the symbol for this element?"
   # read SYMBOL

   # echo -e "\nWhat is its name?"
   # read NAME

   # echo -e "\nWhat is its atomic number?"
   # read NUMBER

   # echo -e "\nWhat is its atomic mass?"
   # read ATOMIC_MASS

   # echo -e "\nWhat is its melting point (°C)?"
   # read MELTING_POINT_C

   # echo -e "\nWhat is its boiling point (°C)?"
   # read BOILING_POINT_C

   # echo -e "\nWhat is its metal type?"
   # read TYPE

    # Get Metal Type ID
    #TYPE_ID=$($PSQL "SELECT type_id FROM types WHERE type = '$TYPE';")

    # Insert new element
    #INSERT_SYMBOL_RESULT=$($PSQL "INSERT INTO elements(atomic_number, name, symbol) VALUES('$NUMBER', '$NAME', '$SYMBOL');")

    # Insert element properties
    #INSERT_PROPERTIES_RESULT=$($PSQL "INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
                                      #VALUES('$NUMBER', '$ATOMIC_MASS', '$MELTING_POINT_C', '$BOILING_POINT_C', '$TYPE_ID');")
  
     # **Fetch the newly inserted element data*
 # ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
 #                    FROM elements 
 #                    JOIN properties USING(atomic_number) 
 #                    JOIN types USING(type_id) 
 #                    WHERE atomic_number = '$NUMBER';")


  # Parse the query result into variables
  IFS="|" read -r NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_C BOILING_POINT_C <<< "$ELEMENT"

  # Display element information
  echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius."

