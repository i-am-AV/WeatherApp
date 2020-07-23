//
//  City+CoreDataProperties.swift
//  
//
//  Created by  Alexander on 22.07.2020.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?
    @NSManaged public var temperature: Double

}
