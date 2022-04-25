//
//  SeachView.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/23.
//

import UIKit
import SnapKit

final class APIView: UIView, ViewRepresentable {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "GitHub Stars"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    let tapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    let noResultView: NoResultView = {
        let view = NoResultView()
        view.isHidden = true
        return view
    }()
    let searchTableView = UITableView()
    let indicatorView = IndicatorView()
    let apiButton = TapButton(style: .apiStyle, status: .selected)
    let localButton = TapButton(style: .localStyle, status: .deselected)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpView() {

        addSubview(tapStackView)
        addSubview(searchBar)
        addSubview(searchTableView)
        addSubview(indicatorView)
        addSubview(noResultView)

        tapStackView.addArrangedSubview(apiButton)
        tapStackView.addArrangedSubview(localButton)
    }

    func setUpConstraint() {

        tapStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(tapStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        noResultView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
