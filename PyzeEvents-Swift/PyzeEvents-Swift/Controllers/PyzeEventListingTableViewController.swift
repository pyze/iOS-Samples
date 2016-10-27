//
//  PyzeEventListingTableViewController.swift
//  PyzeEvents-Swift
//
//  Created by Ramachandra Naragund on 10/12/15.
//  Copyright © 2015 Pyze. All rights reserved.
//

import UIKit
import Pyze

class PyzeEventListingTableViewController: UITableViewController, PyzeClassParserDelegate {

   let openextCellIdentifier = "eventListingCell"
    
    let detailSBIdentifier = "detailMethodVC"
    
    var listingItems = [PyzeTableViewSrc]()
    
    var parser : PyzeClassParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parser = PyzeClassParser(delegate: self)
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
        return listingItems.count
    }

    func didParserCompleteParsing(menuItems: [AnyObject]!) {
        listingItems = menuItems as! Array
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(openextCellIdentifier, forIndexPath: indexPath)
       
        let src = listingItems[indexPath.row]
        cell.textLabel?.text = src.title
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destinationViewController is PyzeEventDetailTableViewController {
            let destinationVC =  segue.destinationViewController as! PyzeEventDetailTableViewController
            
            destinationVC.listingItems = self.listingItems
            
            destinationVC.row = self.tableView.indexPathForSelectedRow!.row
        }
    }
    

}
