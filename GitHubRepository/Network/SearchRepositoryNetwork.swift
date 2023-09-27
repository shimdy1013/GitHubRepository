//
//  SearchRepositoryNetwork.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/08.
//

import Foundation
import RxSwift

enum SearchNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
}

class SearchRepositoryNetwork {
    private let session: URLSession
    let api = SearchRepositoryAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchRepository(query: String) -> Single<Result<SearchRepository, SearchNetworkError>> {
        // 네트워크는 성공 or 실패 -> Single
        // Result<Success, failure>는 enum 유형으로 성공과 실패 두 가지
        
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.rx.data(request: request as URLRequest)
            .asSingle()
            .map { data in
                do {
                    let repoData = try JSONDecoder().decode(SearchRepository.self, from: data)
                    return .success(repoData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                .just(.failure(.networkError))
            }
    }
}
