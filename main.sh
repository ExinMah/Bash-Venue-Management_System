#!/bin/bash

# Author1:  Mah Exin
# Author2:  Pak Xiao Thong
# Date:    24/07/2023
# Course:  BACS2093 Operating Systems
# Purpose: A University Venue Management Menu that allow us to register, search a patron (a new student), add and list venues available and to allow the patron to book a venue.

# Regular Expressions Check
isStudId_regex='^[0-9]{2}[A-Z]{3}[0-9]{5}$'
isLectId_regex='^[0-9]{4}$'
isStudEmail_regex='^[A-Za-z0-9._%+-]+@student\.tarc\.edu\.my$' #TAR UMT Student Email
isLectEmail_regex='^[A-Za-z0-9._%+-]+@tarc\.edu\.my$' #TAR UMT Lecture Email
isName_regex='^[A-Za-z \W]+$'

isContact_regex='^[0-9]{10,11}$'
isContactWithDash_regex='^[0-9]{3}-[0-9]{7,8}$'

isAlpha_regex='^[A-Z]+$' #For venue
isDigit_regex='^[0-9]+$'

isDate_regex='^(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[01])/20[0-9]{2}$'
isTime_regex='^(0?[89]|1[0-9]|20):[0-5][0-9]$'

# Patron Registration
# Author     : Mah Exin
# Task       : Register New Patron Function
# Description: Add a new patron and adding it to patron.txt file
# Parameters : PatronID, PatronName, PatronContact, PatronEmail, PatronRegOption
# Return     : The whole function that adds a new patron to patron.txt 
function register_patron() {
  while true; do
    echo
    echo "Patron Registration"
    echo "==================="

    while true; do
      read -p "Patron ID (As per TAR UMT format (21WMR03456)): " PatronID
      # Patron ID validation 
      PatronDetails=$(grep "^$PatronID:" patron.txt)
      if [[ ! $PatronID =~ $isStudId_regex && ! $PatronID =~ $isLectId_regex ]]; then
        echo "Invalid ID. Please enter a valid ID."
        echo
      elif [ -n "$PatronDetails" ]; then
        echo "ID already exist. Please enter a new ID."
        echo
      else
        break
      fi
    done
    
    while true; do
      read -p "Patron Full Name (As per NRIC): " PatronName
      # Patron Name validation
      if [[ ! $PatronName =~ $isName_regex ]]; then
        echo "Invalid name. Please enter a valid name."
        echo
      else
        break
      fi
    done
    
    while true; do
      read -p "Contact Number: " PatronContact
      # Patron Contact validation
      if [[ ! $PatronContact =~ $isContactWithDash_regex && ! $PatronContact =~ $isContact_regex ]]; then
        echo "Invalid contact number. Please enter a valid contact number."
        echo
      else
        break
      fi
    done
    
    while true; do
      read -p "Email Address (As per TAR UMT format): " PatronEmail
      # Patron Email validation
      if [[ ! $PatronEmail =~ $isStudEmail_regex && ! $PatronEmail =~ $isLectEmail_regex ]]; then
        echo "Invalid email address. Please enter a valid email address."
        echo
      else
        break
      fi
    done
    
    ## Save info to patron.txt file
    echo "$PatronID:$PatronName:$PatronContact:$PatronEmail" >> patron.txt
    echo "Patron added!"
    
    ## Ask if want to continue in this function
    while true; do
      echo
      echo "Register Another Patron? (y)es or (q)uit :"
      echo "Press (q) to return to University Venue Management Menu." 
      read PatronRegOption
      
      case "$PatronRegOption" in
        y|Y) 
          break
          ;;
        q|Q) 
          main_menu
          ;;
        *)
          echo "Invalid choice. Please enter again"
          ;;
      esac
    done
    
    echo
  done
}

# Search Patron
# Author     : Mah Exin
# Task       : Search and return the patron information based on the PatronID given
# Description: Add a new patron and adding it to patron.txt file
# Parameters : PatronID, PatronDetails, PatronInfo
# Return     : The Full Name, Contact Number and Email Address of the PatronId searched
function search_patron() {
  echo
  echo "Search Patron Details"
  echo "====================="
  
  while true; do
    echo
    read -p "Enter Patron ID: " PatronID
    echo "---------------------------------------------------------------"
    echo
    
    ## Search patron.txt for Patron ID
    PatronDetails=$(grep "^$PatronID:" patron.txt)
    if [ -n "$PatronDetails" ]; then
      IFS=':' read -ra PatronInfo <<< "$PatronDetails"
      echo "Full Name: ${PatronInfo[1]}"
      echo "Contact Number: ${PatronInfo[2]}"
      echo "Email Address: ${PatronInfo[3]}"
    else
      echo "Patron ID not found."
    fi
    
    ## Ask if want to continue in this function
    while true; do
      echo
      echo "Search Another Patron? (y)es or (q)uit:"
      echo "Press (q) to return to University Venue Management Menu."  
      read SearchPatronOption
      
      case "$SearchPatronOption" in
        y|Y) 
          break
          ;;
        q|Q) 
          main_menu
          ;;
        *)
          echo "Invalid choice. Please enter again"
          ;;
      esac
    done
    
    echo
  done
}

# Add Venue
# Author     : Pak Xiao Thong
# Task       : Add new venue 
# Description: Add a new venue to venue.txt
# Parameters : BlockName, RoomNumber, RoomType, Capacity, Remarks, Status
# Return     : The whole function that adds a new venue as a new line to patron.txt 
function add_venue() {
  echo
  echo "Add New Venue"
  echo "============="

  while true; do

    ## Checking if the Block is entered correctly (Uppercase only)
    while true; do
      read -p "Block Name (UPPERCASE Alphabets Only): " BlockName
      # BlockName validation
      if [[ ! $BlockName =~ $isAlpha_regex ]]; then
        echo "Invalid Block Name. Please enter a valid block name in UPPERCASE Alphabets Only."
        echo
      else
        break
      fi
    done

    isRoomNo_regex="^($BlockName) ?[A-Z0-9\s]*$"
    while true; do    
      read -p "Room Number: " RoomNumber
      
      # BlockNumber validation
      if [[ ! $RoomNumber =~ $isRoomNo_regex ]]; then
        echo "Invalid Room Number. Please enter a valid room number for Block $BlockName." 
        echo
      else
        break
      fi
    done
  
    while true; do
      read -p "Room Type (Lecture, Lab, Tutorial): " RoomType 
      ## Check RoomType (Make sure only Lecture, Lab, Tutorial)
      case $RoomType in 
        Lecture | Lab | Tutorial)
          break
          ;;
        *)
        echo "Invalid Room Type. Please enter either Lecture, Lab, or Tutorial only."
        echo
        ;;
      esac
    done

    while true; do
      read -p "Capacity: " Capacity # Room Capacity
      # Capacity validation
      if [[ ! $Capacity =~ $isDigit_regex ]]; then 
        echo "Invalid Capacity. Please enter only numbers."
        echo
      else
        break
      fi
    done
      
    read -p "Remarks: " Remarks #Eg: Remarks: For tutorial use only
  
    ## Check Status (Make sure only Available/Unailable)
    Status="Available"
    while true; do
      read -p "Status: " Status
        
      case $Status in 
        Available | Unavailable)
          break
          ;;
        *)
          echo "Status is wrong. Only enter Available or Unavailable only."
          echo
          ;;
      esac
    done
    
    ## Save info to venue.txt file (no store status?)
    echo "$BlockName:$RoomNumber:$RoomType:$Capacity:$Remarks:$Status" >> venue.txt
    echo "Venue has been stored successfully"
    
    ## Ask if want to continue in this function
    while true; do
      echo
      echo "Add Another New Venue? (y)es or (q)uit :"
      echo "Press (q) to return to University Venue Management Menu." 
      read AddVenueOption
      
      case "$AddVenueOption" in
        y|Y) 
          break
          ;;
        q|Q) 
          main_menu
          ;;
        *)
          echo "Invalid choice. Please enter again"
          ;;
      esac
    done
    
    echo
  done
}

# List Venue
# Author     : Pak Xiao Thong
# Task       : Search and return the venue information based on the Block name given
# Description: Searching and giving out of list of rooms available under that block name
# Parameters : BlockName, VenueInfo
# Return     : An array of the rooms with the Block name
function list_venue() {
  echo
  echo "List Venue Details"
  echo "=================="
  
  while true; do
    echo
    while true; do
    read -p "Enter Block Name: " BlockName
    # BlockName validation
      if [[ ! $BlockName =~ $isAlpha_regex ]]; then
        echo "Invalid Block Name. Please enter a valid block name in UPPERCASE Alphabets Only."
        echo
      else
        break
      fi
    done
    echo "----------------------------------------------------------------------------------------"
    echo 
    echo -e "Room  \t\tRoom Type: \t\t Capacity: \t\t\tRemarks: \t\t\t\t\tStatus:"
    echo "Number:"
    echo

    grep "^$BlockName" venue.txt | while read line
      do
        IFS=':' read -ra VenueInfo <<< "$line"
        echo -e "${VenueInfo[1]} \t\t${VenueInfo[2]} \t\t\t${VenueInfo[3]} \t\t\t\t${VenueInfo[4]} \t\t${VenueInfo[5]}"
      done
    
    ## Ask if want to continue in this function
    while true; do
      echo
      echo "Search Another Block Venue? (y)es or (q)uit :"
      echo "Press (q) to return to University Venue Management Menu." 
      read ListVenueOption
      
      case "$ListVenueOption" in
        y|Y) 
          break
          ;;
        q|Q) 
          main_menu
          ;;
        *)
          echo "Invalid choice. Please enter again"
          ;;
      esac
    done
  done
}

# Book Venue
# Author1     : Pak Xiao Thong
# Author2     : Mah Exin
# Task        : Allow verified users to book a room for 30 mins to 3 hours
# Description : This functions checks if the user axist and allows them to book Available rooms for a certain period of time for tomorrow and onwards and generates a reciept of the booking
# Parameters  : PatronID, RoomID, DateBooking, TimeTo, TimeFrom, ReasonForBooking, PaxAmount
# Return      : The receipt of the booking information
function book_venue() {
  echo
  echo "Patron Details Verification"
  echo "==========================="

  PatronID=""
  RoomNo=""
  
  ## Verify if patron exists
  while true; do
    echo
    read -p "Please enter the Patron's ID Number: " PatronID
  
    ## Search patron.txt for Patron ID
    PatronDetails=$(grep "^$PatronID:" patron.txt)
    if [ -n "$PatronDetails" ]; then
    IFS=':' read -ra PatronInfo <<< "$PatronDetails"
      echo "Patron Name: ${PatronInfo[1]}"

      while true; do
        echo
        read -p "Press (n) to proceed Book Venue or (q) to reutrn to University Venue Management Menu: " ContinueBook

        case "$ContinueBook" in
          n|N)
            break
            ;;
          q|Q)
            main_menu
            ;;
          *)
            echo "Invalid input. Please enter again."
            ;;
        esac
      done
      break
    else
      echo "Patron ID not found."
    fi
  done

  echo
  echo "Booking Venue"
  echo "============="
  while true; do
    read -p "Please enter the Room Number: " RoomNo
  
    ## Check RoomNo exist or not
    RoomDetails=$(grep ":$RoomNo:" venue.txt)
    IFS=':' read -ra RoomInfo <<< "$RoomDetails"
    # Check room status
    if [ "${RoomInfo[5]}" = "Unavailable" ]; then
      echo "Sorry! The room is unavaible at that time. Please choose another room."
      echo
    elif [ -n "$RoomDetails" ]; then
      break
    else
      echo "Room Number not found. Please enter again."
      echo
    fi
  done
  
  echo "-----------------------------------------------------------"
  echo "Notes: The booking hours shall be from 8am to 8pm only. The booking duration shall be at least 30 minutes per booking."
  echo
  echo "Please enter the following details:"
  echo

  # ALSO NEED TO MAKE SURE THE TIME SLOT IS NOT ALREADY BOOKED (need to compare date and time)
  # Make sure the date is at least the day after today + Check format ([1-12]/[1-31]/[4 digits])
    # can try this to check if the date is real or not
    #if date -d "$input_date" >/dev/null 2>&1; then
    #  echo "Valid date: $input_date"
    #else
    #  echo "Invalid date: $input_date"
    #fi
  read -p "Booking Date (mm/dd/yyyy): " DateBooking

    # Make sure the time is reasonable (8am to 8pm) + Format is basically ([8-20]:[00-59] <- make sure its 00 if possible) + It cannot be 19:31 and above
  read -p "Time From (hh:mm): " TimeFrom

    # Make sure the time is at least 30 mins AFTER TimeFrom (max booking time 3 hours) + Same format from on top
  read -p "Time To (hh:mm): " TimeTo

    # Can write anything, just not empty can liao (No need checking)
  read -p "Reason for Booking: " ReasonForBooking

    # Make sure not more than Capacity
    # get capacity by
      # Use ${RoomInfo[3]} (or 4, should be 3) to get capacity number
  read -p "Number of Pax: " PaxAmount # Number of students using

  while true; do
    echo
    read -p "Press (s) to save and generate the venue booking details or Press (c) to cancel the Venue Booking and return to the University Venue Management Menu: " SaveBooking
  
    case "$SaveBooking" in
      s|S)
        # Save Booking
        echo "$PatronID:${PatronInfo[1]}:$RoomNo:$DateBooking:$TimeFrom:$TimeTo:$ReasonForBooking" >> booking.txt
        # Save as Receipt for filing purposes
        CurrentDate=$(date +'%m-%d-%Y')
        CurrentTime=$(date +'%I:%M %p')
        
        # Save Receipt ASCII file
        # The Date at the end is the date the receipt is created
        echo -e "\n\n\t\t\t\t\tVenue Booking Receipt
		\n\nPatron ID: $PatronID
  		\t\t\t\t\t\t\tPatron Name: ${PatronInfo[1]}
		\nRoom Number: $RoomNo
  		\nDate Booking: $DateBooking
		\nTime From: $TimeFrom
  		\t\t\t\t\t\t\tTime To: $TimeTo
		\nReason for Booking: $ReasonForBooking
  		\n\n\tThis is a computer generated receipt with no signature required.
		\n\n\t\t\t\tPrinted on $CurrentDate $CurrentTime\n\n" > "${PatronID}_${RoomNo}_${CurrentDate}"
        break
        ;;
      c|C)
        main_menu
        ;;
      *)
        echo "Invalid input. Please enter again."
        ;;
    esac
  
  done

  while true; do
    echo
    read -p "Booking saved successfully. Press (g) to generate receipt or (q) to exit to the University Venue Management Menu: " GenerateReceiptConfirmation
  
    case "$GenerateReceiptConfirmation" in
      g|G)
        ## Generate Receipt
        cat "${PatronID}_${RoomNo}_${CurrentDate}"
        
        echo "Press any key to go to the University Venue Management Menu." 
        read MenuRedirect
        main_menu
        ;;
      q|Q)
        main_menu
        ;;
      *)
        ;;
    esac
    
  done

}

# Main Menu
function main_menu() {
  while true; do
    echo
    echo "----------------------------------------"
    echo "|  _____ _   ___   _   _ __  __ _____  |"
    echo "| |_   _/_\ | _ \ | | | |  \/  |_   _| |"
    echo "|   | |/ _ \|   / | |_| | |\/| | | |   |"
    echo "|   |_/_/ \_\_|_\  \___/|_|  |_| |_|   |"
    echo "----------------------------------------"
    
    echo
    echo "University Venue Management Menu"
    echo 
    echo "A – Register New Patron"
    echo "B – Search Patron Details"
    echo "C – Add New Venue"
    echo "D – List Venue"
    echo "E – Book Venue"
    echo "Q – Exit from Program"
    echo
    read -p "Please select a choice: " MenuOption
    
    case "$MenuOption" in
      a|A) 
        register_patron
        ;;
      b|B) 
        search_patron
        ;;
      c|C) 
        add_venue
        ;;
      d|D)
        list_venue
        ;;
      e|E) 
        book_venue
        ;;
      q|Q) 
        echo
        echo 'Thank you for using the University Venue Management System! :)'
        exit 0
        ;;
      *)
        echo "Invalid choice. Please enter again"
        ;;
    esac
    
  done
}

main_menu #Function main_menu call