import Foundation
import WatchKit
import Pyze

class InAppMessageinterfaceController : WKInterfaceController {
    
    @IBOutlet var imageView: WKInterfaceImage!
    @IBOutlet var contentLabel: WKInterfaceLabel!
    @IBOutlet var titleLabel: WKInterfaceLabel!
    
    @IBOutlet var option1: WKInterfaceButton!
    @IBOutlet var option2: WKInterfaceButton!
    @IBOutlet var option3: WKInterfaceButton!
    
    @IBOutlet var showNextButton: WKInterfaceButton!
    
    var buttonArray:[Any] = []
    var isShowNextTapped = true
    
    // MARK: - View life cycle
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.fetchMessage()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didAppear() {
        super.didAppear()
        self.isShowNextTapped = false
        
        let shouldHideNext = InAppMessageManager.sharedManager.isLastMessage() == true ? true : false
        self.showNextButton.setHidden(shouldHideNext)
    }
    
    
    override func willDisappear() {
        super.willDisappear()
        if self.isShowNextTapped == false {
            InAppMessageManager.sharedManager.updateIndex(shouldIncrement: false) //Decrementing the message index on visiting previous message by tapping back
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    
    // MARK: - Private methods
    
    func fetchMessage() {
        
        InAppMessageManager.sharedManager.nextMessage { (inAppModelObj) in
            self.buttonArray = inAppModelObj.templateData.buttons
            DispatchQueue.main.async {
                self.contentLabel.setText(inAppModelObj.msg)
                self.configureButtons()
                self.imageView.setImageWithUrl(urlString: inAppModelObj.templateData.imageURL)
            }
        }
    }

    
    func configureButtons() {
        
        switch self.buttonArray.count {
        case 0 :
            self.option1.setHidden(true)
            self.option2.setHidden(true)
            self.option3.setHidden(true)
            
        case 1 :
            self.option1.setHidden(false)
            
            let button1 = self.buttonArray[self.buttonArray.startIndex] as? [String] ?? []
            self.option1.setTitle(button1[self.buttonArray.startIndex])
            
        case 2 :
            self.option1.setHidden(false)
            self.option2.setHidden(false)
            
            let button1 = self.buttonArray[self.buttonArray.startIndex] as? [String] ?? []
            self.option1.setTitle(button1[self.buttonArray.startIndex])
            
            let button2 = self.buttonArray[self.buttonArray.index(self.buttonArray.startIndex, offsetBy: 1)] as? [String] ?? []
            self.option2.setTitle(button2[self.buttonArray.startIndex])
            
        case 3 :
            self.option1.setHidden(false)
            self.option2.setHidden(false)
            self.option3.setHidden(false)
            
            let button1 = self.buttonArray[self.buttonArray.startIndex] as? [String] ?? []
            self.option1.setTitle(button1[self.buttonArray.startIndex])
            
            let button2 = self.buttonArray[self.buttonArray.index(self.buttonArray.startIndex, offsetBy: 1)] as? [String] ?? []
            self.option2.setTitle(button2[self.buttonArray.startIndex])
            
            let button3 = self.buttonArray[self.buttonArray.index(self.buttonArray.startIndex, offsetBy: 2)] as? [String] ?? []
            self.option1.setTitle(button3[self.buttonArray.startIndex])
            
        default: print("no buttons hidden")
        }
    }
    
    // MARK: - Action methods
    
    @IBAction func didTapOption1() {
        if self.buttonArray.count >= 1 {
            let button1 = self.buttonArray[self.buttonArray.startIndex] as? [String] ?? []
            print("\(button1[self.buttonArray.startIndex]) SELECTED")
        }
    }
    
    @IBAction func didTapOption2() {
        if self.buttonArray.count >= 2 {
            let button2 = self.buttonArray[self.buttonArray.index(self.buttonArray.startIndex, offsetBy: 1)] as? [String] ?? []
            print("\(button2[self.buttonArray.startIndex]) SELECTED")
        }
    }
    
    @IBAction func didTapOption3() {
        if self.buttonArray.count >= 3 {
            let button3 = self.buttonArray[self.buttonArray.index(self.buttonArray.startIndex, offsetBy: 2)] as? [String] ?? []
            print("\(button3[self.buttonArray.startIndex]) SELECTED")
        }
    }
    
    
    @IBAction func didTapShowNext() {
        self.isShowNextTapped = true
        self.pushController(withName: "InAppMessageUIController", context:nil)
    }
    
    @IBAction func didTapCloseInApp() {
        popToRootController()
    }
}

// MARK: - Image extension

public extension WKInterfaceImage {
    
    public func setImageWithUrl(urlString:String) {
        
        if let url:NSURL = NSURL(string: urlString) {
            let request:URLRequest = URLRequest(url: url as URL)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if error == nil {
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.setImage(image)
                        }
                    }
                }
                }.resume()
        }
    }
}
