//
//  NoResultView.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/24.
//

import UIKit
import SnapKit

final class NoResultView: UIView, ViewRepresentable {

    let noResultLabel = UILabel()
    var style: TapButtonStyle = .apiStyle {
        didSet {
            labelConfig()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraint()
        labelConfig()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpView() {

        addSubview(noResultLabel)
    }

    func setUpConstraint() {

        noResultLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func labelConfig() {

        noResultLabel.font = .boldSystemFont(ofSize: 25)
        noResultLabel.textColor = .systemGray3
        switch style {
        case .apiStyle: noResultLabel.text = "검색 결과가 없습니다"
        case .localStyle: noResultLabel.text = "즐겨찾기한 계정이 없습니다"
        }
    }
}
