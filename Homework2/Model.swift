//
//  Model.swift
//  Homework2
//
//  Created by Melanie Hendricks on 8/6/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import Foundation
import CoreData
public class Model{
    
    // create
    let managedObjectContext: NSManagedObjectContext?
    
    init(context: NSManagedObjectContext){
        
        // getting a handler to the CoreData managed object context
        managedObjectContext = context
    }
    
    
    // MARK: - ADD CITY
    func addCity(name:String, desc:String, photo:Data){
        
        // get a handler to the City entity through the managed object context
        let ent = NSEntityDescription.entity(forEntityName: "City", in: self.managedObjectContext!)
        
        // create a City object instance to add
        let city = City(entity: ent!, insertInto: managedObjectContext)
        
        // add data to each field in entity
        city.name = name
        city.desc = desc
        city.picture = photo
        
        // save new entity
        do{
            try managedObjectContext!.save()
            print("City saved")
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    
    
    // MARK: - QUERY
    func query(name:String) -> NSManagedObject{
        
        // search for correct object
        var match: NSManagedObject?
        
        // get a handler to the City entity
        let ent = NSEntityDescription.entity(forEntityName: "City", in: managedObjectContext!)
        
        // create fetch request
        let request:NSFetchRequest<City> = City.fetchRequest() as! NSFetchRequest<City>
        
        // associate the request with city handler
        request.entity = ent
        
        // build search request predicate (query)
        let pred = NSPredicate(format: "(name == %@", name)
        request.predicate = pred
        
        // perform the query and process the query results
        do{
            var results = try managedObjectContext!.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            
            if results.count > 0{
                match = results[0] as! NSManagedObject
            }else{}
        } catch let error{
            print(error.localizedDescription)
        }
        return match!
    }
    
    
    
    
    // MARK: - FETCH ALL OBJECTS
    func fetch() -> [City]{
        let fetchRequest = NSFetchRequest<City>(entityName: "City")
        var records:[City] = []
        do{
            records = try managedObjectContext!.fetch(fetchRequest)
        }catch{
            print(error)
        }
        return records
    }
    
    
    
    
    // MARK: - GET CITY OBJECT
    func getCityObject(index:Int) -> City{
        var cities = fetch()
        let target = cities[index]
        return target
    }
    
    
    // MARK: - FETCH CITY + DELETE CITY
    func deleteCity(name:String)-> Int{
        let city = name
        let match:NSManagedObject = query(name: city)
        managedObjectContext?.delete(match)
        return 0
    }
        
    
    
    // MARK: - DELETE ALL CITIES
    func deleteAll(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        
        // performs batch delete
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try managedObjectContext!.execute(deleteRequest)
            try managedObjectContext!.save()
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    
    
    // MARK: - GET CITY COUNT
    func getCount() -> Int{
        var iCount:Int? = -1
        
        // create fetch request
        let cityFetchRequest = NSFetchRequest<NSNumber>(entityName: "City")
        
        // define result type
        cityFetchRequest.resultType = .countResultType
        do{
            // execute fetch request
            let counts:[NSNumber]! = try managedObjectContext?.fetch(cityFetchRequest)
            for count in counts{
                iCount = (count != nil) ? Int(count) : nil
                return iCount!
            }
        }
        catch let error{
            print("Could not fetch \(error)")
        }
        return iCount!
    }
    
    
}
