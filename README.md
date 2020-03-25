# iOS-Push-Notifications

### Getting started with AWS Pinpoint Campaigns Push Notifications 

# What is it?

Pre-requiste
- Enrolled in Apple Developer Program
- Actual device to run app on, and its device UUID (http://whatsmyudid.com/)
- 

Steps to get Push Notifications with AWS Pinpoint Campaigns

1. Create new project

2. Pod dependencies. `pod init`, add AWSPinpoint pod, and install via `pod install`
```
AWS_SDK_VERSION = "2.12.6"
target 'PinpointPushNotifications' do
  use_frameworks! 
  pod "AWSPinpoint", "~> #{AWS_SDK_VERSION}"
end
```
2. `open <Project>.xcworkspace`. If using the sample app: `open PinpointPushNotifications.xcworkspace`

3. Under the target, select "Signing & Capabilities", update the bundle identifer to something unique and select your Apple Developer account for the Team.

4. In the app, it will already have Push Notifications added. On a new app, click `+ Capability` and add Push Notification. You can check it out in your Apple Developer 
    - Now tap the Capabilities tab and set the Background Modes switch On. Then check the Remote notifications option:

5. If everything is set up correctly, you should see your Identifer at the (Apple Developer Program)[https://developer.apple.com/account/resources/identifiers/list] under Identifers.

6. `amplify init`

7. `amplify add analytics`
```
? Provide your pinpoint resource name: iospushnotifications
Adding analytics would add the Auth category to the project if not already added.
? Apps need authorization to send analytics events. Do you want to allow guests and unauthenticated users to send analytics events? (we recommend you allow this when getting started) Ye
```

8. `amplify push`

9. drag `awsconfiguration.json` into project. copy as needed.

10. Go to AppDelegate and add the following code.

```
register
```

11. Add the following App delegates to listen onto 
```
did register
// pinpoint
```


13. Run the app, click on Allow when prompted to, and you should be able to see the device token printed out, and permissions granted


# Push Notifications

13. Go to https://developer.apple.com/account/ , "Certificates, Identifiers & Profiles", on the left side click on "Keys", click +, type in a name like "Push Notification Key", check off Apple Push Notification Service (APNs). Register and download the file. It should be in the format of `AuthKey_<Key ID>`

14. Go to your Membership Details page to get the Team ID.

15. `amplify notifications add`

```
8c8590431b3d:iOS-Push-Notifications mdlaw$ amplify notifications add
? Choose the push notification channel to enable. APNS
? Choose authentication method used for APNs Key
? The bundle id used for APNs Tokens:  <Your App's BundleID like com.yourname.projectname>
? The team id used for APNs Tokens:  XXXXXXXXX
? The key id used for APNs Tokens:  ABCDEXXXXX
? The key file path (.p8):  AuthKey_ABCDEXXXXX.p8
✔ The APNS channel has been successfully enabled.
```

16. `amplify console analytics`

