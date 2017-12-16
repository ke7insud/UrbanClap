//
//  RestaurantCell.swift
//  RestaurantFinder
//
//  Created by Sudhanshu on 12/15/17.
//  Copyright © 2017 Sudhanshu. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantCell: UITableViewCell {

    
    @IBOutlet weak var resImage: UIImageView!
    @IBOutlet weak var resName: UILabel!
    @IBOutlet weak var resCusine: UILabel!
    @IBOutlet weak var resLocation: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func configureCell(_ restaurant: Restaurant) {
        self.resName.text = restaurant.name?.trimmingCharacters(in: .whitespaces)
        self.resCusine.text = restaurant.cuisines
        if let location = restaurant.location, let localityVerbose = location.locality_verbose {
            self.resLocation.text = localityVerbose
        }
        self.resImage.sd_setImage(with: URL(string: restaurant.thumb ?? ""), placeholderImage:  UIImage(named: "default_restaurant"))
        
    }

}
