//
//  BaseViewController.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewConfig()
        bind()
    }

    func setViewConfig() {
        view.backgroundColor = .systemBackground
    }

    func bind() {}
}
