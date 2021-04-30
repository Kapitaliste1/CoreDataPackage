//
//  PhotoRepository.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-05.
 
//

import Foundation
import ObjectMapper
import CoreData


public class PhotoRepository {
    
    public static let shared = PhotoRepository()
    
    public func downloadPhotos(successHandler : @escaping ([Photo]) -> Void, failureHandler : @escaping (Error) -> Void){
        var photos : [Photo] = [Photo]()
        if let url : URL = URL(string: APIController.shared.photosAPI), APIController.shared.checkInternetAvalability(){
            APIController.shared.request(url: url) { (data) in
                do {
                    if let jsonRawData = data as? Data{
                        let jsonParsed = try JSONSerialization.jsonObject(with: jsonRawData, options: .allowFragments) as! [[String : AnyObject]]
                        photos = Mapper<Photo>().mapArray(JSONArray:jsonParsed)
                        APIController.shared.saveBatchInLocalStorage(photos) { (savedData) in
                            successHandler(photos)
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
    
    
    public func selectAll(successHandler : @escaping ([Photo]) -> Void, failureHandler : @escaping (Error) -> Void) {
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
        
        do {
            if let array = try managedContext.fetch(Photo.fetchRequest()) as? [Photo]{
                successHandler(array)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
    }
    
    public func selectByAlbumId(albumId : Int16,successHandler : @escaping (Photo) -> Void, failureHandler : @escaping (Error) -> Void) {
        let fetchRequest = Photo.fetchRequest()
        let managedContext = ManagedContext.shared.persistentContainer.viewContext
 
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "albumId == %d", albumId)

         do {
            if let array = try managedContext.fetch(fetchRequest) as? [Photo], let item = array.first{
                successHandler(item)
            }else{
                failureHandler(RequestError.fetchDataTransactionFailed)
            }
        } catch let error {
            failureHandler(error)
        }
        
    }
     
}
