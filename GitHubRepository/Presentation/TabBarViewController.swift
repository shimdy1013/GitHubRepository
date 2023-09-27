//
//  MainViewController.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/07.
//

import UIKit
import RxSwift
import RxCocoa

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repoListVC = RepositoryListViewController()
        let repoSearchVC = SearchViewController()
        
        let repoSearchViewModel = SearchViewModel()
        //repoSearchVC.bind(repoSearchViewModel)
        
        repoSearchVC.view.backgroundColor = .white
        
        repoListVC.title = "Apple"
        repoSearchVC.title = "Search"
        
        repoListVC.tabBarItem.image = UIImage.init(systemName: "apple.logo")
        repoSearchVC.tabBarItem.image = UIImage.init(systemName: "magnifyingglass.circle.fill")
        
        setViewControllers([repoListVC, repoSearchVC], animated: false)
//        let navigationRepoList = UINavigationController(rootViewController: repoListVC)
//        let naviagtionRepoSearch = UINavigationController(rootViewController: repoSearchVC)
//
//        setViewControllers([navigationRepoList, naviagtionRepoSearch], animated: false)
    }
}
