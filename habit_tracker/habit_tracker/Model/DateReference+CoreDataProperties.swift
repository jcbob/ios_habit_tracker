//
//  DateReference+CoreDataProperties.swift
//  habit_tracker
//
//  Created by Wojciech Wolski on 22/09/2023.
//
//

import Foundation
import CoreData


extension DateReference {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateReference> {
        return NSFetchRequest<DateReference>(entityName: "DateReference")
    }

    @NSManaged public var date: Date?

}

extension DateReference : Identifiable {

}
