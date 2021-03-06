//
//  PushService.swift
//  AlliNMobileSwift
//
//  Created by Lucas Rodrigues on 13/06/17.
//  Copyright © 2017 Lucas Rodrigues. All rights reserved.
//

import Foundation
import UserNotifications

class PushService {
    @available(iOS 10.0, *)
    func extensionDidReceive(_ request: UNNotificationRequest, contentHandler: @escaping (UNNotificationContent) -> Void) {
        if let notificationContent = request.content.mutableCopy() as? UNMutableNotificationContent {
            UNNotificationAttachment.image(notificationContent.userInfo as NSDictionary, callback: { (attachments) in
                if let attachments = attachments {
                    notificationContent.attachments = attachments
                    
                    contentHandler(notificationContent)
                } else {
                    contentHandler(notificationContent)
                }
            })
        }
    }
    
    func receiveNotification(_ alliNDelegate: AlliNDelegate?, userInfo: NSDictionary) {
        if (UIApplication.shared.applicationState == .active) {
            self.showAlert(userInfo);
        } else {
            self.handleRemoteNotification(userInfo, showAlertIfHave: true);
        }
    }
    
    func showAlert(_ userInfo: NSDictionary) {
        if let aps = userInfo.object(forKey: NotificationConstant.APS) as? NSDictionary {
            let alert = aps.object(forKey: NotificationConstant.ALERT) as! NSDictionary;
            let title = alert.object(forKey: NotificationConstant.TITLE) as! String;
            let body = alert.object(forKey: NotificationConstant.BODY) as! String;
            
            if let delegate = AlliNPush.getInstance().getAlliNDelegate() {
                let customAlert = delegate.onShowAlert(title: title, body: body, callback: {
                    self.handleRemoteNotification(userInfo, viewController: self.topViewController);
                });
                
                if (!customAlert) {
                    let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert);
                    
                    alertController.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil));
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil);
                        
                        self.handleRemoteNotification(userInfo, viewController: self.topViewController);
                    }));
                    
                    self.topViewController.present(alertController, animated: true, completion: nil);
                }
            } else {
                let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert);
                
                alertController.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil));
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alertController.dismiss(animated: true, completion: nil);
                    
                    self.handleRemoteNotification(userInfo, viewController: self.topViewController);
                }));
                
                self.topViewController.present(alertController, animated: true, completion: nil);
            }
        }
    }
    
    @available(iOS 10.0, *)
    func showNotification(_ userInfo: NSDictionary) {
        if let aps = userInfo.object(forKey: NotificationConstant.APS) as? NSDictionary {
            let alert = aps.object(forKey: NotificationConstant.ALERT) as! NSDictionary
            let title = alert.object(forKey: NotificationConstant.TITLE) as! String
            let body = alert.object(forKey: NotificationConstant.BODY) as! String
            
            let id = userInfo.object(forKey: NotificationConstant.ID) ?? 1
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: Date(timeInterval: 61.0, since: Date()).dateComponents, repeats: false)
                       
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = title
            notificationContent.body = body
            notificationContent.sound = UNNotificationSound.default
            notificationContent.categoryIdentifier = NotificationConstant.ALLIN_CATEGORY
            notificationContent.badge = 1

            let notificationRequest = UNNotificationRequest(identifier: "\(id)-\(NotificationConstant.ALLIN_REQUEST)", content: notificationContent, trigger: notificationTrigger)
            
            UNUserNotificationCenter.current().add(notificationRequest)
        }
    }
    
    func clickNotification(_ userInfo: NSDictionary) {
        if let aps = userInfo.object(forKey: NotificationConstant.APS) as? NSDictionary {
            let alert = aps.object(forKey: NotificationConstant.ALERT) as! NSDictionary
            let title = alert.object(forKey: NotificationConstant.TITLE) as! String
            let body = alert.object(forKey: NotificationConstant.BODY) as! String
            
            if let delegate = AlliNPush.getInstance().getAlliNDelegate() {
                let customAlert = delegate.onShowAlert(title: title, body: body, callback: {
                    self.handleRemoteNotification(userInfo, viewController: self.topViewController);
                });
                
                if (!customAlert) {
                    let alertController = UIAlertController(title: title, message: body, preferredStyle: .alert);
                    
                    alertController.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil));
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        alertController.dismiss(animated: true, completion: nil);
                        
                        self.handleRemoteNotification(userInfo, viewController: self.topViewController);
                    }));
                    
                    self.topViewController.present(alertController, animated: true, completion: nil);
                }
            } else {
                self.handleRemoteNotification(userInfo, viewController: self.topViewController)
            }
        }
    }
    
    private var topViewController: UIViewController {
        var topController = UIApplication.shared.keyWindow?.rootViewController;
        
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController;
        }
        
        return topController!;
    }
    
    private func handleRemoteNotification(_ userInfo: NSDictionary, showAlertIfHave: Bool = false, viewController: UIViewController? = nil) {
        UIApplication.shared.applicationIconBadgeNumber = 0;
        
        let scheme = userInfo.object(forKey: NotificationConstant.URL_SCHEME) as? String != nil;
        
        if (scheme) {
            if let viewId = userInfo.object(forKey: NotificationConstant.VIEW_ID) as? String {
                NotificationService().view(id: viewId);
            }
            
            let controller = viewController == nil ? self.topViewController : viewController!;
            
            self.start(userInfo, showAlertIfHave: showAlertIfHave, viewController: controller, scheme: scheme)
        }
    }
    
    private func getKey(_ userInfo: NSDictionary, key: String) -> String? {
        if userInfo[key] != nil {
            if let string = userInfo.value(forKey: key) as? String {
                return string
            } else if let int = userInfo.value(forKey: key) as? Int {
                return "\(int)"
            }
        }
        
        return nil
    }
    
    private func start(_ userInfo: NSDictionary, showAlertIfHave: Bool = false, viewController: UIViewController, scheme: Bool) {
        if (showAlertIfHave) {
            self.showAlert(userInfo);
        } else {
            self.startScheme(userInfo);
        }
    }
    
    private func startScheme(_ userInfo: NSDictionary) {
        if #available(iOS 10.0, *) {
            if let scheme = userInfo.object(forKey: NotificationConstant.URL_SCHEME) as? String, let url = URL(string: scheme) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        } else {
            if let scheme = userInfo.object(forKey: NotificationConstant.URL_SCHEME) as? String, let url = URL(string: scheme) {
                UIApplication.shared.openURL(url);
            }
        }
    }
    
    private func showViewController(viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController);
        
        self.topViewController.present(navigationController, animated: true, completion: nil);
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
