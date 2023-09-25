# ios_habit_tracker
My first take on a personal project - a habit tracker app for iOS
---

# Habit Tracker

## Habit class properties
- title
- status
- timesPerDay
- timesCompletedToday
- description/information
- completedCountTotal
- icon
- color
- weekDays

## Features


### General
[x] when a new day begins reset all habits' status to "Incomplete"
[ ] make a separate tab view for managing all habits (unaffected by the weekday)


### **HabitListView**:
[x] divide the finished and unfinished habits
[x] if the habit doesn't have a description center the habit title
[ ] add swiping functionality to complete habits
[x] show only habits active that specific week day
[x] show how many times a habit has to be swiped to be completed (ex. "0/2")
[x] show habit description under title
[ ] show habit icon to the left of the habit list element
[ ] add some UI designs using habit colour attribute (when incomplete the habit background colour is faded, when complete, the colour is vibrant)

### **AddHabitView**:
[x] button to add to list
[x] textfield to add habit descripiton
[x] textfield to add completion per day goal
[x] ability to prescribe a colour to added habit
[x] figure out how to make habits active only for certain days
[x] ability to define in which week day the habit should be active
[ ] grid view with buttons to pick an icon associated with the habit  


### **HabitDetailView**:
[x] habit title content
[x] button to complete habit
[x] button to edit habit
[x] show habit total completion count
[x] show habit completion count on that day
[x] show habit description
[ ] show habit colour
[ ] show habit week day information

### **EditHabitView**:
[x] change habit title
[x] change habit description
[x] change habit timesPerDay
[ ] change habit colour
[ ] change habit week day
[ ] change habit icon


