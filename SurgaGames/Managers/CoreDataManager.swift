//
//  CoreDataManager.swift
//  SurgaGames
//
//  Created by Farhan Mazario on 19/05/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameDataModel")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unsolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    
    //doFavourite
    func createFavouriteGame(
        _ id: Int,
        _ name: String,
        _ desc: String,
        _ backgroundImg: Data,
        completion: @escaping() -> Void
    ){
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "GameDataModel", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKeyPath: "id")
                game.setValue(name, forKeyPath: "name")
                game.setValue(desc, forKeyPath: "desc")
                game.setValue(backgroundImg, forKeyPath: "backgroundImg")
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func getAllFavorite(completion: @escaping(_ favorites: [FavouriteModel]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameDataModel")
          do {
            let results = try taskContext.fetch(fetchRequest)
            var favorites: [FavouriteModel] = []
            for result in results {
              let favorite = FavouriteModel(
                id: result.value(forKeyPath: "id") as? Int64,
                name: result.value(forKeyPath: "name") as? String,
                desc: result.value(forKeyPath: "desc") as? String,
                backgroundImg: result.value(forKeyPath: "backgroundImg") as? Data
              )
              favorites.append(favorite)
            }
            completion(favorites)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        }
      }
    
    //function checkFavourite
    func checkGameData(_ id: Int, completion: @escaping(_ favorites: Bool) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameDataModel")
          fetchRequest.fetchLimit = 1
          fetchRequest.predicate = NSPredicate(format: "id == \(id)")
          do {
            if let _ = try taskContext.fetch(fetchRequest).first {
              completion(true)
            } else {
              completion(false)
            }
          } catch {
            print(error.localizedDescription)
          }
        }
    }
    
    //function deleteFavourite
    func deleteFavorite(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameDataModel")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            if batchDeleteResult.result != nil {
                completion()
                }
            }
        }
    }
    
    //function getMaxId
    func getMaxId(completion: @escaping(_ maxId: Int) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameDataModel")
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchLimit = 1
            do {
            let lastFavorite = try taskContext.fetch(fetchRequest)
            if let favorite = lastFavorite.first, let position = favorite.value(forKeyPath: "id") as? Int {
                completion(position)
            } else {
                completion(0)
            }
            } catch {
            print(error.localizedDescription)
            }
        }
    }
    
}
