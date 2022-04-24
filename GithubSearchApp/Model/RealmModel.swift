//
//  RealmModel.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import Foundation
import RealmSwift

final class FavoriteUserList: Object {

    @Persisted var userName: String
    @Persisted var userId: String
    @Persisted var userProfileImage: String
    @Persisted var isFavorite: Bool

    @Persisted(primaryKey: true) var _id: ObjectId

    convenience init(userName: String, userId: String, userProfileImage: String, isFavorite: Bool) {
        self.init()

        self.userName = userName
        self.userId = userId
        self.userProfileImage = userProfileImage
        self.isFavorite = isFavorite
    }
}
