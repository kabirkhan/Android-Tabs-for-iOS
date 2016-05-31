//
//  FirstTableViewController.swift
//  PagingTabBar
//
//  Created by Kabir Khan on 5/29/16.
//  Copyright © 2016 Kabir Khan. All rights reserved.
//

import UIKit

class FirstTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 30
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    cell.textLabel?.text = "test"
    
    return cell
  }
  
}
