//
//  LocalViewModel.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/25.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class LocalViewModel: ViewModelType {

    struct Input {
        let requestFavoriteUserListEvent: Signal<Void>
        let searchFavoriteUserListEvent: Signal<String>
        let pressFavoriteButtonEvent: Signal<String>
    }

    struct Output {
        let didLoadFavoriteUserList: Driver<[UserItem]>
        let didPressFavoriteButton: Signal<Void>
        let sendSectionHeaderList: Driver<[String]>
        let noResultAction: Driver<Bool>
    }

    private let didLoadFavoriteUserList = BehaviorRelay<[UserItem]>(value: [])
    private let didPressFavoriteButton = PublishRelay<Void>()
    private let sendSectionHeaderList = BehaviorRelay<[String]>(value: [])
    private let noResultAction = BehaviorRelay<Bool>(value: false)

    var disposeBag = DisposeBag()

    var favoriteSearchItem: [UserItem] = []
    var headerList: [String] = []

    private var favoriteUserList: Results<FavoriteUserList>! {
        return RealmManager.shared.loadListData().sorted(byKeyPath: "userName", ascending: true)
    }

    func transform(input: Input) -> Output {

        // 즐겨찾기 유저 리스트 요청 받았을 때 로직
        input.requestFavoriteUserListEvent
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.getFavoriteUserData(list: self.favoriteUserList)
                self.getSectionHeaderList()
                self.sendSectionHeaderList.accept(self.headerList)
                self.noResultAction.accept(self.checkNoResult(searchItem: self.favoriteSearchItem))
                self.didLoadFavoriteUserList.accept(self.favoriteSearchItem)
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 유저 검색할 때 로직
        input.searchFavoriteUserListEvent
            .emit { [weak self] query in
                guard let self = self else { return }
                if query.count == 0 {
                    self.getFavoriteUserData(list: self.favoriteUserList)
                } else {
                    self.getFavoriteUserData(list: self.searchFavoriteUser(query: query))
                }
                self.getSectionHeaderList()
                self.sendSectionHeaderList.accept(self.headerList)
                self.noResultAction.accept(self.checkNoResult(searchItem: self.favoriteSearchItem))
                self.didLoadFavoriteUserList.accept(self.favoriteSearchItem)
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 추가/제거 로직
        input.pressFavoriteButtonEvent
            .emit { [weak self] userID in
                guard let self = self else { return }
                self.checkUserIDAndDeleteFromDatabase(userID: userID)
                self.didPressFavoriteButton.accept(())
            }
            .disposed(by: disposeBag)

        return Output(
            didLoadFavoriteUserList: didLoadFavoriteUserList.asDriver(),
            didPressFavoriteButton: didPressFavoriteButton.asSignal(),
            sendSectionHeaderList: sendSectionHeaderList.asDriver(),
            noResultAction: noResultAction.asDriver()
        )
    }
}

extension LocalViewModel {

    private func getFavoriteUserData(list: Results<FavoriteUserList>) {
        favoriteSearchItem.removeAll()
        for i in 0..<list.count {
            let data = UserItem(userName: list[i].userName,
                                  userImage: list[i].userProfileImage,
                                  userID: list[i].userId,
                                  isFavorite: list[i].isFavorite)
            favoriteSearchItem.append(data)
        }
    }

    private func checkNoResult(searchItem: [UserItem]) -> Bool {
        if searchItem.count == 0 {
            return false
        } else {
            return true
        }
    }

    // Section Header 리스트 생성 메서드
    private func getSectionHeaderList() {
        var list: [String] = []
        for i in favoriteSearchItem {
            let index = i.userName.startIndex
            let character = String(i.userName[index]).uppercased()
            list.append(character)
        }
        headerList = Array(Set(list).sorted())
    }

    private func searchFavoriteUser(query: String) -> Results<FavoriteUserList> {
        let filterList = favoriteUserList.filter("userName CONTAINS[c] '\(query)'")
        return filterList
    }

    private func checkUserIDAndDeleteFromDatabase(userID: String) {
        let filterItem = favoriteUserList.filter("userId = '\(userID)'")[0]
        RealmManager.shared.deleteObjectData(object: filterItem)
    }
}
