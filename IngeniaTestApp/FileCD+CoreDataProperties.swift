//
//  FileCD+CoreDataProperties.swift
//  
//
//  Created by Alejandro Aristi C on 26/06/17.
//
//

import Foundation
import CoreData


extension FileCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FileCD> {
        return NSFetchRequest<FileCD>(entityName: "FileCD");
    }

    @NSManaged public var language: String?
    @NSManaged public var name: String?
    @NSManaged public var rawURL: String?
    @NSManaged public var size: Int64
    @NSManaged public var type: String?
    @NSManaged public var belongsTo: GistCD?

}
