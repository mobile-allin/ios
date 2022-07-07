//
//  AlliNPush.swift
//  AlliNMobileSwift
//
//  Created by Lucas Rodrigues on 09/06/17.
//  Copyright © 2017 Lucas Rodrigues. All rights reserved.
//
import UserNotifications

public class AlliNPush: NSObject {
    private static var alliNPush: AlliNPush? = nil;

    public static func getInstance() -> AlliNPush {
        if (AlliNPush.alliNPush == nil) {
            AlliNPush.alliNPush = AlliNPush()
            AlliNPush.registerForPushNotifications()
        }
        
        return AlliNPush.alliNPush!
    }
    
    public static func registerForPushNotifications() {
        if (AlliNPush.alliNPush == nil) {
            AlliNPush.alliNPush = AlliNPush()
        }
        
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in };
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil));
        }
        
        UIApplication.shared.registerForRemoteNotifications();
    }
    
    @available(iOS 10.0, *)
    public func willPresent(notification: UNNotification) {
        self.willPresent(userInfo: notification.request.content.userInfo as NSDictionary)
    }
    
    @available(iOS 10.0, *)
    public func willPresent(userInfo: NSDictionary) {
        if (UIApplication.shared.applicationState == .active) {
            PushService().showAlert(userInfo);
        } else {
            PushService().showNotification(userInfo);
        }
    }
    
    @available(iOS 10.0, *)
    public func didReceive(response: UNNotificationResponse) {
        self.didReceive(userInfo: response.notification.request.content.userInfo as NSDictionary)
    }
    
    public func didReceive(userInfo: NSDictionary) {
        PushService().clickNotification(userInfo)
    }
    
    @available(iOS 10.0, *)
    public func extensionDidReceive(_ request: UNNotificationRequest, contentHandler: @escaping (UNNotificationContent) -> Void) {
        PushService().extensionDidReceive(request, contentHandler: contentHandler)
    }
    
    public func registerDeviceToken(deviceToken: Data) {
        let configuration = try! ConfigurationEntity(deviceToken: deviceToken)
        
        AlliNPush.getInstance().setDeviceToken(configuration.deviceToken)
        AlliNPush.getInstance().configure(configuration);
    }
    
    public var deviceToken : String {
        return DeviceService().deviceToken;
    }
    
    public func setDeviceToken(_ deviceToken: String) {
        let sharedPreferences = PreferencesManager();
        
        sharedPreferences.store(deviceToken, key: PreferencesConstant.KEY_DEVICE_ID);
    }
    
    public var identifier : String {
        return DeviceService().identifier;
    }
    
    public func logout(email: String, completion: ((Any?, HttpRequestError?) -> Void)? = nil) {
        DeviceService().logout(email, completion: completion);
    }
    
    public func sendList(name: String, columnsAndValues: NSDictionary) {
        DeviceService().sendList(nameList: name, columnsAndValues: columnsAndValues);
    }
    
    public func receiveNotification(_ alliNDelegate: AlliNDelegate?, userInfo: NSDictionary) {
        PushService().receiveNotification(alliNDelegate, userInfo: userInfo);
    }

    public func configure(_ configuration: ConfigurationEntity, completion: ((Any?, HttpRequestError?) -> Void)? = nil) {
        ConfigurationService().configure(configuration, completion: completion);
    }
    
    public func showAlertScheme(_ show: Bool) {
        DeviceService().showAlertScheme(show);
    }
    
    public func setBarButtonColor(hexColor: String) {
        DeviceService().barButtonColor(hexColor);
    }
    
    private var alliNDelegate : AlliNDelegate?;
    
    public func setAlliNDelegate(alliNDelegate : AlliNDelegate?) {
        self.alliNDelegate = alliNDelegate;
    }
    
    public func getAlliNDelegate() -> AlliNDelegate? {
        return self.alliNDelegate;
    }
}
