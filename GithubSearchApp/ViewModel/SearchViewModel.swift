//
//  SearchViewModel.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/23.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {

    struct Input {
        // API Tab
        let requestUserListEvent: Signal<String>
        let requestNextPageListEvent: Signal<String>
        // Local Tab
        let searchFavoriteUserListEvent: Signal<String>
        // common
        let pressFavoriteButtonEvent: Signal<Int>
    }

    struct Output {
        // API Tab
        let didLoadUserList: Driver<[SearchItem]>
        // Local Tab
        let didLoadLocalUserList: Driver<[SearchItem]>
        // Common
        let didPressFavoriteButton: Signal<Int>
        let failToastAction: Signal<String>
        let indicatorActin: Driver<Bool>
    }

    // API Tab
    private let didLoadUserList = BehaviorRelay<[SearchItem]>(value: [])
    // Local Tab
    private let didLoadLocalUserList = BehaviorRelay<[SearchItem]>(value: [])
    // Common
    private let didPressFavoriteButton = PublishRelay<Int>()
    private let failToastAction = PublishRelay<String>()
    private let indicatorAction = BehaviorRelay<Bool>(value: false)

    var disposeBag = DisposeBag()

    var totalSearchItem: [SearchItem] = []

    func transform(input: Input) -> Output {

        input.requestUserListEvent
            .emit { [weak self] query in
                guard let self = self else { return }
                self.totalSearchItem.removeAll()
                self.requestSearchUser(query: query) { response in
                    switch response {
                    case .success(let data):
                        self.appendData(searchItem: data.searchItems)
                        self.didLoadUserList.accept(self.totalSearchItem)
                    case .failure(let error):
                        self.failToastAction.accept(error.errorDescription ?? "Error")
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            didLoadUserList: didLoadUserList.asDriver(),
            didLoadLocalUserList: didLoadLocalUserList.asDriver(),
            didPressFavoriteButton: didPressFavoriteButton.asSignal(),
            failToastAction: failToastAction.asSignal(),
            indicatorActin: indicatorAction.asDriver()
        )
    }
}

extension SearchViewModel {

    private func requestSearchUser(query: String, completion: @escaping (Result<SearchData, SearchError>) -> Void) {

        let parameter = [
            "q": "\(query)"
        ]

        APIManager.shared.requestSearchUser(parameter: parameter, completion: completion)
    }

    private func appendData(searchItem: [SearchItem]) {
        for i in searchItem {
            totalSearchItem.append(i)
        }
    }
}
