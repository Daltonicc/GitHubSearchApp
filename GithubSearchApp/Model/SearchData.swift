//
//  SearchData.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import Foundation

struct SearchData {
    let total: Int
    let searchItems: [SearchItem]
}

struct SearchItem {
    let userName: String
    let userImage: String
    let userID: Int
    var isFavorite: Bool
}
