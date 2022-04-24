//
//  SearchViewController.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/22.
//

import UIKit
import RxSwift
import RxCocoa
import Toast

class SearchViewController: UIViewController {

    private lazy var input = SearchViewModel.Input(
        requestUserListEvent: requestUserListEvent.asSignal(),
        requestNextPageListEvent: requestNextPageListEvent.asSignal(),
        apiTabPressEvent: apiTabPressEvent.asSignal(),
        searchFavoriteUserListEvent: searchFavoriteUserListEvent.asSignal(),
        localTabPressEvent: localTabPressEvent.asSignal(),
        pressFavoriteButtonEvent: pressFavoriteButtonEvent.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)

    private let requestUserListEvent = PublishRelay<String>()
    private let requestNextPageListEvent = PublishRelay<String>()
    private let apiTabPressEvent = PublishRelay<Void>()
    private let searchFavoriteUserListEvent = PublishRelay<String>()
    private let localTabPressEvent = PublishRelay<Void>()
    private let pressFavoriteButtonEvent = PublishRelay<Int>()

    private let mainView = SearchView()
    private var viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    private var tabStyle: TapButtonStyle = .apiStyle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationItemConfig()
        setViewConfig()
        bind()
    }

    private func navigationItemConfig() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.titleLabel)
    }

    private func setViewConfig() {

        mainView.apiButton.tapButton.addTarget(self, action: #selector(apiButtonTap), for: .touchUpInside)
        mainView.localButton.tapButton.addTarget(self, action: #selector(localButtonTap), for: .touchUpInside)

        mainView.searchBar.delegate = self
        mainView.searchBar.searchTextField.delegate = self

        mainView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        mainView.searchTableView.keyboardDismissMode = .onDrag
        mainView.searchTableView.rowHeight = 100
    }

    private func bind() {

        output.didLoadUserList
            .drive(mainView.searchTableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.cellConfig(searchItem: element, row: row)
                cell.delegate = self

                switch self.tabStyle {
                case .apiStyle:
                    self.requestNextPage(row: row, element: self.viewModel.totalSearchItem)
                case .localStyle:
                    print("Local Cell")
                }
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
    }

    private func requestUserList() {
        guard let query = mainView.searchBar.searchTextField.text else { return }
        requestUserListEvent.accept(query)
    }

    private func requestNextPage(row: Int, element: [SearchItem]) {
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

    @objc private func apiButtonTap() {
        guard mainView.apiButton.status == .deselected else { return }

        tabStyle = .apiStyle
        mainView.noResultView.style = .apiStyle

        mainView.apiButton.status = .selected
        mainView.localButton.status = .deselected
        apiTabPressEvent.accept(())
    }

    @objc private func localButtonTap() {
        guard mainView.localButton.status == .deselected else { return }

        tabStyle = .localStyle
        mainView.noResultView.style = .localStyle

        mainView.apiButton.status = .deselected
        mainView.localButton.status = .selected
        localTabPressEvent.accept(())
    }
}

extension SearchViewController: UISearchBarDelegate, UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch tabStyle {
        case .apiStyle:
            requestUserList()
        case .localStyle:
            print("Local textField Return")
        }
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: SearchTableViewCellDelegate {
    func didTapFavoriteButton(row: Int) {
        switch tabStyle {
        case .apiStyle:
            pressFavoriteButtonEvent.accept(row)
        case .localStyle:
            print("Local Tap")
        }
    }
}
