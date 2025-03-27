//
//  PostModel.swift
//  Auth05
//
//  Created by Apple on 24.03.2025.
//

import Foundation

// MARK: - Post
struct PostName: Codable {
    let title: String
    let body: String
    let tagList: [String]
    let categoryList: [String]
    let postImage: PostImage
    let price: Int
    let city: String
    let amount: Int
    let displays: [Display]
    let comments: [PostComment]
    
    enum CodingKeys: String, CodingKey {
        case title, body
        case tagList = "tag_list"
        case categoryList = "category_list"
        case postImage = "post_image"
        case price, city, amount, displays, comments
    }
}

// MARK: - PostComment (переименовано из Comment)
struct PostComment: Codable {
    let profile: PostProfile  
    let body: String
}

// MARK: - PostProfile (переименовано из ProfileClass)
struct PostProfile: Codable {
    let name: String
    let avatar: String
}

// MARK: - Display
struct Display: Codable {
    let id: Int
    let name: String
    let year: String
    let displayType: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, year
        case displayType = "display_type"
    }
}

// MARK: - PostImage
struct PostImage: Codable {
    let url: String
}
