#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
    then
    #if not a number
    ELEM_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1' OR symbol='$1';")
  else
    #if is a number
    ELEM_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  fi

  if [[ -z $ELEM_ID ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT=$($PSQL "SELECT symbol, name FROM elements WHERE atomic_number=$ELEM_ID;")
    PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$ELEM_ID;")
    TYPE=$($PSQL "SELECT type FROM properties p INNER JOIN types t ON t.type_id=p.type_id WHERE p.atomic_number=$ELEM_ID;")
    echo $ELEMENT | while read SYMBOL BAR NAME
    do
      echo $PROPERTIES | while read MASS BAR MELTPOINT BAR BOILPOINT
      do
        echo -e "The elemen with atomic number $(echo $ELEM_ID | sed 's/ |/"/') is $NAME ($SYMBOL). It's a $(echo $TYPE | sed 's/ |/"/'), with a mas of $MASS amu. $NAME has a melting point of $MELTPOINT celsius and a boiling point of $BOILPOINT celsius."
      done
    done
  fi
else
  #return insert argument
  echo "Please provide an element as an argument."

fi