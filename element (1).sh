#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Query to get the element information based on the input argument
query="SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
FROM elements
JOIN properties ON elements.atomic_number = properties.atomic_number
JOIN types ON properties.type_id = types.type_id
WHERE elements.atomic_number::text = '$1' OR elements.symbol = '$1' OR elements.name = '$1';"

# Execute the query and store the result
result=$(psql --username=freecodecamp --dbname=periodic_table -t --no-align -c "$query")

# Check if the result is empty
if [ -z "$result" ]; then
  echo "I could not find that element in the database."
  exit 0
else
  # Parse the result
  IFS="|" read atomic_number name symbol type atomic_mass melting_point boiling_point <<< "$result"

  # Output the formatted result
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
fi
