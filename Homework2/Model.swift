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
    
    
}
