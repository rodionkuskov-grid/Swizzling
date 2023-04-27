//
//  PushNotificationManager.swift
//  Swizzling
//
//  Created by Rodion Kuskov on 4/1/23.
//

import Foundation
import UserNotifications

class PushNotificationManager {
    static func swizzleWillPresentNotification() {
        guard
            let originalNotificationCenterClass = object_getClass(UNUserNotificationCenter.current().delegate),
            let originalNotificationCenterDelegate = UNUserNotificationCenter.current().delegate
        else { return }

        let originalWillPresentNotificationSelector = #selector(originalNotificationCenterDelegate.userNotificationCenter(_:willPresent:withCompletionHandler:))

        
        guard
            let originalMethod = class_getInstanceMethod(originalNotificationCenterClass, originalWillPresentNotificationSelector),
            let customMethod = class_getInstanceMethod(PushNotificationManager.self, #selector(PushNotificationManager.swizzledWillPresentNotification(_:willPresent:withCompletionHandler:)))
        else { return }

        method_exchangeImplementations(originalMethod, customMethod)
    }

    @objc dynamic func swizzledWillPresentNotification(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Calling swizzled will present notification")
        let userInfo = notification.request.content.userInfo
        print("Info: \(userInfo)")
        completionHandler([.badge, .sound, .banner])

        swizzledWillPresentNotification(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
}
