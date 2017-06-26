//
//  GistCD+CoreDataProperties.swift
//  
//
//  Created by Israel Gutiérrez on 26/06/17.
//
//

import Foundation
import CoreData


extension GistCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GistCD> {
        return NSFetchRequest<GistCD>(entityName: "GistCD");
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var commentsURL: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var descriptionGist: String?
    @NSManaged public var id: String?
    @NSManaged public var numberOfComments: Int64
    @NSManaged public var url: String?
    @NSManaged public var userLogin: String?
    @NSManaged public var hasOne: FileCD?

}
