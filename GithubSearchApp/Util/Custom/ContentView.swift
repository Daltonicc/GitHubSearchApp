//
//  ContentView.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/25.
//

import UIKit
import SnapKit

final class ContentView: BaseView {

    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    let noResultView: NoResultView = {
        let view = NoResultView(text: "검색 결과가 없습니다.")
        view.isHidden = true
        return view
    }()
    let searchTableView = UITableView()
    let indicatorView = IndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func setUpView() {

        addSubview(separateView)
        addSubview(searchBar)
        addSubview(searchTableView)
        addSubview(indicatorView)
        addSubview(noResultView)
    }

    override func setUpConstraint() {

        separateView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(separateView2.snp.bottom)
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
