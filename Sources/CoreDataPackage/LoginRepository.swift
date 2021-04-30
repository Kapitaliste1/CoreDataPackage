//
//  LoginRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-05.
 
//

import Foundation
import ObjectMapper
import CoreData


public class LoginRepository {
    
    public static let shared = LoginRepository()
    
    public func login(username : String, password : String ,successHandler : @escaping () -> Void, failureHandler : @escaping (Error) -> Void){
        
        if APIController.shared.checkInternetAvalability(){
            APIController.shared.fetchUserToken(userName: username, password: password) {
                self.downloadContent {
                    successHandler()
                } failureHandler: { (error) in
                    failureHandler(error)
                }
            } failureHandler: { (error) in
                failureHandler(error)
            }
        }else{
            UserRepository.shared.selectAll { (userArray) in
                if userArray.count > 0 {
                    successHandler()
                }else{
                    failureHandler(RequestError.noInternetConntion)
                }
            } failureHandler: { (error) in
                failureHandler(error)
            }
        }
    }
    
    
   public func downloadContent(successHandler : @escaping () -> Void, failureHandler : @escaping (Error) -> Void){
 
    guard let url = ManagedContext.shared.persistentContainer.persistentStoreDescriptions.first?.url else { return }
        
    let persistentStoreCoordinator = ManagedContext.shared.persistentContainer.persistentStoreCoordinator
        
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            
            UserRepository.shared.downloadUser { (userArray) in
                PostRepository.shared.downloadPosts { (postsArray) in
                    AlbumRepository.shared.downloadAlbums { (albumArray) in
                        PhotoRepository.shared.downloadPhotos { (photoArray) in
                            successHandler()
                        } failureHandler: { (error) in
                            failureHandler(error)
                        }
                    } failureHandler: { (error) in
                        failureHandler(error)
                    }
                } failureHandler: { (error) in
                    failureHandler(error)
                }
            } failureHandler: { (error) in
                failureHandler(error)
            }
            
        } catch let error {
            failureHandler(error)
        }
        
    }
    
    
}



