//
//  AlertActionConvertible.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/09.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
