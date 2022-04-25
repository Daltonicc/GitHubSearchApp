//
//  TabButton.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/23.
//

import UIKit
import SnapKit

enum TapButtonStyle {
    case apiStyle
    case localStyle
}

enum TapButtonStatus {
    case selected
    case deselected
}

final class TapButton: UIView, ViewRepresentable {

    let tapButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    let bottomBar = UIView()

    var status: TapButtonStatus = .selected {
        didSet {
            statusChange(status: status)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(style: TapButtonStyle, status: TapButtonStatus) {
        self.init()
        setUpView()
        setUpConstraint()
        styleConfig(style: style)
        statusChange(status: status)
        self.status = status
    }

    func setUpView() {

        addSubview(tapButton)
        addSubview(bottomBar)
    }

    func setUpConstraint() {

        tapButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }

    private func statusChange(status: TapButtonStatus) {
        switch status {
        case .selected:
            tapButton.setTitleColor(.black, for: .normal)
            bottomBar.backgroundColor = .black
        case .deselected:
            tapButton.setTitleColor(.systemGray3, for: .normal)
            bottomBar.backgroundColor = .systemGray3
        }
    }

    private func styleConfig(style: TapButtonStyle) {
        switch style {
        case .apiStyle: tapButton.setTitle("API", for: .normal)
        case .localStyle: tapButton.setTitle("Local", for: .normal)
        }
    }
}
