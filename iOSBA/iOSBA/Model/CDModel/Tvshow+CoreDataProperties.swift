//
//  Tvshow+CoreDataProperties.swift
//  iOSBA
//
//  Created by Oswaldo Ferral on 20/07/23.
//
//

import Foundation
import CoreData


extension Tvshow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tvshow> {
        return NSFetchRequest<Tvshow>(entityName: "Tvshow")
    }

    @NSManaged public var favorite: Bool
    @NSManaged public var id: Int64
    @NSManaged public var imageMedium: String?
    @NSManaged public var imageOriginal: String?
    @NSManaged public var language: String?
    @NSManaged public var score: Float
    @NSManaged public var status: String?
    @NSManaged public var summary: String?
    @NSManaged public var imdb: String?
    @NSManaged public var type: String?
    @NSManaged public var url: String?
    @NSManaged public var name: String?

}
