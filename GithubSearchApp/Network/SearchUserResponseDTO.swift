//
//  SearchUserResponseDTO.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/23.
//

import Foundation
// MARK: - SearchUserResponseDTO
struct SearchUserResponseDTO: Codable {
    let totalCount: Int
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

// MARK: - Item
struct Item: Codable {
    let login: String
    let id: Int
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}

extension SearchUserResponseDTO {
    func toEntity() -> UserData {
        return .init(total: totalCount,
                     userItems: items.map { $0.toEntity() })
    }
}

extension Item {
    func toEntity() -> UserItem {
        return .init(userName: login,
                     userImage: avatarURL,
                     userID: "\(id)",
                     isFavorite: false)
    }
}
