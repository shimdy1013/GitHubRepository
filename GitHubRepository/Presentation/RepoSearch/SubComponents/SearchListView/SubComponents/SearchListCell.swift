//
//  SearchListCell.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/08.
//

import UIKit
import Kingfisher
import SnapKit

class SearchListCell: UITableViewCell {
    var searchRepository: SearchRepository?
    let avatarImageView = UIImageView()
    let fullNameLabel = UILabel()
    let descriptionLabel = UILabel()
    let starImageView = UIImageView()
    let starLabel = UILabel()
    let languageLabel = UILabel()
    let updatedAtLabel = UILabel()
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [
            avatarImageView, fullNameLabel, descriptionLabel,
            starImageView, starLabel, languageLabel, updatedAtLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        avatarImageView.makeRounded()
        
        fullNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines =  1
        
        starImageView.image = UIImage(named: "star")
        
        starLabel.font = .systemFont(ofSize: 15)
        starLabel.textColor = .gray

        languageLabel.font = .systemFont(ofSize: 15)
        languageLabel.textColor = .gray
        
        updatedAtLabel.font = .systemFont(ofSize: 13)
        updatedAtLabel.textColor = .gray
                
        avatarImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(18)
            $0.width.height.equalTo(22)
        }
        
        fullNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(avatarImageView)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(8)
            $0.leading.equalTo(avatarImageView)
            $0.trailing.equalTo(fullNameLabel)
        }
        
        languageLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(descriptionLabel)
            $0.bottom.equalToSuperview().inset(15)
        }

        starImageView.snp.makeConstraints {
            $0.centerY.equalTo(languageLabel)
            $0.leading.equalTo(languageLabel.snp.trailing).offset(12)
            $0.width.height.equalTo(15)
        }
        
        starLabel.snp.makeConstraints {
            $0.centerY.equalTo(starImageView)
            $0.leading.equalTo(starImageView.snp.trailing).offset(5)
        }
        
        updatedAtLabel.snp.makeConstraints {
            $0.centerY.equalTo(starImageView)
            $0.leading.equalTo(starLabel.snp.trailing).offset(12)
        }
        
    }
    
    func setData(_ data: SearchRepositoryCellData) {
        avatarImageView.kf.setImage(with: data.avatarURL, placeholder: UIImage(systemName: "photo"))
        fullNameLabel.text = data.fullName
        descriptionLabel.text = data.description
        starImageView.image = UIImage(systemName: "star.fill")
        starLabel.text = "\(data.stargazersCount ?? 0)"
        languageLabel.text = data.language
        
        var updateTime: String {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy년 MM월 dd일"
            let contentDate = data.updatedAt ?? Date()
            
            return dateformatter.string(from: contentDate)
        }
        updatedAtLabel.text = "Updated on \(updateTime)"
    }
}

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
