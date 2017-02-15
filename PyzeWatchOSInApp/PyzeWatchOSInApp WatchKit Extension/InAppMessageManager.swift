import Foundation
import Pyze

public class InAppMessageManager {
    
    private var headers:[Any] = []
    private var isRequested:Bool = false

    
    private var messageActiveIndex:Int {
        get {
            return self.messageActiveIndex
        }
        
        set {
            self.messageActiveIndex = (newValue < self.headers.count && newValue > 0) ? newValue : messageActiveIndex
        }
    }
    
    
    
    public var activeInAppMessageType:PyzeInAppMessageType {
        set {
            self.activeInAppMessageType = newValue
        }
        get {
            return self.activeInAppMessageType
        }
    }
    
    public var inAppMessageCount: Int = 0
    
    // MARK: - Init
    
    private init() {
        
    }
    
    
    // MARK: - Shared manager
    
    public static let sharedManager : InAppMessageManager = {
        let sharedManagerInstance = InAppMessageManager()
        sharedManagerInstance.messageActiveIndex = -1;
        return sharedManagerInstance
    } ()
    
    // MARK: - Public methods
    
    public func countNewUnFetched(completionhandler: @escaping (Int)->Void) -> Void {
        Pyze.countNewUnFetched { (count) in
            completionhandler(count)
        }
    }
    
    public func updateIndex(shouldIncrement:Bool) {
        self.messageActiveIndex = (shouldIncrement == false) ? self.messageActiveIndex - 1 : self.messageActiveIndex + 1
    }
    
    public func isLastMessage() -> Bool {
        let isLast = (self.messageActiveIndex == (self.inAppMessageCount - 1)) ? true : false
        return isLast
    }
    
    public func nextMessage (completionhandler:  @escaping (InAppModel)->Void) {
        self.updateIndex(shouldIncrement: true)
        self.fetchMessage { (inAppModelObj) in
            completionhandler(inAppModelObj)
        }
    }
    
    public func previousMessage (completionhandler:  @escaping (InAppModel)->Void) {
        self.updateIndex(shouldIncrement: false)
        self.fetchMessage { (inAppModelObj) in
            completionhandler(inAppModelObj)
        }
    }
    
    public func fetchHeaders(type:PyzeInAppMessageType, completionhandler: @escaping ()->Void) {
        
        /* Resetting content */
        self.messageActiveIndex = -1
        self.activeInAppMessageType = type
        self.headers.removeAll()
        /* Resetting content */
        
        if self.isRequested == false {
            
            self.isRequested = true
            Pyze.getMessageHeaders(for: type) { (messageHeadres) in
                
                self.isRequested = false
                if let mHeaders = messageHeadres {
                    self.inAppMessageCount = mHeaders.count
                    for headerDict in mHeaders {
                        self.headers.append(headerDict)
                        completionhandler()
                    }
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func messageHeader() -> [String:Any]? {
        let header = self.headers[messageActiveIndex] as? [String:Any]
        return header ?? nil
    }
    
    private func fetchMessage(completionhandler:  @escaping (InAppModel)->Void) {
        
        if let dict = self.messageHeader() {
            Pyze.getMessageBody(withCampaignID: (dict["cid"] as? String ?? ""), andMessageID: (dict["mid"] as? String ?? "")) { (messageBody) in
                
                if let messageBody = messageBody {
                    
                    if let payload : [String:Any] = messageBody["payload"] as? [String:Any] {
                        let inAppObj:InAppModel = InAppModel.init(dictionary: payload, loadDefaults: false)
                        completionhandler(inAppObj)
                    }
                }
            }
        }
    }
}

// MARK: - Class InAppTemplateData

public class InAppTemplateData {
    
    var imageURL: String = ""
    var imageWidth: Int = 0
    var imageHeight: Int = 0
    var optionalBase64Image: String = ""
    var titleColorHex: String = ""
    var msgColor: String = ""
    var buttons = [Any]()
    var templateID: String = ""
    var canvasBgColor: String = ""
    var isTextOverlapsImage: Bool = false
    
    
    init(dictionary inDictionary: [String : Any], loadDefaults load: Bool) {
        
        self.imageURL = inDictionary["imageSourceURL"] as? String ?? ""
        self.optionalBase64Image = inDictionary["optionalBase64Image"] as? String ?? ""
        self.titleColorHex = inDictionary["titleColor"] as? String ?? ""
        self.msgColor = inDictionary["msgColor"] as? String ?? ""
        self.imageWidth = Int(inDictionary["imageWidth"] as? String ?? "") ?? 0
        self.imageHeight = Int(inDictionary["imageHeight"] as? String ?? "") ?? 0
        self.buttons = inDictionary["buttons"] as? [Any] ?? []
        self.canvasBgColor = inDictionary["canvas_bgColor"] as? String ?? ""
    }
}

// MARK: - Class InAppModel

public class InAppModel: NSObject {
    
    var msg = ""
    var title = ""
    var templateID = ""
    var templateData: InAppTemplateData!
    
    init(dictionary inDictionary: [String : Any], loadDefaults load: Bool) {
        
        self.msg = inDictionary["msg"] as? String ?? ""
        self.title = inDictionary["title"] as? String ?? ""
        self.templateID = inDictionary["templateId"] as? String ?? ""
        var result = false
        if (self.templateID == "p_temp_1") {
            result = true
        }
        do {
            if let templateData: String = inDictionary["templateData"] as? String {
                if let d:Data = templateData.data(using: .utf8) {
                    do {
                        let template: [String:Any]? = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                        self.templateData = InAppTemplateData(dictionary: template ?? [:], loadDefaults: load)
                        self.templateData.isTextOverlapsImage = result
                    } catch {
                        print("Error in parsing")
                    }
                }
            }
        }
    }
}



