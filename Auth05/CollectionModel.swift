//
//  CollectionModel.swift
//  Auth05
//
//  Created by Apple on 24.03.2025.
//

import Foundation

// MARK: - Profile
struct CollectionName: Codable {
    let title, body: String
    let posts: [CollectionName]
}

// MARK: - Post
struct CollectionPost: Codable {
    let id: Int
    let title: String
    let postImage: CollectionPostImage
    let categoryList: [String]
    let profile: CollectionProfileClass

    enum CodingKeys: String, CodingKey {
        case id, title
        case postImage = "post_image"
        case categoryList = "category_list"
        case profile
    }
}

// MARK: - PostImage
struct CollectionPostImage: Codable {
    let url: String
}

// MARK: - ProfileClass
struct CollectionProfileClass: Codable {
    let name: String
}
