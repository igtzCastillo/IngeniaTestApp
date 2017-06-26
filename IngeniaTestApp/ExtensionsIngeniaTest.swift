//
//  ExtensionsIngeniaTest.swift
//  IngeniaTestApp
//
//  Created by Alejandro Aristi C on 25/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func imageFromUrl(urlString: String) {
        
        var finalString = urlString.replacingOccurrences(of: "/", with: "")
        finalString = finalString.replacingOccurrences(of: ".", with: "")
        finalString = finalString.replacingOccurrences(of: "?", with: "")
        finalString = finalString.replacingOccurrences(of: "=", with: "")
        finalString = finalString.replacingOccurrences(of: ":", with: "")
        
        let destinationPath = UtilityManager.sharedInstance.kCache + "/" + finalString
        
        if FileManager.default.fileExists(atPath: destinationPath){
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                
                if urlString != "" {
                    
                    let image: UIImage = UIImage(contentsOfFile: destinationPath)!
                    
                    DispatchQueue.main.async {
                        
                        self.image = image
                        
                    }
                    
                }
                
            }
            
        }
            
        else {
            
            getImage(path: urlString, destinationPath: destinationPath)
            
        }
        
    }
    
    func getImage (path: String, destinationPath: String){
        
        let imageURL = NSURL(string:path)
        let request: NSURLRequest = NSURLRequest(url: imageURL! as URL)
        
        let downloadSession = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error == nil {
                // Convert the downloaded data into a UIImage object
                let finalImage = UIImage(data: data!)
                if finalImage != nil {
                    
                    do {
                        try FileManager.default.createDirectory(atPath: (destinationPath as NSString).deletingLastPathComponent, withIntermediateDirectories: true, attributes: nil)
                    } catch _ {}
                    
                    let finalURL = NSURL.init(string: destinationPath)
                    
                    do {
                        
                        try UIImagePNGRepresentation(finalImage!)?.write(to: finalURL as! URL, options: NSData.WritingOptions.atomic)
                        
                    } catch {
                        
                        print (error)
                        print("Error al guardar imagen")
                        
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.image = finalImage
                        
                    })
                    
                }
                
            }
            else {
                
                print( "Error: \(error!.localizedDescription)")
                
            }
            
        }
        
        downloadSession.resume()
        
    }
    
}

