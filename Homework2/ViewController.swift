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
    var index:IndexPath?
    
    // getting a handler to the CoreData managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var m:Model?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m = Model(context: managedObjectContext)
        let cities = m?.fetch()

        // create dictionary with section headers as a key and city object as a value
        m?.createCityDictionary()
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - TableView functions
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    // determine rows for each section
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // return number of rows in the section
           // get the section title
           let cityKey = self.sections[section]
           
           // use the section title to count how many cities are in that section
           if let count = m?.getSectionCount(key: cityKey){
               return count
           }else{
               return 0
           }
       }
    
    
    // create section heads
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // return heading for each section
        return self.sections[section]
    }
    
   
    
    // put data into each row based in the section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CityTableViewCell
        //cell.layer.borderWidth = 0.9
            
        // fetch key
        let cityKey = sections[indexPath.section]
        
        // if key + values exist, return City at specified index
        if let city = m?.getCityObjectForRow(key: cityKey, index: indexPath.row){
            
            // set City name
            cell.cityTitle.text = city.name!
            
            // picture saved as Data in CoreData
            // need to convert from Data to UIImage
            let imageData:UIImage = UIImage(data: city.picture!)!
            cell.cityImage.image = imageData
            cell.cityImage.isHidden = false
        }
           
        return cell
    }
    
    /*
    func tableView(tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
        }
    }
*/
    /*
    // returns the section index that the tableView should jump to when a user taps a particular index
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        //
        let temp = sections as NSArray
        return temp.index(of: title)
    }
  */
    
    // allows user to edit a row 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        self.cityTable.allowsSelectionDuringEditing = true
        return true
    }
 
    
    
    // make cells bigger
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    

    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cityTable.reloadRows(at: [indexPath], with: .fade)
    }
    
    
    
    
    // MARK: - Delete PickerView methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let count = self.m?.getCount()
        return count!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let city = self.m?.getCityObject(index: row)
        let title = city?.name
        return title
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // set typeValue to name of city
        let city = self.m?.getCityObject(index: row)
        self.typeValue = city?.name
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
            
            var countBefore = self.m?.getCount()
            print(countBefore)
            self.m?.deleteCity(name: self.typeValue!)
            
            print(self.cityTable.hasUncommittedUpdates)
            
            self.cityTable.reloadData()
            //self.updateView()
            var countAfter = self.m?.getCount()
            print(countAfter)
        }
        
        
        // delete all action
        let deleteAll = UIAlertAction(title: "Delete All", style: .default){
            action in
            
            self.m?.deleteAll()
            let count = self.m?.getCount()
           // self.updateView()
            self.cityTable.reloadData()
            print(count)
        }
        
        // add actions to Alert Controller object
        alert.addAction(deleteAction)
        alert.addAction(deleteAll)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // make visible
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Image Picker Controller Delegates + Helper functions
    
    // load info about image into info object
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        // dismiss view that shows camera or photo library
        picker.dismiss(animated: true, completion: nil)
        
        // create image object based on picture taken or photo selected
        selectedPhoto.image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        
        let beforeCount = self.m?.getCount()
        print(beforeCount)
        
        
        
        // call addCity function in Model
        self.m?.addCity(name: cityName, desc: cityDesc, photo: self.selectedPhoto.image!.jpegData(compressionQuality: 0.9)!)

        // reload TableView
        self.cityTable.reloadData()
        
        let totalCount = self.m?.getCount()
        
        print("cities saved: ", totalCount!)
        
    }
    
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String:Any]{
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String{
        return input.rawValue
    }
    
    
    
    
    // MARK: - Other functions
    
    // send data to Detail View using a segue when a table row is selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        let selectedIndex: IndexPath = self.cityTable.indexPath(for: sender as! UITableViewCell)!
        let cityKey = sections[selectedIndex.section]
        
        // get the city object for the selected row in the section
        let city = self.m?.getCityObjectForRow(key: cityKey, index: selectedIndex.row)
        
        
        // if segue identifier is "toDetailView"
        // pass selected city to DetailViewController
        if(segue.identifier == "toDetailView"){
            if let viewController:DetailViewController = segue.destination as? DetailViewController{
                viewController.name = city!.name
                viewController.desc = city!.desc
                viewController.image = city!.picture
            }
        }
    }
    
    
    
} // end of ViewController class

