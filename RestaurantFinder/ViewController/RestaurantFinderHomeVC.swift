//
//  RestaurantFinderHomeVC.swift
//  RestaurantFinder
//
//  Created by Sudhanshu on 12/15/17.
//  Copyright © 2017 Sudhanshu. All rights reserved.
//

import UIKit
import Alamofire

struct AppConstant {
    static let apiKey = "9b836250ab61d8ca479681edf7956f74"
}

class RestaurantFinderHomeVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mTableView: UITableView!
    var locationNameList = [String]()
    var restaurantArr = [Restaurant]()
    var entityId: Int?
    var searchName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getLocationIdFromSearch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLocationIdFromSearch (_ searchText: String) {
        
        
        let getLocationDetailsUrl = "https://developers.zomato.com/api/v2.1/locations?query=\(searchText)"
        
        let headers: HTTPHeaders = [
            "user-key": AppConstant.apiKey,
            "Accept": "application/json"
        ]
        
        Alamofire.request(getLocationDetailsUrl, method: .get, headers: headers)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling getLocationDetailsUrl")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get object as JSON from API")
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                
                if let responseData = json["location_suggestions"] as? [[String:Any]] {
                    let locationModel = LocationModel.getLocationModels(responseData)
                    if locationModel.count > 0, let entityId = locationModel[0].entity_id  {
                        self.entityId = entityId
                        self.getRestaurants()
                    }
                    
                } else{
                    print("Couldn't get location data")
                }
        }
    }
    
    
    func getRestaurants() {
        
        guard let entityId = self.entityId else {
            return
        }
        
        let getResturantsUrl = "https://developers.zomato.com/api/v2.1/search?entity_id=\(entityId)&entity_type=city&start=\(self.restaurantArr.count)&count=20"
        
        let headers: HTTPHeaders = [
            "user-key": AppConstant.apiKey,
            "Accept": "application/json"
        ]
        
        Alamofire.request(getResturantsUrl, method: .get, headers: headers)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling getLocationDetailsUrl")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get object as JSON from API")
                    print("Error: \(String(describing: response.result.error))")
                    return
                }
                
                if let restaurantsAPIModel  = RestaurantsAPIModel(dictionary: json) {
                    self.restaurantArr += restaurantsAPIModel.restaurantsInPlace
                    self.mTableView.reloadData()
                }
        }
    }
}

//MARK: UITableViewDataSource methods
extension RestaurantFinderHomeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let restaurantCell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.identifier, for: indexPath) as! RestaurantCell
        restaurantCell.configureCell(restaurantArr[indexPath.row])
        return restaurantCell
    }
}

//MARK: UITableViewDelegate methods
extension RestaurantFinderHomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

extension RestaurantFinderHomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.bounds.height) {
            self.getRestaurants()
        }
    }
    
}

extension RestaurantFinderHomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        restaurantArr.removeAll(keepingCapacity: false)
        getLocationIdFromSearch(searchBar.text ?? "")
        
    }
}

