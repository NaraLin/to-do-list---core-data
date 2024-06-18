//
//  ToDoListItem+CoreDataProperties.swift
//  to do list - core data
//
//  Created by 林靖芳 on 2024/6/17.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isHighlighted: Boolean?

}

extension ToDoListItem : Identifiable {

}
