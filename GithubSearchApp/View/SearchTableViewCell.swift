//
//  SearchTableViewCell.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/23.
//

import UIKit
import SnapKit
import Kingfisher

final class SearchTableViewCell: UITableViewCell {

    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray3
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.contentMode = .scaleToFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpView() {

        addSubview(userImageView)
        addSubview(userNameLabel)
        addSubview(favoriteButton)
    }

    private func setUpConstraints() {

        userImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(80)
        }
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(5)
            make.center.equalToSuperview()
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(40)
        }
    }

    func cellConfig(searchItem: SearchItem) {

        if let imageURL = URL(string: searchItem.userImage) {
            userImageView.kf.setImage(with: imageURL)
        } else {
            userImageView.image = UIImage(systemName: "star")
        }
        userNameLabel.text = searchItem.userName
        favoriteButton.tintColor = searchItem.isFavorite ? .systemYellow : .systemGray3
    }
}
