//
//  DetailViewController.swift
//  Homework2
//
//  Created by Melanie Hendricks on 8/6/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // declare variables
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityDesc: UITextView!
    
    var name:String?
    var image:Data?
    var desc:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cityName.text = name
        self.cityDesc.text = desc
        
        // saved in CoreData as Data
        // need to convert to UIImage
        if image == nil{
            self.cityImage.image = #imageLiteral(resourceName: "placeholder")
        }else{
            let imageData: UIImage = UIImage(data: image!)!
            self.cityImage.image = imageData
        }
    }
}
