//
//  User+CoreDataClass.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//
//

import Foundation
import CoreData
import ObjectMapper

open class User: NSManagedObject, Mappable {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context!)
        super.init(entity: entity!, insertInto: context)
    }
    
    required convenience public init(map: Map) {
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
        self.init(context : managedContext)
        self.mapping(map: map)
        CompanyRepository.shared.downloadCompany(jsonDictionnary: map.JSON) { (_) in
            AddressRepository.shared.downloadAddress(jsonDictionnary: map.JSON) { (_) in
            } failureHandler: { (_) in}
        } failureHandler: { (_) in}

    }
    
    public func mapping(map: Map) {
        id   <- (map["id"])
        avatar   <- (map["avatar"])
        name   <- (map["name"])
        username   <- (map["username"])
        email   <- (map["email"])
        phone   <- (map["phone"])
        website   <- (map["website"])
    }
}
