//
//  ViewController.swift
//  Homework2
//
//  Created by Melanie Hendricks on 8/5/20.
//  Copyright © 2020 Melanie Hendricks. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate{


    // declare variables
    let sections = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                    "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var pickerView = UIPickerView()
    @IBOutlet weak var cityTable: UITableView!
    
    let selectedPhoto = UIImageView()
    var cityName:String = ""
    var cityDesc:String = ""
    var toDelete:City?
    var typeValue:String?
    
    
    
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
    
    
    // MARK: - Delete PickerView methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // let count = self.m?.getCount()
        // return count!
        return 1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // let city = self.m?.getCityObject(index: row)
        // let title = city?.name
        // return title
        return ""
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set typeValue to name of city
        // let city = self.m?.getCityObject(index: row)
        // typeValue = city?.name
    }
    
    
    // MARK: - Add City
    
    @IBAction func addCity(_ sender: Any) {
        
        // 2 text fields + UI ImagePicker
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        
        // CANCEL
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            action in
            
            let firstText = alert.textFields![0] as UITextField
            let secondText = alert.textFields![1] as UITextField
            
            if let x = firstText.text, let y = secondText.text{
                print(firstText.text)
                print(secondText.text)
                
                self.cityName = x
                self.cityDesc = y
            }
        }
        
        // TEXT FIELDS
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter the name of the city here"})
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter the city's description here"})
        
        // CAMERA
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            action in
            
            // check if there is a camera available for application
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.cityName = alert.textFields!.first!.text!
                self.cityDesc = alert.textFields!.last!.text!
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                
                // source is camera
                picker.sourceType = UIImagePickerController.SourceType.camera
                
                // photo mode (vs video mode)
                picker.cameraCaptureMode = .photo
                
                // can view full image
                picker.modalPresentationStyle = .fullScreen
                
                // load camera view
                self.present(picker, animated: true, completion: nil)
                
            }else{
                print("No camera")
            }
        }
        
        // PHOTO LIBRARY
        let libAction = UIAlertAction(title: "Photo Library", style: .default){
            action in
            self.cityName = alert.textFields!.first!.text!
            self.cityDesc = alert.textFields!.last!.text!
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            
            // source is photo library
            picker.sourceType = .photoLibrary
            
            // load available photo library UI
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            
            // style
            picker.modalPresentationStyle = .popover
            
            // load photo library
            self.present(picker, animated: true, completion: nil)
            
        }
        
    
        // add actions to Alert Controller object
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(libAction)
        
        self.present(alert, animated: true)
        
    }
    
    
    
    // MARK: - Delete City
    
    @IBAction func deleteCity(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete City", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        alert.isModalInPresentation = true
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        // delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .default){
            action in
            
            // var count = self.m?.getCount()
            // print(count)
            // self.m?.deleteCity(name: self.typeValue!)
            self.cityTable.reloadData()
            // print(count)
        }
        
        
        // delete all action
        let deleteAll = UIAlertAction(title: "Delete All", style: .default){
            action in
            
            // self.m?.deleteAll()
            // let count = self.m?.getCount()
            self.cityTable.reloadData()
            // print(count)
        }
        
        // add actions to Alert Controller object
        alert.addAction(deleteAction)
        alert.addAction(deleteAll)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // make visible
        self.present(alert, animated: true)
    }
    
    
    
    // MARK: - Other functions
    
    // send data to Detail View using a segue when a table row is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }
    
    
    
} // end of ViewController class

