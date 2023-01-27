//
//  CollectionResponse.swift
//  adastra.one
//
//  Created by Nikola Prljeta on 4.10.22..
//

import Foundation

struct CollectionResponse: Codable {
    let elapsedMilliseconds, count: Int?
    let countFacets: CountFacets?
    let artObjects: [ArtObject]?
    let facets: [CollectionResponseFacet]?
}

struct ArtObject: Codable {
    let links: Links?
    let id, objectNumber, title: String?
    let hasImage: Bool?
    let principalOrFirstMaker, longTitle: String?
    let showImage, permitDownload: Bool?
    let webImage, headerImage: Image?
    let productionPlaces: [String]?
}

struct Image: Codable {
    let guid: String?
    let offsetPercentageX, offsetPercentageY, width, height: Int?
    let url: String?
}

struct Links: Codable {
    let linksSelf, web: String?
}

struct CountFacets: Codable {
    let hasimage, ondisplay: Int?
}

struct CollectionResponseFacet: Codable {
    let facets: [FacetFacet]?
    let name: String?
    let otherTerms, prettyName: Int?
}

struct FacetFacet: Codable {
    let key: String?
    let value: Int?
}
