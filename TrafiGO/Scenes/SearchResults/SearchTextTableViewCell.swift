//
//  searchTableDelegate.swift
//  TrafiGO
//
//  Created by Darek on 24/09/2021.
//

import Foundation
import UIKit
import Combine


class SearchTextTableViewCell: UITableViewCell {

    init(style: UITableViewCell.CellStyle) {
        super.init(style: .default, reuseIdentifier: "searchCell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
