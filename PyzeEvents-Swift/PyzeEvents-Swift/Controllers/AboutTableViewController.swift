//
//  AboutTableViewController.swift
//  PyzeEvents-Swift
//
//  Created by Ramachandra Naragund on 11/12/15.
//  Copyright © 2015 Pyze. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = ["pyze.com","Jobs At Pyze"][indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("webviewvc") as! PyzeWebViewController
            
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
        if indexPath.row == 1 {
            
            let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("jobsvc") as! JobsViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
  
}
