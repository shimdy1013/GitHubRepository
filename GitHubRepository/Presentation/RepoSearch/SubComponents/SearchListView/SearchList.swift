//
//  SearchList.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/07.
//

import RxSwift
import RxCocoa
import UIKit

class SearchListView : UITableView {
    let disposeBag = DisposeBag()
    
    let headerView = FilterView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
        )
    )
    let cellData = PublishSubject<[SearchRepositoryCellData]>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        bind()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // cellForRowAt
    private func bind() {
        cellData
            .asDriver(onErrorJustReturn: [])
            .drive(self.rx.items) { tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "SearchListCell", for: index) as! SearchListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(SearchListCell.self, forCellReuseIdentifier: "SearchListCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
}
