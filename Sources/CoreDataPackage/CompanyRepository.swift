//
//  CompanyRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//

import Foundation
import ObjectMapper
import CoreData

public class CompanyRepository {
    
    public static let shared = CompanyRepository()
    
    public func downloadCompany(jsonDictionnary :[String : Any],successHandler : @escaping ([Company]) -> Void, failureHandler : @escaping (Error) -> Void){
    
        if var companyJson =  jsonDictionnary["company"] as? [String: Any], let id = jsonDictionnary["id"] as? Int16{
            companyJson["userId"] = id
            var companies : [Company] = [Company]()
            companies = Mapper<Company>().mapArray(JSONArray:[companyJson])
            APIController.shared.saveBatchInLocalStorage(companies) { (savedData) in
                successHandler(companies)
            } failureHandler: { (error) in
                failureHandler(error)
            }
        }
    }
     
    
    public func selectAll(successHandler : @escaping ([Company]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(Company.fetchRequest()) as? [Company]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
    
    public func selectByUserId(userId : Int16,successHandler : @escaping (Company) -> Void, failureHandler : @escaping (Error) -> Void) {
        let fetchRequest = Company.fetchRequest()
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "userId == %d", userId)
        
        do {
            if let array = try managedContext.fetch(fetchRequest) as? [Company], let item = array.first{
                successHandler(item)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
        
    }
    
    
}
