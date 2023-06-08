//
//  SearchListCellData.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/08.
//

import Foundation

struct SearchListCellData: Decodable {
    let items: [Item]
}

struct Item: Decodable {
    let id: Int?
    let owner: Owner?
    let fullName: String?
    let description: String?
    let language: String?
    let stargazersCount: Int?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, owner, description, language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // 디코더에 저장된 데이터를 주어진 keyedBy 형식으로 반환
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.owner = try values.decode(Owner.self, forKey: .owner)
        self.fullName = try values.decode(String.self, forKey: .fullName)
        self.description = try values.decode(String.self, forKey: .description)
        self.language = try values.decode(String.self, forKey: .language)
        self.stargazersCount = try values.decode(Int.self, forKey: .stargazersCount)
        self.updatedAt = Date.parse(values, key: .updatedAt)
    }
}

struct Owner: Decodable {
    let avatarURL: String
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}

extension Date {
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
                let date = from(dateString: dateString) else {
            return nil
        }
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return nil
    }
}
