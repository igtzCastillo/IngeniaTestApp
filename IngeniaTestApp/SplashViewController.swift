//
//  SplashViewController.swift
//  IngeniaTestApp
//
//  Created by Alejandro Aristi C on 25/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit
import CoreData

class SplashViewController: UIViewController {

    var managedContext: NSManagedObjectContext!
    
    override func loadView() {
        
        self.view = UIView.init(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.black
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    private func getInfoFromServer() {
        
        UtilityManager.sharedInstance.showLoader()
        
        ServerManager.sharedInstance.getAllTheGists(actionsToDoWhenSucceeded: { (arrayOfGists) in
            
            print(arrayOfGists)
            
            
            self.insert(arrayOfGists: arrayOfGists)
            let arrayOfGistsFromCoreData = self.getAllGists()
            
            UtilityManager.sharedInstance.hideLoader()
            
            let gistsList = GistListViewController.init(style: .plain, newArrayOfElements: arrayOfGistsFromCoreData)
            self.navigationController?.pushViewController(gistsList, animated: true)
            
            
        }, actionsToDoWhenFailed: {
            
            
            UtilityManager.sharedInstance.hideLoader()
            
        })
        
    }
    
    private func insert(arrayOfGists: Array<Gist>) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for gist in arrayOfGists {
            
            let newGist = NSEntityDescription.insertNewObject(forEntityName: "GistCD", into: context)
            newGist.setValue(gist.id, forKey: "id")
            newGist.setValue(gist.avatarURL, forKey: "avatarURL")
            newGist.setValue(gist.commentsURL, forKey: "commentsURL")
            newGist.setValue(gist.createdAt, forKey: "createdAt")
            newGist.setValue(gist.descriptionGist, forKey: "descriptionGist")
            newGist.setValue(gist.numberOfComments, forKey: "numberOfComments")
            newGist.setValue(gist.url, forKey: "url")
            newGist.setValue(gist.userLogin, forKey: "userLogin")
            
            let newFile = NSEntityDescription.insertNewObject(forEntityName: "FileCD", into: context)
            newFile.setValue(gist.file.name, forKey: "name")
            newFile.setValue(gist.file.language, forKey: "language")
            newFile.setValue(gist.file.rawURL, forKey: "rawURL")
            newFile.setValue(gist.file.size, forKey: "size")
            newFile.setValue(gist.file.type, forKey: "type")
            
            newGist.setValue(newFile, forKey: "hasOne")
            
            do {
                
                try context.save()
                print("Well done saved")
                
            } catch {
                
                
                
            }
            
        }

    }
    
    private func getAllGists() -> Array<GistCD> {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GistCD")
        request.returnsObjectsAsFaults = false
        
        var arrayOfGistCD = Array<GistCD>()
        
        do {
            
            arrayOfGistCD = try context.fetch(request) as! Array<GistCD>
            
//            if arrayOfGist.count > 0 {
//                
//                for gistCD in arrayOfGist {
//                    
//                    let newIdPrueba = gistCD.id!
//                    
//                    let newId = gistCD.value(forKey: "id") as? String != nil ? gistCD.value(forKey: "id") as! String : ""
//                    let newAvatarURL = gistCD.value(forKey: "avatarURL") as? String != nil ? gistCD.value(forKey: "avatarURL") as! String : ""
//                    let newCommentsURL = gistCD.value(forKey: "commentsURL") as? String != nil ? gistCD.value(forKey: "commentsURL") as! String : ""
//                    let newCreatedAt = gistCD.value(forKey: "createdAt") as? String != nil ? gistCD.value(forKey: "createdAt") as! String : ""
//                    let newDescriptionGist = gistCD.value(forKey: "descriptionGist") as? String != nil ? gistCD.value(forKey: "descriptionGist") as! String : ""
//                    let newNumberOfComments = gistCD.value(forKey: "numberOfComments") as? Int != nil ? gistCD.value(forKey: "numberOfComments") as! Int : 0
//                    let newURL = gistCD.value(forKey: "url") as? String != nil ? gistCD.value(forKey: "url") as? String : ""
//                    let newUserLogin = gistCD.value(forKey: "userLogin") as? String != nil ? gistCD.value(forKey: "userLogin") as? String : ""
//                    
//                    let newFile = gistCD.value(forKey: "hasOne") as! FileCD
//                    
//                    let
//            
//                    
//                }
//                
//            }
            
        } catch {
            
            
            
        }
     
        return arrayOfGistCD
        
    }
    
}
