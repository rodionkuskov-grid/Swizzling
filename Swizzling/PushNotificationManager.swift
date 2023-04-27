//
//  PushNotificationManager.swift
//  Swizzling
//
//  Created by Rodion Kuskov on 4/1/23.
//

import Foundation
import UserNotifications

typealias OriginalWillPresentNotificationMethodType = @convention(c) (AnyObject, Selector, UNUserNotificationCenter, UNNotification, @escaping (UNNotificationPresentationOptions) -> Void) -> Void

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

    @objc dynamic func swizzledWillPresentNotification(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        callOriginalMethod(center, willPresent: notification, withCompletionHandler: completionHandler)
        print("Calling swizzled will present notification")
        completionHandler([.badge, .sound, .banner])
    }

    private func callOriginalMethod(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let originalSelector = #selector(UNUserNotificationCenter.current().delegate?.userNotificationCenter(_:willPresent:withCompletionHandler:))
        let customWillPresentNotificationSelector = #selector(PushNotificationManager.swizzledWillPresentNotification(_:willPresent:withCompletionHandler:))
        
        // Returns bits of passed instance casted as OriginalWillPresentNotificationMethodType
        unsafeBitCast(
            class_getMethodImplementation(PushNotificationManager.self, customWillPresentNotificationSelector),
            to: OriginalWillPresentNotificationMethodType.self
        ) (self, originalSelector, center, notification, completionHandler)
    }
}
