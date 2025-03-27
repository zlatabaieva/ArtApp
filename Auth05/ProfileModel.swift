//
//  ProfileModel.swift
//  Auth05
//
//  Created by Apple on 20.03.2025.
//

import Foundation

// MARK: - Profile
struct Profile: Codable, Equatable {
    let name, bio: String
    let avatar: Avatar
    let contact: String
    let authorTags: [String]
    let posts: [Post]
    let collections: [Collection]

    enum CodingKeys: String, CodingKey {
        case name, bio, avatar, contact
        case authorTags = "author_tags"
        case posts, collections
    }
    static func == (lhs: Profile, rhs: Profile) -> Bool {
           return lhs.name == rhs.name &&
                  lhs.bio == rhs.bio &&
                  lhs.contact == rhs.contact &&
                  lhs.avatar.url == rhs.avatar.url
       }
}

// MARK: - Avatar
struct Avatar: Codable {
    let url: String
}

// MARK: - Post
struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let postImage: Avatar
    let categoryList: [String]
    let profile: ProfileClass

    enum CodingKeys: String, CodingKey {
        case id, title
        case postImage = "post_image"
        case categoryList = "category_list"
        case profile
    }
}
// MARK: - Collection
struct Collection: Codable, Identifiable {
    let id: Int
    let title, body: String
    let tagList: [String]
    let profile: ProfileClass

    enum CodingKeys: String, CodingKey {
        case id, title, body
        case tagList = "tag_list"
        case profile
    }
}

// MARK: - ProfileClass
struct ProfileClass: Codable {
    let name: String
}

