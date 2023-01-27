//
//  CollectionDetailsResponse.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 4.10.22..
//

import Foundation

struct CollectionDetailsResponse: Codable {
    let elapsedMilliseconds: Int?
    let artObject: ArtObjectDetails?
}

struct ArtObjectDetails: Codable {
    //this is the only property we care for from this massive response
    let plaqueDescriptionEnglish: String?
}
