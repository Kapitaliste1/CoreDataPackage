//
//  AddressRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//

import Foundation
import ObjectMapper
import CoreData

public class AddressRepository {
    
   public static let shared = AddressRepository()
    
   public func downloadAddress(jsonDictionnary :[String : Any],successHandler : @escaping ([Address]) -> Void, failureHandler : @escaping (Error) -> Void){
        if var addressJson =  jsonDictionnary["address"] as? [String: Any], let id = jsonDictionnary["id"] as? Int16{
            addressJson["userId"] = id
            var addressArray : [Address] = [Address]()
            addressArray = Mapper<Address>().mapArray(JSONArray:[addressJson])
            APIController.shared.saveBatchInLocalStorage(addressArray) { (savedData) in
                successHandler(addressArray)
            } failureHandler: { (error) in
                failureHandler(error)
            }
        }
    }
     
    
   public func selectAll(successHandler : @escaping ([Address]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(Address.fetchRequest()) as? [Address]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
    
   public func selectByUserId(userId : Int16,successHandler : @escaping (Address) -> Void, failureHandler : @escaping (Error) -> Void) {
        let fetchRequest = Address.fetchRequest()
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "userId == %d", userId)
        
        do {
            if let array = try managedContext.fetch(fetchRequest) as? [Address], let item = array.first{
                successHandler(item)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
        
    }
    
    
}
