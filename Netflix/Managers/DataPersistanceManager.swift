//
//  DataPersistanceManager.swift
//  Netflix
//
//  Created by Zardasht on 8/20/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    
    private init() {}
    static let shared = DataPersistanceManager()
    
    enum databaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
        
    }
    
    func downloadTitleWith(_ model:Title, completion:@escaping (Result<Void,Error>) -> Void)  {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
   
        let context = appDelegate.persistentContainer.viewContext
            
        let item = TitleItem(context: context)
    
        item.original_title = model.original_title
        item.original_name  = model.original_name
        item.overview = model.overview
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success( () ))
        }
        catch {
            completion(.failure(databaseError.failedToSaveData))
            
        }
        
    }
    
    func fetchingTitlesFromDatabase(completion: @escaping(Result<[TitleItem],Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        }
        catch {
            completion(.failure(databaseError.failedToFetchData))
        }
        
    }
    
    func deleteTitleWith(model:TitleItem , completion: @escaping(Result<Void,Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) // asking databse manager to delete the certan object
        do {
            try context.save()
            completion(.success( () ))
        }
        catch {
            
            completion(.failure(databaseError.failedToDeleteData))
        }
    }
    
    
}
