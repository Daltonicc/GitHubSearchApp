//
//  NoResultView.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import UIKit
import SnapKit

final class NoResultView: BaseView {

    enum NoResultStatus {
        case api
        case local
    }

    let noResultLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .systemGray3
        return label
    }()

    var status: NoResultStatus = .api {
        didSet {
            statusConfig()
        }
    }

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

    private func statusConfig() {
        switch status {
        case .api: noResultLabel.text = "검색 결과가 없습니다."
        case .local: noResultLabel.text = "즐겨찾기 목록이 없습니다."
        }
    }
}
