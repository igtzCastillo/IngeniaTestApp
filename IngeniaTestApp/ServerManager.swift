//
//  ServerManager.swift
//  IngeniaTestApp
//
//  Created by Alejandro Aristi C on 25/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager: NSObject {
    
    static let sharedInstance = ServerManager()
    
    static let developmentServer = ""
    static let productionServer  = "https://api.github.com"
    let typeOfServer = productionServer
    
    func getAllTheGists(actionsToDoWhenSucceeded: @escaping (_ arrayOfGists: Array<Gist>) -> Void, actionsToDoWhenFailed: @escaping () -> Void ) {
        
        let urlToRequest = "\(typeOfServer)/gists/public?client_id=92530193b47a7b1d8e80&client_secret=c395e12f750f494db26b26a5971307f402d1e16c"
        
            var requestConnection = URLRequest.init(url: NSURL.init(string: urlToRequest)! as URL)
            requestConnection.httpMethod = "GET"
        
        
            Alamofire.request(requestConnection)
                .validate(statusCode: 200..<400)
                .responseJSON{ response in
                    if response.response?.statusCode == 200 {
                            
                        do {
                                
                            var arrayOfGist: Array<Gist> = Array<Gist>()

                            let rawArrayOfGists = try JSONSerialization.jsonObject(with: response.data!, options: []) as! Array<[String: AnyObject]>
                            
//                            print(rawArrayOfGists)
                            
                            for rawGist in rawArrayOfGists {
                                
                                let newId = rawGist["id"] as? String != nil ? rawGist["id"] as! String : ""
                                let newURL = rawGist["url"] as? String != nil ? rawGist["url"] as! String : ""
                                let newDescription = rawGist["description"] as? String != nil ? rawGist["description"] as! String : ""
                                let newNumberOfComments = rawGist["comments"] as? Int != nil ? rawGist["comments"] as! Int : 0
                                let newURLComments = rawGist["comments_url"] as? String != nil ? rawGist["comments_url"] as! String : ""
                                let newCreatedAt = rawGist["created_at"] as? String != nil ? rawGist["created_at"] as! String : ""
                                let newAvatarURL = ""
                                let newUserLogin = ""
                                
                                let rawFile = rawGist["files"] as? [String: AnyObject] != nil ? rawGist["files"] as! [String: AnyObject] : [String: AnyObject]()
                                let fileDictionary = rawFile["\(newDescription).md"] as? [String: AnyObject] != nil ? rawFile["\(newDescription).md"] as! [String: AnyObject] : [String: AnyObject]()
                                
                                let newFile = self.getFilesFromDictionary(rawFileDictionary: fileDictionary)
                                
                                let newGist = Gist.init(newId: newId, newURL: newURL, newFile: newFile, newDescription: newDescription, newNumberOfComments: newNumberOfComments, newCommentsURL: newURLComments, newAvatarURL: newAvatarURL, newUserLogin: newUserLogin, newCreatedAt: newCreatedAt)
                                
                                print(newGist)
                                
                                arrayOfGist.append(newGist)
                                
                            }
                            
                            print("There area: \(arrayOfGist.count) gists")
                            
                            self.getAllAvatars(arrayOfGists: arrayOfGist, index: 0, numberOfCorrectRequests: 0) {
                                
                                actionsToDoWhenSucceeded(arrayOfGist)
                                
                            }
                                
                        } catch(_) {
                                
                            let alertController = UIAlertController(title: "ERROR",
                                                                    message: "Error de conexión con el servidor, favor de intentar más tarde",
                                                                    preferredStyle: UIAlertControllerStyle.alert)
                                
                            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                    
                            actionsToDoWhenFailed()
                                    
                        }
                            
                        alertController.addAction(cancelAction)
                                
                        let actualController = UtilityManager.sharedInstance.currentViewController()
                        actualController.present(alertController, animated: true, completion: nil)
                                
                    }
                        
                } else {
                        
                    let alertController = UIAlertController(title: "ERROR",
                                                            message: "Error de conexión con el servidor, favor de intentar más tarde",
                                                            preferredStyle: UIAlertControllerStyle.alert)
                        
                    let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                            
                        actionsToDoWhenFailed()
                            
                    }
                        
                    alertController.addAction(cancelAction)
                        
                    let actualController = UtilityManager.sharedInstance.currentViewController()
                    actualController.present(alertController, animated: true, completion: nil)
                        
                }
                
            }

    }
    
    private func getAllAvatars(arrayOfGists: Array<Gist>, index: Int, numberOfCorrectRequests: Int, actionsToDoWhenSucceeded: @escaping () -> Void ) {
        
        if index < 2 {  //arrayOfGists.count {  CHANGE THIS AT THE EEEEEEENNNDDDDDDDD
    
            let urlToRequest = arrayOfGists[index].url + "?client_id=92530193b47a7b1d8e80&client_secret=c395e12f750f494db26b26a5971307f402d1e16c"
            var requestConnection = URLRequest.init(url: NSURL.init(string: urlToRequest)! as URL)
            requestConnection.httpMethod = "GET"
            
            Alamofire.request(requestConnection)
                .validate(statusCode: 200..<400)
                .responseJSON{ response in
                    if response.response?.statusCode == 200 {
                        
                        do {
                            
                            let gistUser = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String: AnyObject]
                            
                            let history = gistUser["history"] as? Array<[String: AnyObject]> != nil ? gistUser["history"] as! Array<[String: AnyObject]> : Array<[String: AnyObject]>()
                            
                            var userInfo: [String: AnyObject] = [String: AnyObject]()
                            var avatarURL: String = ""
                            var userLogin: String = ""
                            
                            if history.count > 0 {
                                
                                userInfo = history[0]["user"] as? [String: AnyObject] != nil ? history[0]["user"] as! [String: AnyObject] : [String: AnyObject]()
                                
                                avatarURL = userInfo["avatar_url"] as? String != nil ? userInfo["avatar_url"] as! String : ""
                                
                                userLogin = userInfo["login"] as? String != nil ? userInfo["login"] as! String : ""
                            
                            }
                            
                            arrayOfGists[index].avatarURL = avatarURL
                            arrayOfGists[index].userLogin = userLogin
                            
                            print("Peticion de avatar número: \(index)")
                            
                            self.getAllAvatars(arrayOfGists: arrayOfGists, index: index + 1, numberOfCorrectRequests: numberOfCorrectRequests + 1, actionsToDoWhenSucceeded: actionsToDoWhenSucceeded)
                            
                            
                        } catch(_) {
                            
                            let alertController = UIAlertController(title: "ERROR",
                                                                    message: "Error de conexión con el servidor, favor de intentar más tarde",
                                                                    preferredStyle: UIAlertControllerStyle.alert)
                            
                            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                
                                return
                                
                            }
                            
                            alertController.addAction(cancelAction)
                            
                            let actualController = UtilityManager.sharedInstance.currentViewController()
                            actualController.present(alertController, animated: true, completion: nil)
                            
                        }
                        
                    }
                    
            }
            
        } else
        
        if index == 2 && numberOfCorrectRequests == 2 {         //  (index == arrayOfGists.count - 1) && (numberOfCorrectRequests == arrayOfGists.count - 1) {
                
            actionsToDoWhenSucceeded()
            
            return
                
        } else {
            
            let alertController = UIAlertController(title: "ERROR",
                                                    message: "Error de conexión con el servidor, favor de intentar más tarde",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                
                return
                
            }
            
            alertController.addAction(cancelAction)
            
            let actualController = UtilityManager.sharedInstance.currentViewController()
            actualController.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    private func getFilesFromDictionary(rawFileDictionary: [String: AnyObject]) -> File{

        let newFileName = rawFileDictionary["filename"] as? String != nil ? rawFileDictionary["filename"] as! String : ""
        let newType = rawFileDictionary["type"] as? String != nil ? rawFileDictionary["type"] as! String : ""
        let newLanguage = rawFileDictionary["language"] as? String != nil ? rawFileDictionary["language"] as! String : ""
        let newRawURL = rawFileDictionary["raw_url"] as? String != nil ? rawFileDictionary["raw_url"] as! String : ""
        let newSize = rawFileDictionary["size"] as? Int != nil ? rawFileDictionary["size"] as! Int : 0
            
        return File.init(newName: newFileName, newType: newType, newLanguage: newLanguage, newRawURL: newRawURL, newSize: newSize)
         
    }
    
    func getFileInfo(url: String, actionsToDoWhenSucceeded: @escaping (_ htmlInfo: String) -> Void, actionsToDoWhenFailed: @escaping () -> Void ) {
        
        let urlToRequest = url
        
        var requestConnection = URLRequest.init(url: NSURL.init(string: urlToRequest)! as URL)
        requestConnection.httpMethod = "GET"
        
        
        Alamofire.request(requestConnection)
            .validate(statusCode: 200..<400)
            .responseJSON{ response in
                if response.response?.statusCode == 200 {
                    
                    let htmlString = String(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                        
                    actionsToDoWhenSucceeded(htmlString)

                } else {
                    
                    let alertController = UIAlertController(title: "ERROR",
                                                            message: "Error de conexión con el servidor, favor de intentar más tarde",
                                                            preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                        actionsToDoWhenFailed()
                        
                    }
                    
                    alertController.addAction(cancelAction)
                    
                    let actualController = UtilityManager.sharedInstance.currentViewController()
                    actualController.present(alertController, animated: true, completion: nil)
                    
                }
                
        }
        
    }
    
    
}


