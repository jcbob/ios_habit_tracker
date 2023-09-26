# Habit Tracker
My first take on a personal project - a habit tracker app for iOS
---

## Habit class properties
- title: String
- status: String
- timesPerDay: Int
- timesCompletedToday: Int
- description/information: String
- completedCountTotal: Int
- icon: ?
- color: String
- weekDays: [String]


## Features

### Stuff to do:
[ ] create some sort of grid view (ZStack or newView) in AddHabitView for picking out an icon
[ ] implement all the possible habit property changes in EditHabitView


### General:
[x] when a new day begins reset all habits' status to "Incomplete"
[x] make a separate tab view for managing all habits (unaffected by the weekday)


### **Habit List View**:
[x] divide the finished and unfinished habits
[x] if the habit doesn't have a description center the habit title
[x] show only habits active that specific week day
[x] show how many times a habit has to be swiped to be completed (ex. "0/2")
[x] show habit description under title
[ ] add swiping functionality to complete habits
[ ] show habit icon to the left of the habit list element
[ ] add some UI designs using habit colour attribute (when incomplete the habit background colour is faded, when complete, the colour is vibrant)

### **Add Habit View**:
[x] button to add to list
[x] textfield to add habit descripiton
[x] textfield to add completion per day goal
[x] ability to prescribe a colour to added habit
[x] figure out how to make habits active only for certain days
[x] ability to define in which week day the habit should be active
[ ] grid view with buttons to pick an icon associated with the habit  


### **Habit Detail View**:
[x] habit title content
[x] button to complete habit
[x] button to edit habit
[x] show habit total completion count
[x] show habit completion count on that day
[x] show habit description
[ ] show habit colour
[ ] show habit week day information

### **Edit Habit View**:
[x] change habit title
[x] change habit description
[x] change habit timesPerDay
[x] change habit colour
[x] change habit week day
[x] change habit icon

### **Habit Manager View**:
[x] create the view
[x] make a button instead of a navigationLink to edit the habit

