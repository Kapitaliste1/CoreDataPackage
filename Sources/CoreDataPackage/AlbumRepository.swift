//
//  AlbumRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-03.
 
//

import Foundation
import ObjectMapper
import CoreData

public class AlbumRepository {
    
   public static let shared = AlbumRepository()
    
   public func downloadAlbums(successHandler : @escaping ([Album]) -> Void, failureHandler : @escaping (Error) -> Void){
        var albums : [Album] = [Album]()
        if let url : URL = URL(string: APIController.shared.albumsAPI), APIController.shared.checkInternetAvalability(){
            APIController.shared.request(url: url) { (data) in
                do {
                    if let jsonRawData = data as? Data{
                        let jsonParsed = try JSONSerialization.jsonObject(with: jsonRawData, options: .allowFragments) as! [[String : AnyObject]]
                        albums = Mapper<Album>().mapArray(JSONArray:jsonParsed)
                        APIController.shared.saveBatchInLocalStorage(albums) { (savedData) in
                            successHandler(albums)
                        } failureHandler: { (error) in
                            failureHandler(error)
                        }
                        
                    }
                } catch let parseError {
                    failureHandler(parseError)
                }
            } failureHandler: { (error) in
                failureHandler(error)
            }
            
        }else{
            failureHandler(RequestError.noInternetConntion)
        }
    }
    
   public func selectAll(successHandler : @escaping ([Album]) -> Void, failureHandler : @escaping (Error) -> Void) {
    let managedContext = ManagedContext.shared.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(Album.fetchRequest()) as? [Album]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
}
