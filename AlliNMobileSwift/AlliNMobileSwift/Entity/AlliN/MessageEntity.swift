//
//  MessageEntity.swift
//  AlliNMobileSwift
//
//  Created by Lucas Rodrigues on 05/06/17.
//  Copyright © 2017 Lucas Rodrigues. All rights reserved.
//
public class MessageEntity : NSObject, NSCoding {
    private static let ID_MESSAGE = "id";
    private static let READ = "read";
    
    var messageId: Int = 0;
    var viewId: String = "";
    var subject: String = "";
    var desc: String = "";
    var urlScheme: String = "";
    var action: String = "";
    var read: Bool = false;
    
    public override init() {
    }
    
    public init(userInfo: NSDictionary) {
        self.messageId = 0;
        self.subject = MessageEntity.getValue(key: NotificationConstant.SUBJECT, userInfo: userInfo);
        self.desc = MessageEntity.getValue(key: NotificationConstant.DESCRIPTION, userInfo: userInfo);
        self.urlScheme = MessageEntity.getValue(key: NotificationConstant.URL_SCHEME, userInfo: userInfo);
        self.action = MessageEntity.getValue(key: NotificationConstant.ACTION, userInfo: userInfo);
        self.read = false;
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.messageId =  aDecoder.decodeInteger(forKey: MessageEntity.ID_MESSAGE);
        self.viewId =  aDecoder.decodeObject(forKey: NotificationConstant.VIEW_ID) as! String;
        self.subject =  aDecoder.decodeObject(forKey: NotificationConstant.SUBJECT) as! String;
        self.desc =  aDecoder.decodeObject(forKey: NotificationConstant.DESCRIPTION) as! String;
        self.urlScheme =  aDecoder.decodeObject(forKey: NotificationConstant.URL_SCHEME) as! String;
        self.action =  aDecoder.decodeObject(forKey: NotificationConstant.ACTION) as! String;
        self.read =  aDecoder.decodeBool(forKey: MessageEntity.READ);
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.messageId, forKey: MessageEntity.ID_MESSAGE);
        aCoder.encode(self.viewId, forKey: NotificationConstant.VIEW_ID);
        aCoder.encode(self.subject, forKey: NotificationConstant.SUBJECT);
        aCoder.encode(self.desc, forKey: NotificationConstant.DESCRIPTION);
        aCoder.encode(self.urlScheme, forKey: NotificationConstant.URL_SCHEME);
        aCoder.encode(self.action, forKey: NotificationConstant.ACTION);
        aCoder.encode(self.read, forKey: MessageEntity.READ);
    }
    
    public static func getValue(key: String, userInfo: NSDictionary) -> String {
        if let value = userInfo.object(forKey: key) {
            return "\(value)";
        }
        
        return "";
    }
}
