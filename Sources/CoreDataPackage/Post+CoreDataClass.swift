//
//  Post+CoreDataClass.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//
//

import Foundation
import CoreData
import ObjectMapper

open class Post: NSManagedObject, Mappable {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Post", in: managedContext)
        super.init(entity: entity!, insertInto: context)
    }
    
    required convenience public init(map: Map) {
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
        self.init(context : managedContext)
        self.mapping(map: map)
    }
    
    public func mapping(map: Map) {
        id   <- (map["id"])
        userId   <- (map["userId"])
        title   <- (map["title"])
        body   <- (map["body"])

    }
}
