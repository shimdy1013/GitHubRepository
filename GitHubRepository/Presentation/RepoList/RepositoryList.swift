////
////  RepositoryList.swift
////  GitHubRepository
////
////  Created by 심두용 on 2023/06/07.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//class RepositoryList: UITableView {
//    let disposeBag = DisposeBag()
//    
//    let headerView = FilterView(
//        frame: CGRect(
//            origin: .zero,
//            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
//        )
//    )
//
//    let cellData = PublishSubject<[Repository]>()
//
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//        
//        bind()
//        attribute()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func bind() {
//        cellData
//            .asDriver(onErrorJustReturn: [])    // 에러 시 빈 배열 반환
//            .drive(self.rx.items) { tv, row, data in
//                let index = IndexPath(row: row, section: 0)
//                let cell = tv.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: index) as! RepositoryListCell
//                //cell.setData(data)
//                return cell
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    private func attribute() {
//        self.backgroundColor = .white
//        self.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
//        self.separatorStyle = .singleLine
//        self.rowHeight = 100
//        self.tableHeaderView = headerView
//    }
//}
