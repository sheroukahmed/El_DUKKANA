//
//  Brands.swift
//  El_DUKKANA
//
//  Created by Sarah on 05/09/2024.
//

import Foundation

struct BrandsResponse: Codable {
    let smart_collections: [SmartCollectionsItem]
}

struct SmartCollectionsItem: Codable {
    let id: Int?
    let handle: String?
    let title: String?
    let image: BrandImage?
    
}

struct BrandImage: Codable {
    let src: String?
}
