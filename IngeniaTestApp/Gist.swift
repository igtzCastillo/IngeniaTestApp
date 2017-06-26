//
//  Gist.swift
//  IngeniaTestApp
//
//  Created by Israel Gutiérrez on 25/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import Foundation

class Gist {
    
    var id: String!
    var url: String!
    var file: File!
    var descriptionGist: String!
    var numberOfComments: Int!
    var commentsURL: String!
    var createdAt: String!
    var avatarURL: String!
    var userLogin: String!
    
    init(newId: String, newURL: String, newFile: File, newDescription: String, newNumberOfComments: Int, newCommentsURL: String, newAvatarURL: String, newUserLogin: String, newCreatedAt: String) {
        
        id = newId
        url = newURL
        file = newFile
        descriptionGist = newDescription
        numberOfComments = newNumberOfComments
        commentsURL = newCommentsURL
        createdAt = newCreatedAt
        avatarURL = newAvatarURL
        userLogin = newUserLogin
        
    }
    
}
