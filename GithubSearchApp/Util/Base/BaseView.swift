//
//  BaseView.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/25.
//

import UIKit

class BaseView: UIView, ViewRepresentable {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpView() {}
    func setUpConstraint() {}
}
