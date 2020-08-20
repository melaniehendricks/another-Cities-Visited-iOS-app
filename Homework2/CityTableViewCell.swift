//
//  CityTableViewCell.swift
//  Homework2
//
//  Created by Melanie Hendricks on 8/6/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    // declare variables
    @IBOutlet weak var cityTitle: UILabel!
    @IBOutlet weak var cityImage: UIImageView!{
        didSet{
            //cityImage.layer.cornerRadius = cityImage.bounds.height / 4
            cityImage.frame = CGRect(x: 20, y: -15, width: 100, height: 100)
            cityImage.clipsToBounds = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
