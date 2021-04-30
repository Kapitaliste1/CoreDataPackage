//
//  Address+CoreDataProperties.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//
//

import Foundation
import CoreData


extension Address {
    @NSManaged public var id: Int16
    @NSManaged public var userId: Int16
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var city: String?
    @NSManaged public var zipcode: String?
}
