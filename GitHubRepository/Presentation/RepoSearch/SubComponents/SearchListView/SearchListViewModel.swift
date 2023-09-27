//
//  SearchListViewModel.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/08/21.
//

import RxSwift
import RxCocoa

struct SearchListViewModel {
    let filterViewModel = FilterViewModel()
    let repoCellData = PublishSubject<[SearchRepositoryCellData]>()
    let cellData: Driver<[SearchRepositoryCellData]>
    
    init() {
        self.cellData = repoCellData
            .asDriver(onErrorJustReturn: [])    
    }
}
