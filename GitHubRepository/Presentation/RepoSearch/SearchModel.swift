//
//  SearchModel.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/08/24.
//

import RxSwift

struct SearchModel {
    
    let network = SearchRepositoryNetwork()
    
    func searchRepo(_ query: String) -> Single<Result<SearchRepository, SearchNetworkError>>{
        return network.searchRepository(query: query)
    }
    
    func getRepoValue(_ result: Result<SearchRepository, SearchNetworkError>) -> SearchRepository? {
        guard case .success(let value) = result else {
            return nil
        }
        return value
    }
    
    func getRepoError(_ result: Result<SearchRepository, SearchNetworkError>) -> String? {
        guard case .failure(let error) = result else {
            return nil
        }
        return error.localizedDescription
        
    }
    
    func getRepoListCellData(_ value: SearchRepository) -> [SearchRepositoryCellData] {
        return value.items
            .map { item in
                let avatarURL = URL(string: item.owner?.avatarURL ?? "")
                return SearchRepositoryCellData(avatarURL: avatarURL, fullName: item.fullName, description: item.description, language: item.language, stargazersCount: item.stargazersCount, updatedAt: item.updatedAt)
            }
    }
    
    func sort(by type: SearchViewController.AlertAction, of data: [SearchRepositoryCellData]) -> [SearchRepositoryCellData] {
        switch type {
        case .title:
            return data.sorted { $0.fullName ?? "" < $1.fullName ?? ""}
            //return data.sorted { $0.title ?? "" < $1.title ?? "" }
        case .datetime:
            return data.sorted { $0.updatedAt ?? Date() > $1.updatedAt ?? Date()}
            //return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date()}
        default:
            return data
            //                case .title:
            //                    self.finalData = data.sorted { $0.fullName ?? "" < $1.fullName ?? ""}
            //                    return self.finalData
            //                    //return data.sorted { $0.title ?? "" < $1.title ?? "" }
            //                case .datetime:
            //                    self.finalData = data.sorted { $0.updatedAt ?? Date() > $1.updatedAt ?? Date()}
            //                    return self.finalData
            //                    //return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date()}
            //                default:
            //                    self.finalData = data
            //                    return self.finalData
        }
    }
}

