//
//  SearchViewModel.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/08/21.
//

import RxSwift
import RxCocoa

struct SearchViewModel {
    let disposeBag = DisposeBag()
    
    let searchListViewModel = SearchListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<SearchViewController.AlertAction>()
    let shouldPresentAlert: Signal<SearchViewController.Alert>
    //var finalData: [SearchRepositoryCellData] = []

    init(model: SearchModel = SearchModel()) {
        let repoResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest {
                model.searchRepo($0)
            }
            .share()
    
        let repoValue = repoResult
            .compactMap {
                model.getRepoValue($0)
            }
        
        let repoError = repoResult
            .compactMap {
                model.getRepoError($0)
            }
        
        let cellData = repoValue
            .map {
                model.getRepoListCellData($0)
            }
        
        let sortedtype = alertActionTapped
            .filter {
                switch $0 {
                case .datetime, .title:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        // SearchViewController -> SearchListView
        Observable
            .combineLatest(
                cellData, sortedtype
            ) { data, type -> [SearchRepositoryCellData] in
                return model.sort(by: type, of: data)
            }
            .bind(to: searchListViewModel.repoCellData)
            .disposed(by: disposeBag)
        
        let alertSheetForSorting =
        searchListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> SearchViewController.Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = repoError
            .map { message -> SearchViewController.Alert in
                return (
                    title: "오류",
                    message: "예상치 못한 오류가 발생하였습니다. \(message)",
                    actions: [.confirm],
                    style: .alert)
            }
        
        self.shouldPresentAlert = Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
