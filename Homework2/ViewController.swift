//
//  ViewController.swift
//  Homework2
//
//  Created by Melanie Hendricks on 8/5/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // declare variables
    let sections = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var pickerView = UIPickerView()
    @IBOutlet weak var cityTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // MARK: - TableView functions
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // create section heads
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    // determine rows for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // model.getCount()
        
        return 1
    }
    
    // put data into each row based on the section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        
        //
        // cell.textLabel?.text = self...
        return cell
    }
    

    // returns the section index that the tableView should jump to when a user taps a particular index
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 0
    }
    
    
    // allows user to edit a row 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // make cells bigger
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cityTable.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    
    // MARK: - Add City
    
    @IBAction func addCity(_ sender: Any) {
        
        // 2 text fields + UI ImagePicker
        
    }
    
    
    
    
    
    // MARK: - Delete City
    
    @IBAction func deleteCity(_ sender: Any) {
        
        // UI PickerView
        
        
    }
    
    
    
    // MARK: - Other functions
    
    // send data to Detail View using a segue when a table row is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }
    
    
    
} // end of ViewController class

