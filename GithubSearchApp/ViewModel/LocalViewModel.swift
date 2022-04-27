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
        let pressFavoriteButtonEvent: Signal<Int>
    }

    struct Output {
        let didLoadFavoriteUserList: Driver<[UserItem]>
        let didPressFavoriteButton: Signal<Int>
        let noResultAction: Driver<Bool>
    }

    private let didLoadFavoriteUserList = BehaviorRelay<[UserItem]>(value: [])
    private let didPressFavoriteButton = PublishRelay<Int>()
    private let noResultAction = BehaviorRelay<Bool>(value: false)

    var disposeBag = DisposeBag()

    var favoriteSearchItem: [UserItem] = []

    private var favoriteUserList: Results<FavoriteUserList>! {
        return RealmManager.shared.loadListData()
    }

    func transform(input: Input) -> Output {

        input.requestFavoriteUserListEvent
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.getFavoriteUserData()
                self.noResultAction.accept(self.checkNoResult(searchItem: self.favoriteSearchItem))
                self.didLoadFavoriteUserList.accept(self.favoriteSearchItem)
            }
            .disposed(by: disposeBag)

        return Output(
            didLoadFavoriteUserList: didLoadFavoriteUserList.asDriver(),
            didPressFavoriteButton: didPressFavoriteButton.asSignal(),
            noResultAction: noResultAction.asDriver()
        )
    }
}

extension LocalViewModel {

    private func getFavoriteUserData() {
        favoriteSearchItem.removeAll()
        for i in 0..<favoriteUserList.count {
            let data = UserItem(userName: favoriteUserList[i].userName,
                                  userImage: favoriteUserList[i].userProfileImage,
                                  userID: favoriteUserList[i].userId,
                                  isFavorite: favoriteUserList[i].isFavorite)
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
}
