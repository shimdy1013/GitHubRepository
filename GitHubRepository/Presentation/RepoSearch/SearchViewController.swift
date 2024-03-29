//
//  SearchViewController.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/07.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, UITableViewDelegate {
    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let listView = SearchListView()
        
    let alertActionTapped = PublishRelay<AlertAction>()

    var finalData: [SearchRepositoryCellData] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
        
        listView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        let repoResult = searchBar.shouldLoadResult
            .flatMapLatest { query in
                SearchRepositoryNetwork().searchRepository(query: query)
            }
            .share()
        
        let repoValue = repoResult
            .compactMap { result -> SearchRepository? in
                guard case .success(let value) = result else {
                    return nil
                }
                return value
            }
        
        let repoError = repoResult
            .compactMap { result -> String? in
                guard case .failure(let error) = result else {
                    return nil
                }
                return error.localizedDescription
            }
        
        let cellData = repoValue
            .map { data -> [SearchRepositoryCellData] in
                return data.items
                    .map { item in
                        let avatarURL = URL(string: item.owner?.avatarURL ?? "")
                        return SearchRepositoryCellData(avatarURL: avatarURL, fullName: item.fullName, description: item.description, language: item.language, stargazersCount: item.stargazersCount, updatedAt: item.updatedAt)
                    }
            }
        
        let alertSheetForSorting = listView.headerView.sortButtonTapped
            .map { _ -> Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = repoError
            .map { message -> Alert in
                return (
                    title: "오류",
                    message: "예상치 못한 오류가 발생하였습니다. \(message)",
                    actions: [.confirm],
                    style: .alert)
            }
        
        Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: alertActionTapped)
            .disposed(by: disposeBag)
        
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
                cellData,
                sortedtype
            ) { data, type -> [SearchRepositoryCellData] in
                switch type {
//                case .title:
//                    return data.sorted { $0.fullName ?? "" < $1.fullName ?? ""}
//                    //return data.sorted { $0.title ?? "" < $1.title ?? "" }
//                case .datetime:
//                    return data.sorted { $0.updatedAt ?? Date() > $1.updatedAt ?? Date()}
//                    //return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date()}
//                default:
//                    return data
                case .title:
                    self.finalData = data.sorted { $0.fullName ?? "" < $1.fullName ?? ""}
                    return self.finalData
                    //return data.sorted { $0.title ?? "" < $1.title ?? "" }
                case .datetime:
                    self.finalData = data.sorted { $0.updatedAt ?? Date() > $1.updatedAt ?? Date()}
                    return self.finalData
                    //return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date()}
                default:
                    self.finalData = data
                    return self.finalData
                }
            }
            .bind(to: listView.cellData)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
        title = "GitHub Repository 검색"
    }
    
    private func layout() {
        [searchBar, listView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fullName = finalData[indexPath.row].fullName
        if let url = URL(string: "https://github.com/\(fullName ?? "")") {
            UIApplication.shared.open(url)
        }
        print(fullName ?? "")
    }
}

extension SearchViewController {
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible {
        case title, datetime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .datetime:
                return "Datetime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime:
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    
    func presentAlertController<Action: AlertActionConvertible>(_ alertController: UIAlertController, actions: [Action]) -> Signal<Action> {
        if actions.isEmpty { return .empty() }
        return Observable
            .create { [weak self] observer in
                guard let self = self else { return Disposables.create() }
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(
                            title: action.title,
                            style: action.style,
                            handler: { _ in
                                observer.onNext(action)
                                observer.onCompleted()
                            }
                        )
                    )
                }
                self.present(alertController, animated: true, completion: nil)
                return Disposables.create {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
