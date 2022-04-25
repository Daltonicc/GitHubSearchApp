//
//  NoResultView.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import UIKit
import SnapKit

final class NoResultView: BaseView {

    let noResultLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .systemGray3
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(text: String) {
        self.init()
        noResultLabel.text = text
    }

    override func setUpView() {

        addSubview(noResultLabel)
    }

    override func setUpConstraint() {

        noResultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
