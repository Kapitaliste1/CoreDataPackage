//
//  Company+CoreDataProperties.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//
//

import Foundation
import CoreData


extension Company {
 
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var bs: String?
    @NSManaged public var userId: Int16

}
