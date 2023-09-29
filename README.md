# Habit Tracker
---
My first take on a personal project - a habit tracker app for iOS

## Habit class properties
- title: String
- status: String
- timesPerDay: Int
- timesCompletedToday: Int
- description/information: String
- completedCountTotal: Int
- icon: Int64
- color: String
- weekDays: [String]
- userOrder: Int64


## Features

### Future plans:
- [ ] add a posibility to group habits into sections using Form()?
- [ ] make the listed habits using ScrollView{} for more customization and what not
- [ ] add graphs to see habit progress
- [ ] add calendar functionality to see how many habits were done on a certain day of the week/month/year
- [ ] add a streak property to help "keep up the good work..."
- [ ] use the SF Symbols library rather than the one you used

### Stuff to do:
- [x] implement list re-ordering into habit manager view only
- [x] implement the habit icon into all habit views:
   - [x] detail view
   - [x] edit view
- [x] create some sort of grid view (ZStack or newView) in AddHabitView for picking out an icon
 implement all the possible habit property changes in EditHabitView


### General:
- [x] when a new day begins reset all habits' status to "Incomplete"
- [x] make a separate tab view for managing all habits (unaffected by the weekday)


### **Habit List View**:
- [x] divide the finished and unfinished habits
- [x] if the habit doesn't have a description center the habit title
- [x] show only habits active that specific week day
- [x]  show how many times a habit has to be swiped to be completed (ex. "0/2")
- [x] show habit description under title
- [x] add some UI designs using habit colour attribute (when incomplete the habit background colour is faded, when complete, the colour is vibrant)
- [x] add swiping functionality to complete habits
- [x]  show habit icon to the left of the habit list element

### **Add Habit View**:
- [x] button to add to list
- [x] textfield to add habit descripiton
- [x] textfield to add completion per day goal
- [x] ability to prescribe a colour to added habit
- [x] figure out how to make habits active only for certain days
- [x] ability to define in which week day the habit should be active
- [x] grid view with buttons to pick an icon associated with the habit  


### **Habit Detail View**:
- [x] habit title content
- [x] button to complete habit
- [x] button to edit habit
- [x] show habit total completion count
- [x] show habit completion count on that day
- [x] show habit description
- [x] show habit colour
- [x] show habit week day information

### **Edit Habit View**:
- [x] change habit title
- [x] change habit description
- [x] change habit timesPerDay
- [x] change habit colour
- [x] change habit week day
- [x] change habit icon

### **Habit Manager View**:
- [x] create the view
- [x] make a button instead of a navigationLink to edit the habit

## Problems & Bugs
---

### Unverified

### Verified
- [ ] Edit button in Habit Manager doesn't work after adding a new habit

### Fixed
