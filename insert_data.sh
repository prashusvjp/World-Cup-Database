#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games,teams;")
#Inserting Teams
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR == year ]]
  then
    #ignoring heading 
    continue
  fi
  #check team exists in DB
  RESULT_W=$($PSQL "select team_id from teams where name='$WINNER';")
  RESULT_O=$($PSQL "select team_id from teams where name='$OPPONENT';")
  if [[ -z $RESULT_W ]]
  then
    INSERT_RESULT=$($PSQL "insert into teams(name) values('$WINNER');")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo $WINNER team inserted into database
    fi
  fi

  if [[ -z $RESULT_O ]]
  then
    INSERT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT');")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo $OPPONENT team inserted into database
    fi
  fi
  #get winner_id and opponent_id
  RESULT_W=$($PSQL "select team_id from teams where name='$WINNER';")
  RESULT_O=$($PSQL "select team_id from teams where name='$OPPONENT';")
  INSERT_RESULT= $($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$RESULT_W,$RESULT_O,$W_GOALS,$O_GOALS);")
  if [[ $INSERT_RESULT == "INSERT 0 1" ]]
  then
    echo -e "\nGame recorded"
  fi
done
