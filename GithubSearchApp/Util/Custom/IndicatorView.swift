//
//  IndicatorView.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import UIKit
import SnapKit

final class IndicatorView: UIView {

    let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpView() {

        addSubview(indicatorView)

        self.backgroundColor = .systemGray3
        self.layer.cornerRadius = 5
    }

    func setUpConstraint() {

        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
