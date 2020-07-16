//
//  AppDelegate.swift
//  PinpointPushNotifications
//
//  Created by Law, Michael on 1/22/20.
//  Copyright © 2020 Lawmicha. All rights reserved.
//

import UIKit
import UserNotifications
import AWSPinpoint


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var pinpoint: AWSPinpoint?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for custormization after application launch.
        AWSDDLog.sharedInstance.logLevel = .verbose
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance)

        // AWSPinpoint high level client initialization
        let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions)
        pinpointConfiguration.debug = true // Make sure to set debug mode to use APNS sandbox
        pinpoint = AWSPinpoint(configuration: pinpointConfiguration)

        // Because we have initialized the high level client, simply access the low level client
        let serviceSDK = pinpoint?.targetingService

        // example
        do {
            let request = AWSPinpointTargetingPutEventsRequest()!
            request.applicationId = "350311e0ea123123123123" // replace with configuration appId
            serviceSDK?.putEvents(request)
        } catch {
            print("Failed")
        }

        // Present the user with a request to authorize push notifications
        //registerForPushNotifications()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: Remote Notifications Lifecycle
    func application(_ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")

        // Register the device token with Pinpoint as the endpoint for this user
        pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }

    func application(_ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if (application.applicationState == .active) {
            let alert = UIAlertController(title: "Notification Received",
                                          message: userInfo.description,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            UIApplication.shared.keyWindow?.rootViewController?.present(
                alert, animated: true, completion:nil)
        }

      pinpoint!.notificationManager.interceptDidReceiveRemoteNotification(
          userInfo, fetchCompletionHandler: completionHandler)
    }

    // MARK: Push Notification methods

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options:[.alert, .sound, .badge]) {[weak self] granted, error in
                print("Permission granted: \(granted)")
                guard granted else { return }

                // Only get the notification settings if user has granted permissions
                self?.getNotificationSettings()
        }

    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }

            DispatchQueue.main.async {
                // Register with Apple Push Notification service
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

