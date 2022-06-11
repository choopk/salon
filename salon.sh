#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
MAIN_MENU() {
 echo -e "\n~~~~~ MY SALON ~~~~~\n"
 echo -e "Welcome to My Salon, how can I help you?\n"
 SHOW_SERVICES
 read SERVICE_ID_SELECTED
 case $SERVICE_ID_SELECTED in
 1|2|3|4|5) GET_PHONE_NUMBER;;
 *) SHOW_SERVICES "\nI could not find that service. What would you like today?";;
 esac
}

GET_PHONE_NUMBER (){
  echo -e "\nWhat's your phone number?" 
  read CUSTOMER_PHONE
  PHONENUMBER=$($PSQL "select phone from customers where phone ='$CUSTOMER_PHONE'")
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_NEW_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
    INSERT_NEW_APPOINTMENT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

SHOW_SERVICES()
{
  if [[ ! -z $1 ]]
  then
   echo -e $1
  fi
  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
}

MAIN_MENU