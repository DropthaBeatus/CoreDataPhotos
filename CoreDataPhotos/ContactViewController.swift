//
//  ContactViewController.swift
//  CoreDataPhotos
//
//  Created by Liam Flaherty on 10/16/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var contactData : Photos?
    
    var imagePic : UIImage?
    var imagePath : String?
    var imageName : String?
    
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contactData = contactData{
            imageName = contactData.name
            imagePath = contactData.information
            contactInfo.text = imagePath
            imagePic = contactData.image
            contactImage.image = imagePic
            contactName.text = imageName
        }

    }
    
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactImage: UIImageView!

    @IBOutlet weak var contactInfo: UITextView!
    
    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            Alert(alertTitle: "Feature Not Available", "can't open photo library")
            return
        }
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func Alert(alertTitle: String,_ alertMessage : String){
        let alertController = UIAlertController(title: alertTitle, message:
            alertMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            Alert(alertTitle: "Error", "Could not open Image")
            return
        }
        
        contactImage.image = image
        
        defer {
            picker.dismiss(animated: true)
        }
        
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
    }
    
    func setCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            Alert(alertTitle:"Error" ,"Camera not supported by this device")
            return
        }
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        //sends image to image picker
        present(imagePicker, animated: true)
    }

 
    @IBAction func takePhoto(_ sender: Any) {
        setCamera()
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        
        if(contactImage.image == nil){
            Alert(alertTitle: "No Image", "Please insert an image in the contact")
            return
        }
        else if(contactName.text == ""){
            Alert(alertTitle: "No Name", "Please insert Text in the contact name")
            return
        }
        else{
            imagePic = contactImage.image
            imagePath = contactInfo.text
            imageName = contactName.text
            
            if contactData == nil {
                contactData = Photos(name: imageName, info: imagePath, image: imagePic!)
            }
            else{
                contactData?.update(name: imageName!, info: imagePath, image: imagePic!)
            }
            if let image = contactData {
                do {
                    let managedContext = image.managedObjectContext
                    try managedContext?.save()
                } catch {
                    Alert(alertTitle: "Error", "The Photo could not be saved.")
                }
            } else {
                Alert(alertTitle: "Error", "The Photo could not be created.")
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func OpenImage(_ sender: Any) {
        openPhotoLibrary()
    }
}
