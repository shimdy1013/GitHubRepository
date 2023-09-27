//
//  RepositoryListCell.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/05/12.
//

import UIKit
import SnapKit

class RepositoryListCell: UITableViewCell {
    var repository: Repository?
    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let starImageView = UIImageView()
    let starLabel = UILabel()
    let languageLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [
            nameLabel, descriptionLabel,
            starImageView, starLabel, languageLabel
        ].forEach {
            contentView.addSubview($0)
        }
        
        guard let repository = repository else { return }
        
        nameLabel.text = repository.name
        nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        descriptionLabel.text = repository.description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines =  2
        
        starImageView.image = UIImage(named: "star")
        
        starLabel.text = "\(repository.stargazersCount)"
        starLabel.font = .systemFont(ofSize: 15)
        starLabel.textColor = .gray

        languageLabel.text = repository.language
        languageLabel.font = .systemFont(ofSize: 15)
        languageLabel.textColor = .gray
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalTo(nameLabel)
        }
        
        starImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(descriptionLabel)
            $0.width.height.equalTo(15)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        starLabel.snp.makeConstraints {
            $0.centerY.equalTo(starImageView)
            $0.leading.equalTo(starImageView.snp.trailing).offset(5)
        }
        
        languageLabel.snp.makeConstraints {
            $0.centerY.equalTo(starLabel)
            $0.leading.equalTo(starLabel.snp.trailing).offset(12)
        }
    }
}
