//
//  NoResultView.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import UIKit
import SnapKit

final class NoResultView: UIView, ViewRepresentable {

    let noResultLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .systemGray3
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(text: String) {
        self.init()
        noResultLabel.text = text
    }

    func setUpView() {

        addSubview(noResultLabel)
    }

    func setUpConstraint() {

        noResultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
