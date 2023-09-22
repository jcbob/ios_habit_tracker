//
//  Habit+CoreDataProperties.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 22/09/2023.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var completedCountTotal: Int64
    @NSManaged public var icon: Int64
    @NSManaged public var information: String?
    @NSManaged public var status: String?
    @NSManaged public var timesCompletedToday: Int64
    @NSManaged public var timesPerDay: Int64
    @NSManaged public var title: String?

}

extension Habit : Identifiable {

}
