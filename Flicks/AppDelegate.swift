//
//  AppDelegate.swift
//  Flicks
//
//  Created by Wuming Xie on 9/12/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit
import AFNetworking
import ACProgressHUD_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let nowPlayingNC = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
    colorNavBar(nowPlayingNC)
    
    let nowPlayingVC = nowPlayingNC.topViewController as! MoviesViewController
    nowPlayingVC.endpoint = Constants.MoviesDB.nowPlayingURL
    nowPlayingVC.tabBarItem.title = "Now Playing"
    nowPlayingVC.tabBarItem.image = UIImage(named: "now_playing")
    
    let topRatedNC = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
    colorNavBar(topRatedNC)
    let topRatedVC = topRatedNC.topViewController as! MoviesViewController
    topRatedVC.endpoint = Constants.MoviesDB.topRatedURL
    topRatedVC.tabBarItem.title = "Top Rated"
    topRatedVC.tabBarItem.image = UIImage(named: "top_rated")
    
    let tabBarVC = UITabBarController()
    tabBarVC.setViewControllers([nowPlayingNC, topRatedNC], animated: false)
    tabBarVC.tabBar.barTintColor = Constants.Theme.barColor
    tabBarVC.tabBar.tintColor = UIColor.white
    
    window?.rootViewController = tabBarVC
    window?.makeKeyAndVisible()
    
    // Configure hud
    ACProgressHUD.shared.configureProgressHudStyle(
      withProgressText: "Loading ...",
      progressTextColor: UIColor.black,
      hudBackgroundColor: UIColor.white,
      shadowColor: UIColor.black,
      shadowRadius: 10,
      cornerRadius: 5,
      indicatorColor: UIColor.blue,
      enableBackground: false,
      backgroundColor: UIColor.black,
      backgroundColorAlpha: 0.3,
      enableBlurBackground: false,
      showHudAnimation: .growIn,
      dismissHudAnimation: .growOut
    )
    
    return true
  }
  
  private func colorNavBar(_ navigationController: UINavigationController) {
    let navBar = navigationController.navigationBar
    navBar.barTintColor = Constants.Theme.barColor
    navBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.Theme.defaultTextColor]
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

