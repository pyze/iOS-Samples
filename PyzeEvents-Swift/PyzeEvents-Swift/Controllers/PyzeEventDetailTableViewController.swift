//
//  PyzeEventDetailTableViewController.swift
//  PyzeEvents-Swift
//
//  Created by Ramachandra Naragund on 10/12/15.
//  Copyright © 2015 Pyze. All rights reserved.
//

import UIKit

class PyzeEventDetailTableViewController: UITableViewController {

    var listingItems = [PyzeTableViewSrc]()
    
    var row : Int = 0
    
    let textCellIdentifier = "detailMethodCell"
    
    var indexPathToPerform:NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listingItems[row].items.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath)

        let src = listingItems[row]
        
        let stringVal = src.items[indexPath.row] as! String
        
        let array = stringVal.componentsSeparatedByString(":")

        var strResult = array.joinWithSeparator(" :\n") as NSString

        let range =  strResult.rangeOfString("\n", options: NSStringCompareOptions.BackwardsSearch)

        if range.location != NSNotFound {
            strResult = strResult.stringByReplacingCharactersInRange(range, withString: "")
        }
        
        cell.textLabel?.text = strResult as String
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.indexPathToPerform = NSIndexPath.init(forRow: indexPath.row, inSection: self.row)
        
        ALEventsTest.executeTestEventsInBackgroundWithIndexPath(indexPathToPerform, shouldExecute: false) {
            (result:[AnyObject]!) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let src =  self.listingItems[self.row]
                let methodname = src.items[indexPath.row] as! String
                
                let nextVc = self.storyboard?.instantiateViewControllerWithIdentifier("eventvalvc") as! EventListingTableViewController
                
                
                nextVc.modelData = result as Array
                nextVc.methodName = methodname
                nextVc.indexpath = self.indexPathToPerform
                
                self.navigationController?.pushViewController(nextVc, animated: true)
            })
            
        }
    }
    
}
