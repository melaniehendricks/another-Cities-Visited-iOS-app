//
//  City+CoreDataClass.swift
//  Homework2
//
//  Created by Melanie Hendricks on 8/6/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import Foundation
import CoreData


public class City: NSManagedObject {

    
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var picture: Data?

    
}
