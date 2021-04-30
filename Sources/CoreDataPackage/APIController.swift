//
//  APIController.swift
//  LeagueMobileChallenge
//
//  Created by Kelvin Lau on 2019-01-14.
//  Copyright © 2019 Kelvin Lau. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

public enum RequestError : Error {
    case userTokenIsNill
    case requestFailed
    case noInternetConntion
    case emailAccountUnavailable
    case wrongPhoneNumberFormat
    case saveDataTransactionFailed
    case fetchDataTransactionFailed
}

public class APIController {
    public static let domain = "https://engineering.league.dev/challenge/api/"
    let loginAPI = domain + "login"
    let usersAPI = domain + "users"
    let postsAPI = domain + "posts"
    let albumsAPI = domain + "albums"
    let photosAPI = domain + "photos"
    
   public static let shared = APIController()
    
    fileprivate var userToken: String?
    
   public func fetchUserToken(userName: String, password: String, successHandler : @escaping () -> Void, failureHandler : @escaping (Error) -> Void) {
        guard let url = URL(string: loginAPI) else {
            return
        }
        let headers: HTTPHeaders = [
            .authorization(username: userName, password: password),
            .accept("application/json")
        ]
        
        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                if let content = value as? [AnyHashable : Any] {
                    self.userToken = content["api_key"] as? String
                }
                successHandler()
            case let .failure(error):
                failureHandler(error)
            }
        }
    }
    
   public func request(url: URL, successHandler : @escaping (Any) -> Void, failureHandler : @escaping (Error) -> Void) {
        guard let userToken = userToken else {
            failureHandler(RequestError.userTokenIsNill)
            return
        }
        let authHeader: HTTPHeaders = ["x-access-token" : userToken]
        
        AF.request(url, method: .get
                   , parameters: nil, encoding: URLEncoding.default, headers: authHeader).responseJSON { (response) in
                    switch response.result {
                    case .success:
                        successHandler(response.data!)
                    case .failure(let error):
                        failureHandler(error)
                    }
            }
        
    }
    
   public func checkInternetAvalability() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
   public func saveBatchInLocalStorage(_ entitiesData: [NSManagedObject],successHandler : @escaping ([NSManagedObject]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let managedContext  = ManagedContext.shared.persistentContainer.viewContext
        var createdEntities:[NSManagedObject] = [NSManagedObject]()

        for entityData in entitiesData {
            if let entityName = entityData.entity.name{
                let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedContext)
                let entityPropertyKey = Array(entityData.entity.attributesByName.keys)
                let propertiesDictionary = entityData.dictionaryWithValues(forKeys: entityPropertyKey)
                entity.setValuesForKeys(propertiesDictionary)
                createdEntities.append(entity)
            }else{
                failureHandler(RequestError.saveDataTransactionFailed)
                break
            }
            
        }

        do{
            try managedContext.save()
            successHandler(createdEntities)
            
        }catch let savingError{
            failureHandler(savingError)

        }
    }
    
}
