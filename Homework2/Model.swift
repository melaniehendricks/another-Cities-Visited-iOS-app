//
//  Model.swift
//  Homework2
//
//  Created by Melanie Hendricks on 8/6/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import Foundation
import CoreData
class Model{
    
    let managedObjectContext: NSManagedObjectContext?
    var cityList = [String:[City]]()
    
    init(context: NSManagedObjectContext){
        
        // getting a handler to the CoreData managed object context
        managedObjectContext = context
    }
    
    
    // MARK: - TableView helper functions
    
    func createCityDictionary()
    {
        
        // fetch
        let records = fetch()
        
        for City in records{
            
            // extract first letter as a string for the key
            let city = City.name!
            let cityKey = getCityKey(name: city)
            
            // if cityList[cityKey] returns a value (cityKey already exists),
            // assign it to cityObjects and group City with other cities
            if var cityObjects = cityList[cityKey]{
                cityObjects.append(City)
                
                // then all cities have same key (first letter)
                cityList[cityKey] = cityObjects
                
                print(cityList[cityKey])
                
                // otherwise, create a new key-value pair with first letter & City
            }else{
                cityList[cityKey] = [City]
                print(cityList[cityKey])
            }
        }
    }
    
    
    // count the number of values (Cities) for the given key
    func getSectionCount(key: String) -> Int?
    {
        return cityList[key]?.count
    }
    
    
    func getCityObjectForRow(key: String, index: Int) -> City?
    {
        // if there are 1+ cities for a letter/key,
        // assign them to cityValues
        if let cityValues = cityList[key]{
            
            // return city at specified index 
            return cityValues[index]
        }else{
            return nil
        }
    }
    
    // MARK: - GET CITY KEY
    func getCityKey(name:String) -> String{
        let endIndex = name.index((name.startIndex), offsetBy: 1)
        let cityKey = String(name[(..<endIndex)])
        return cityKey
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
        
        // get key
        let key = getCityKey(name: name)
        
        // insert into cityList for getSectionCount to reference
        if var cityObjects = cityList[key]{
        cityObjects.append(city)
        
        // then all cities have same key (first letter)
        cityList[key] = cityObjects
        
            print(cityList[key])
        }else{
            cityList[key] = [city]
            print(cityList[key])
        }
        
        
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
        let pred = NSPredicate(format: "(name == %@)", name)
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
        
        // delete City in CoreData
        let city = name
        let match:NSManagedObject = query(name: city)
        managedObjectContext?.delete(match)
        
        // get key
        let key = self.getCityKey(name: name)
        var index:Int = 0
        
        // delete City in cityList for TableView functions to reference
        if var cityArrayAtKey = cityList[key]{
            for city in cityArrayAtKey{
                if city.name! == name{
                    cityList[key]!.remove(at: index)
                    print(cityList[key])
                    break
                }else{
                    index += 1
                }
            }
        }
        
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
            cityList.removeAll()
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
