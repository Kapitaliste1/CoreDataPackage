//
//  Geolocation+CoreDataProperties.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//
//

import Foundation
import CoreData


extension Geolocation {

    @NSManaged public var id: Int16
    @NSManaged public var addressId: Int16
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double

}
