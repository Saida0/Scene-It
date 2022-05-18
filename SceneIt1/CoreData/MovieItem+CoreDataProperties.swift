//
//  MovieItem+CoreDataProperties.swift
//  SceneIt1
//
//  Created by Saida Hamidova on 1/27/22.
//
//

import Foundation
import CoreData


extension MovieItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieItem> {
        return NSFetchRequest<MovieItem>(entityName: "MovieItem")
    }

    @NSManaged public var date: String?
    @NSManaged public var language: String?
    @NSManaged public var media_type: String?
    @NSManaged public var movie_tag: String?
    @NSManaged public var overview: String?
    @NSManaged public var title: String?
    @NSManaged public var poster: String?

}

extension MovieItem : Identifiable {

}
