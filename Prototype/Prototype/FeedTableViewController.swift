//
//  FeedTableViewController.swift
//  Prototype
//
//  Created by Raphael Silva on 24/06/2020.
//  Copyright © 2020 Raphael Silva. All rights reserved.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}

final class FeedTableViewController: UITableViewController {

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "FeedImageCellReuseIdentifier", for: indexPath)
    }
}
