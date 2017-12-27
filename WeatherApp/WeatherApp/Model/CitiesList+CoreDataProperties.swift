//
//  CitiesList+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//
//

import Foundation
import CoreData


extension CitiesList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CitiesList> {
        return NSFetchRequest<CitiesList>(entityName: "CitiesList")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var stateName: String?

}
