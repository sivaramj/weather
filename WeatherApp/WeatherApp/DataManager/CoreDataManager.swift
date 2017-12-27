//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Core Data stack
    private init() {
        if checkForCitiesDataLoad() {
            self.updateCities()
        }
    }
    static let sharedInstance = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: Cities Entity Operation
    
    /// Check if database loaded with data
    /// If Yes do nothing
    /// If No load all the data from the json
    func checkForCitiesDataLoad() -> Bool{
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CitiesList.self))
        fetchRequest.fetchLimit = 1
        do {
            if (try context.count(for: fetchRequest) == 0) { return true }
            return false
        }
        catch(_) {
            return false
        }
    }
    
    
    /// Loads the cities.json data to "citiesList" Entity
    func updateCities() {
        do {
            let data = try Data(contentsOf: Bundle.main.url(forResource: constant.citiesFileName, withExtension: constant.citiesFileType)!)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]] {
                _ = json.map{ self.addCities(value: $0)}
                self.saveContext()
            }
        }
        catch(_) {
            print("Couldn't load the data")
        }
    }
    
    /// Inserting values to "citiesList" table
    func addCities(value: [String: Any]) {
        let context = self.persistentContainer.viewContext
        if let object: CitiesList = NSEntityDescription.insertNewObject(forEntityName: String(describing: CitiesList.self), into: context) as? CitiesList {
            object.cityName = value["city"] as? String
            object.stateName = value["state"] as? String
        }
    }
    
}
