//
//  RestaurantsAPIModel.swift
//  RestaurantFinder
//
//  Created by Sudhanshu on 12/15/17.
//  Copyright © 2017 Sudhanshu. All rights reserved.
//

import UIKit

class RestaurantsAPIModel: NSObject {
    public var restaurantsInPlace = [Restaurant]()
    
    required public init?(dictionary: [String: Any]) {
        if let dict = dictionary["restaurants"] as? [[String: Any]] {
            restaurantsInPlace = RestaurantsAPIModel.getRestaurants(dict)
            
        }
    }
    
    public class func getRestaurants(_ restaurantArray: [[String: Any]]) -> [Restaurant]
    {
        var restaurants = [Restaurant]()
        for restaurant in restaurantArray {
            if let restDict = restaurant["restaurant"] as? [String: Any] {
                if let restaurantDetail = Restaurant(dictionary: restDict) {
                    restaurants.append(restaurantDetail)
                }
            }
        }
        return restaurants
    }
}

class Restaurant: NSObject {
    public var name : String?
    public var location : Location?
    public var cuisines : String?
    public var thumb : String?
    
    required public init?(dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        if (dictionary["location"] != nil) {
            location = Location(dictionary: dictionary["location"] as! NSDictionary)
        }
        cuisines = dictionary["cuisines"] as? String
        thumb = dictionary["thumb"] as? String
    }
}

class Location: NSObject {
    public var locality_verbose : String?
    
    required public init?(dictionary: NSDictionary) {
        self.locality_verbose = dictionary["locality_verbose"] as? String
    }
}

