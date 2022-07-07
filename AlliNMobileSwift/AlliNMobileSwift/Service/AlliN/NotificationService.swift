//
//  NotificationService.swift
//  AlliNMobileSwift
//
//  Created by Lucas Rodrigues on 09/06/17.
//  Copyright © 2017 Lucas Rodrigues. All rights reserved.
//
class NotificationService : BaseService {
    func view(id: String) {
        guard let data = Data.transform(array: [
            (key: BodyConstant.ID, value: id),
            (key: BodyConstant.DEVICE_TOKEN, value: AlliNPush.getInstance().deviceToken)
        ]) else {
            return;
        }
        
        HttpRequest.post(RouteConstant.NOTIFICATION_VIEW, data: data);
    }
}
