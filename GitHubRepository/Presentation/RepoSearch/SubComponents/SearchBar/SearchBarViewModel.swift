//
//  SearchBarViewModel.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/08/21.
//

import RxSwift
import RxCocoa

struct SearchBarViewModel {
    let queryText = PublishRelay<String?>()
    let searchButtonTapped = PublishRelay<Void>()
    let shouldLoadResult: Observable<String>

    init() {
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) {
                $1 ?? ""    // text가 nil일 때 빈 값 반환
            }
            .filter {
                !$0.isEmpty     // 빈 값일 때 거름
            }
            .distinctUntilChanged()     // 중복값 제외
    }
}
