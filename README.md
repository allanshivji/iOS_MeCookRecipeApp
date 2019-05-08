# MeCook Recipe - iOS App (CS - 523 Final project)

## Description

This is a basic iOS Recipe app where the user can upload data to iCloud and the same data ill be available to all the iOS devices having the same iCloud account on the iPhones. Once any iPhone uploads data to iCloud the other devices can pull to refresh the tableView to have the same new uploaded data on their device. Also when the data is uploaded to the iCloud the other devices get the notifications. When the user clicks on the tableView cell of the title it navigates them to another window where they can see the detials about their recipe i.e., they can see the title, ingredients and steps of the recipe. At the bottom there is a button to share the recipes and when clicked on it, an email window opens up with already having detials of the recipe in the email body and subject line. The user just have to enter the email address of their friends and click on the send button to share the recipe. In another tab bar implemented a countdown timer window where the user can use it to set the countdown time when he/she cooks some recipe and when the countdown timer reaches to 0 second an alarm sound is made by the app. Now if the user feels to search about the history or tradition of the recipe, in the third tab bar a browser is implemented where the user can do a google search for his recipe. Also implemented some error checking where if the user has not logged into iCloud account on his iphone then it gives an error and does not allow to send data to iCloud. Also if there is no internet connection, and when you try to search in browser to pull the table to refresh then it gives an error stating that the device is not connected to the internet.

## Steps to run the app
1. Download this zip file.
2. Make sure you are connected to the internet and have logged in into iCloud account on all of the iPhone devices.
3. Run this file in Xcode like we do for normal iOS applications.
4. When the app opens up on device clcik on "Allow" to get the notifications.
5. Click on "+" button and fill in all the details in alert window (Make sure you have logged in into iCloud account).
6. Click on "Add" to post the data to iCloud (Make sure you have paid Apple Developer account).
7. Once the data is posted to iCloud you can see that in your tableView the titile of the recipe added shows up.
8. To have the same data on other iPhone device pull the tableView to refresh and then you will get that uploaded data.
9. When you clcik on the cell/title in tableView it will navigate you to another window where you will get the detials of your recipe and when clciked on the "Share this recipe" button an email window will show up with preloaded recipe data in its body (E-mail feature will run only on physical iPhone device and not simulator so run the app on your physical device).
10. In the 2nd tab a countdown timer window shows up where you can set up your time and start the clock. Once the clock reaches to 0 second, an alarm sound is played.
11. In the 3rd tab window implemented a browser view viz., basically a google page where the user can do some research about their recipe.

## Frameworks Used
[UiKit](https://developer.apple.com/documentation/uikit) - To define UiTableView, Labels, buttons etc.

[CloudKit](https://developer.apple.com/documentation/cloudkit) - To upload and fetch data from iCloud so that it can be synced on all iPhone devices.

[MessageUI](https://developer.apple.com/documentation/messageui) - To share recipes to friends via E-mail.

[AVFoundation](https://developer.apple.com/documentation/avfoundation) - To play sound when countdown reaches to 0 second.

[WebKit](https://developer.apple.com/documentation/webkit) - To implement browser in the app.

[UserNotifications](https://developer.apple.com/documentation/usernotifications) - To send notifications to user when new recipe is added.


## [Find Demo Here](https://www.youtube.com/watch?v=Ff7asHBjUHY)
