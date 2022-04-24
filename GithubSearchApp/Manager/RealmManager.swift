//
//  RealmManager.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import Foundation
import RealmSwift

final class RealmManager {

    static let shared = RealmManager()

    private let localRealm = try! Realm()

    private init() {}

    func saveMovieListData(with list: FavoriteUserList) {
        do {
            try localRealm.write {
                localRealm.add(list)
            }
        } catch {
            fatalError("Realm Save Error")
        }
    }

    func loadListData() -> Results<FavoriteUserList> {
        return localRealm.objects(FavoriteUserList.self)

    }

    func deleteListData(index: Int) {
        let task = localRealm.objects(FavoriteUserList.self)[index]
        do {
            try localRealm.write {
                localRealm.delete(task)
            }
        } catch {
            fatalError("Realm Delete Error")
        }
    }

    func deleteObjectData(object: FavoriteUserList) {
        do {
            try localRealm.write {
                localRealm.delete(object)
            }
        } catch {
            fatalError("Realm Delete Error")
        }

    }
}
