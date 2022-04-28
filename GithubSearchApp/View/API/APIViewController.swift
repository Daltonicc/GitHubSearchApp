//
//  APIViewController.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

final class APIViewController: BaseViewController {

    private lazy var input = APIViewModel.Input(
        requestUserListEvent: requestUserListEvent.asSignal(),
        requestNextPageListEvent: requestNextPageListEvent.asSignal(),
        pressFavoriteButtonEvent: pressFavoriteButtonEvent.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)

    private let requestUserListEvent = PublishRelay<String>()
    private let requestNextPageListEvent = PublishRelay<String>()
    private let pressFavoriteButtonEvent = PublishRelay<Int>()

    private let mainView = ContentView()
    private var viewModel = APIViewModel()
    private let disposeBag = DisposeBag()

    override func loadView() {
        self.view = mainView
    }

    override func viewWillAppear(_ animated: Bool) {
        requestUserList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setViewConfig() {
        super.setViewConfig()

        mainView.noResultView.status = .api

        mainView.searchBar.delegate = self
        mainView.searchBar.searchTextField.delegate = self

        mainView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        mainView.searchTableView.keyboardDismissMode = .onDrag
        mainView.searchTableView.rowHeight = 100
    }

    override func bind() {

        output.didLoadUserList
            .drive(mainView.searchTableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.cellConfigForAPI(searchItem: element, row: row)
                cell.delegate = self
                self.requestNextPage(row: row, element: self.viewModel.totalSearchItem)
            }
            .disposed(by: disposeBag)

        output.noResultAction
            .drive { [weak self] bool in
                guard let self = self else { return }
                self.mainView.noResultView.isHidden = bool
            }
            .disposed(by: disposeBag)

        output.indicatorActin
            .drive { [weak self] bool in
                guard let self = self else { return }
                self.indicatorAction(bool: bool)
            }
            .disposed(by: disposeBag)

        output.failToastAction
            .emit { [weak self] errorMessage in
                guard let self = self else { return }
                self.mainView.makeToast(errorMessage)
            }
            .disposed(by: disposeBag)

        mainView.searchTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                self.mainView.searchTableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)

        mainView.searchBar.searchTextField.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] query in
                guard let self = self else { return }
                if query.count >= 1 {
                    self.requestUserListEvent.accept(query)
                }
            }
            .disposed(by: disposeBag)
    }

    private func requestUserList() {
        guard let query = mainView.searchBar.searchTextField.text else { return }
        if query.count >= 1 {
            requestUserListEvent.accept(query)
        }
    }

    private func requestNextPage(row: Int, element: [UserItem]) {
        if row == element.count - 1 {
            guard let query = mainView.searchBar.searchTextField.text else { return }
            requestNextPageListEvent.accept(query)
        }
    }

    private func indicatorAction(bool: Bool) {
        if bool {
            mainView.indicatorView.isHidden = false
            mainView.indicatorView.indicatorView.startAnimating()
        } else {
            mainView.indicatorView.isHidden = true
            mainView.indicatorView.indicatorView.stopAnimating()
        }
    }
}

extension APIViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        requestUserList()
        textField.resignFirstResponder()
        return true
    }
}

extension APIViewController: SearchTableViewCellDelegate {
    func didTapFavoriteButton(row: Int, userID: String) {
        pressFavoriteButtonEvent.accept(row)
    }
}
