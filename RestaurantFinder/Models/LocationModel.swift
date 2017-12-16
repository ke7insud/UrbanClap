//
//  LocationModel.swift
//  RestaurantFinder
//
//  Created by Sudhanshu on 12/15/17.
//  Copyright © 2017 Sudhanshu. All rights reserved.
//

import UIKit

class LocationModel: NSObject {
    
    public var entity_type : String?
    public var entity_id : Int?
    public var title : String?
    public var latitude : Double?
    public var longitude : Double?
    public var city_id : Int?
    public var city_name : String?
    public var country_id : Int?
    public var country_name : String?
    
    
    
    public class func getLocationModels (_ locationArray: [[String: Any]]) ->  [LocationModel] {
        var locationModels = [LocationModel]()
        for location in locationArray {
            if let locationDict = LocationModel(dictionary: location) {
                locationModels.append(locationDict)
            }
        }
        return locationModels
    }
    
    required public init?(dictionary: [String: Any]) {
        
        self.entity_type = dictionary["entity_type"] as? String
        self.entity_id = dictionary["entity_id"] as? Int
        self.title = dictionary["title"] as? String
        self.latitude = dictionary["latitude"] as? Double
        self.longitude = dictionary["longitude"] as? Double
        self.city_id = dictionary["city_id"] as? Int
        self.city_name = dictionary["city_name"] as? String
        self.country_id = dictionary["country_id"] as? Int
        self.country_name = dictionary["country_name"] as? String
    }
    
    

}

