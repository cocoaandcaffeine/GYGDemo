//
//  TableViewCellProviding.swift
//  GYGDemo
//
//  Created by Gert Andreas on 27.08.18.
//  Copyright © 2018 Gert Andreas. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCellProviding {
    func provideCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}
