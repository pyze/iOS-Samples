//
//  ViewController.swift
//  PyzeEvents-Swift
//
//  Created by Ramachandra Naragund on 10/12/15.
//  Copyright © 2015 Pyze. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PyzeInAppMessageHandlerDelegate {

    @IBOutlet weak var showInAppButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Pyze.addBadge(showInAppButton)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showInAppMessage(sender: UIButton)
    {
        Pyze.showUnreadInAppNotificationUI(self)
    }

    func didUserClickedOnInAppMessageButtonWithID(buttonID: Int, buttonTitle title: String!, containingURLInfo urlInfo: AnyObject!, withDeepLinkStatus status: PyzeDeepLinkStatus) {
         print("Button Index = %d, button title = %@ and urlInfo = %@", buttonID, title, urlInfo);
    }
}

