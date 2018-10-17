//
//  Photos+CoreDataClass.swift
//  CoreDataPhotos
//
//  Created by Liam Flaherty on 10/16/18.
//  Copyright © 2018 Liam Flaherty. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Photos)
public class Photos: NSManagedObject {
    
    var image: UIImage? {
        get {
            if let imageData = rawImage as Data? {
                return UIImage(data: imageData)!
            }
            else{
                print("Could not retrive image")
            }
          return nil
        }
        set {
            rawImage = NSData( data: (newValue)!.pngData()!)
        }
    }
    
    convenience init?(name: String?, info: String?, image: UIImage) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Photos.entity(), insertInto: managedContext)
        self.name = name
        self.information = info
        self.image = image
    }
    
     func update(name: String, info: String?, image: UIImage?) {
         self.name = name
         self.information = info
         self.image = image
     }


}
