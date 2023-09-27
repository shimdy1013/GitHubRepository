//
//  SearchListSelect.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/11.
//

import Foundation
import UIKit

class SearchListSelect: UIViewController, UITableViewDelegate {
    let listView = SearchListView()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ===============")
    }
}

