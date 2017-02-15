import WatchKit
import Foundation
import Pyze

class InterfaceController: WKInterfaceController {
    
    
    @IBOutlet var unreadButton: WKInterfaceButton!
    
    // MARK: - View life cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        InAppMessageManager.sharedManager.countNewUnFetched { (count) in
            DispatchQueue.main.async {
                self.unreadButton.setTitle("Unread (\(count))")
            }
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didAppear() {
        super.didAppear()
    }
    
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    // MARK: - Action methods
    
    @IBAction func showUnread() {
        InAppMessageManager.sharedManager.fetchHeaders(type: .typeUnread, completionhandler: {
            
            DispatchQueue.main.async {
                self.pushController(withName: "InAppMessageUIController", context:nil)
            }
            
        })
    }
    
    @IBAction func showRead() {
        InAppMessageManager.sharedManager.fetchHeaders(type: .typeRead, completionhandler: {
            
            DispatchQueue.main.async {
                self.pushController(withName: "InAppMessageUIController", context:nil)
            }
            
        })
    }
    
    @IBAction func showAll() {
        InAppMessageManager.sharedManager.fetchHeaders(type: .typeAll, completionhandler: {
            
            DispatchQueue.main.async {
                self.pushController(withName: "InAppMessageUIController", context:nil)
            }
        })
    }
}
