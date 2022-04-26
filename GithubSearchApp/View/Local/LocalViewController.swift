//
//  LocalViewController.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/25.
//

import UIKit

final class LocalViewController: BaseViewController {

    private let mainView = ContentView()

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setViewConfig() {
        super.setViewConfig()
        
        mainView.searchBar.delegate = self
        mainView.searchBar.searchTextField.delegate = self

        mainView.searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        mainView.searchTableView.keyboardDismissMode = .onDrag
        mainView.searchTableView.rowHeight = 100
    }

    override func bind() {

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
