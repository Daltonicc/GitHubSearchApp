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
    private let pressFavoriteButtonEvent = PublishRelay<String>()

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

        // 즐겨찾기 유저 리스트 호출
        output.didLoadFavoriteUserList
            .drive { [weak self] item in
                guard let self = self else { return }
                self.favoriteUserList = item
                self.mainView.searchTableView.reloadData()
            }
            .disposed(by: disposeBag)

        // 즐겨찾기 제거 버튼을 눌렀을 때
        output.didPressFavoriteButton
            .emit { [weak self] _ in
                guard let self = self else { return }
                self.requestFavoriteUserListEvent.accept(())
            }
            .disposed(by: disposeBag)

        // Section Header 리스트 호출
        output.sendSectionHeaderList
            .drive { [weak self] headerList in
                guard let self = self else { return }
                self.headerList = headerList
            }
            .disposed(by: disposeBag)

        // 결과값 없을 때
        output.noResultAction
            .drive { [weak self] bool in
                guard let self = self else { return }
                self.mainView.noResultView.isHidden = bool
            }
            .disposed(by: disposeBag)

        // 0.1초 단위 실시간 즐겨찾기 유저 검색 기능
        mainView.searchBar.searchTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] query in
                guard let self = self else { return }
                self.searchFavoriteUserListEvent.accept(query)
            }
            .disposed(by: disposeBag)
    }

    private func searchFavoriteUserList() {
        guard let query = mainView.searchBar.searchTextField.text else { return }
        searchFavoriteUserListEvent.accept(query)
    }

    private func removeAlert(completion: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: "정말 즐겨찾기에서 삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { [weak self] action in
            self?.requestFavoriteUserListEvent.accept(())
        }
        let ok = UIAlertAction(title: "삭제", style: .destructive, handler: completion)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension LocalViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFavoriteUserList()
        textField.resignFirstResponder()
        return true
    }
}

// iOS 14.0 이상이라면 제거 확인 얼럿, 이하라면 바로 제거
extension LocalViewController: SearchTableViewCellDelegate {
    func didTapFavoriteButton(row: Int, userID: String) {
        if #available(iOS 14.0, *) {
            removeAlert { [weak self] _ in
                guard let self = self else { return }
                self.pressFavoriteButtonEvent.accept(userID)
            }
        } else {
            self.pressFavoriteButtonEvent.accept(userID)
        }
    }
}

// Section Header 구현을 위해 UITableViewDataSource 활용
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
        guard let query = mainView.searchBar.searchTextField.text else { return UITableViewCell() }

        let row = indexPath.row
        let index = favoriteUserList[0].userName.startIndex
        let list = favoriteUserList.filter { $0.userName[index].uppercased() == headerList[indexPath.section] }

        cell.cellConfigForLocal(query: query, searchItem: list[row], row: row)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerList[section]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
