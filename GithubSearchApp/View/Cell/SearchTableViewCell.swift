//
//  SearchTableViewCell.swift
//  GithubSearchApp
//
//  Created by 박근보 on 2022/04/23.
//

import UIKit
import SnapKit
import Kingfisher

protocol SearchTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(row: Int, userID: String)
}

final class SearchTableViewCell: UITableViewCell {

    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "홍길동"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
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

    weak var delegate: SearchTableViewCellDelegate?

    var isFavorite = false
    var cellItem: UserItem?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpView()
        setUpConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpView() {

        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(favoriteButton)

        favoriteButton.addTarget(self, action: #selector(favoriteButtonTap(sender:)), for: .touchUpInside)
    }

    private func setUpConstraints() {

        userImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(80)
        }
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(20)
            make.center.equalToSuperview()
        }
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(40)
        }
    }

    func cellConfig(searchItem: UserItem, row: Int) {

        if let imageURL = URL(string: searchItem.userImage) {
            userImageView.kf.setImage(with: imageURL)
        } else {
            userImageView.image = UIImage(systemName: "star")
        }
        isFavorite = searchItem.isFavorite
        userNameLabel.text = searchItem.userName
        favoriteButton.tintColor = searchItem.isFavorite ? .systemYellow : .systemGray3
        favoriteButton.tag = row
        cellItem = searchItem
    }

    @objc private func favoriteButtonTap(sender: UIButton) {
        addPressAnimationToButton(scale: 0.85, favoriteButton) { [weak self] _ in
            guard let self = self else { return }
            guard let cellItem = self.cellItem else { return }
            self.isFavorite.toggle()
            self.favoriteButton.tintColor = self.isFavorite ? .systemYellow : .systemGray3
            self.delegate?.didTapFavoriteButton(row: sender.tag, userID: cellItem.userID)
        }
    }
}
