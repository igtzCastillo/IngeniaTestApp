//
//  File.swift
//  IngeniaTestApp
//
//  Created by Alejandro Aristi C on 25/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import Foundation

class File {

    var name: String!
    var type: String!
    var language: String!
    var rawURL: String!
    var size: Int!
    
    init(newName: String, newType: String, newLanguage: String, newRawURL: String, newSize: Int) {
        
        name = newName
        type = newType
        language = newLanguage
        rawURL = newRawURL
        size = newSize
        
    }
    
}
