//
//  LocalViewController.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LocalViewController: BaseViewController {

    private lazy var input = LocalViewModel.Input(
        requestFavoriteUserListEvent: requestFavoriteUserListEvent.asSignal(),
        searchFavoriteUserListEvent: searchFavoriteUserListEvent.asSignal(),
        pressFavoriteButtonEvent: pressFavoriteButtonEvent.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)

    private let requestFavoriteUserListEvent = PublishRelay<Void>()
    private let searchFavoriteUserListEvent = PublishRelay<String>()
    private let pressFavoriteButtonEvent = PublishRelay<Int>()

    private let mainView = ContentView()
    private var viewModel = LocalViewModel()
    private let disposeBag = DisposeBag()

    private lazy var favoriteUserList: [UserItem] = []
    private lazy var headerList: [String] = []

    override func loadView() {
        self.view = mainView
    }

    override func viewWillAppear(_ animated: Bool) {
        requestFavoriteUserListEvent.accept(())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setViewConfig() {
        super.setViewConfig()

        mainView.noResultView.status = .local
        mainView.indicatorView.isHidden = true
        
        mainView.searchBar.delegate = self
        mainView.searchBar.searchTextField.delegate = self

        mainView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        mainView.searchTableView.keyboardDismissMode = .onDrag
        mainView.searchTableView.rowHeight = 100
        mainView.searchTableView.delegate = self
        mainView.searchTableView.dataSource = self
    }

    override func bind() {

        output.didLoadFavoriteUserList
            .drive { [weak self] item in
                guard let self = self else { return }
                self.favoriteUserList = item
            }
            .disposed(by: disposeBag)

        output.sendSectionHeaderList
            .drive { [weak self] headerList in
                guard let self = self else { return }
                self.headerList = headerList
            }
            .disposed(by: disposeBag)

        output.noResultAction
            .drive { [weak self] bool in
                guard let self = self else { return }
                self.mainView.noResultView.isHidden = bool
            }
            .disposed(by: disposeBag)
    }

    private func asd() {

    }
}

extension LocalViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension LocalViewController: SearchTableViewCellDelegate {
    func didTapFavoriteButton(row: Int) {
        
    }
}

extension LocalViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return headerList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = favoriteUserList[0].userName.startIndex
        let character = favoriteUserList.map { String($0.userName[index].uppercased()) }
        let number = character.filter { $0 == headerList[section] }.count
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let row = indexPath.row
        let index = favoriteUserList[0].userName.startIndex
        let list = favoriteUserList.filter { $0.userName[index].uppercased() == headerList[indexPath.section] }

        cell.cellConfig(searchItem: list[row], row: row)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerList[section]
    }
}
