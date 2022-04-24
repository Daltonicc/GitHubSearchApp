//
//  SearchData.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import Foundation

struct UserData {
    let total: Int
    let userItems: [UserItem]
}

struct UserItem {
    let userName: String
    let userImage: String
    let userID: String
    var isFavorite: Bool
}
