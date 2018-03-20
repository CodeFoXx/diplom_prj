//
//  AppDelegate.swift
//  CoreML_test
//
//  Created by Осина П.М. on 13.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import UIKit
import DITranquillity
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var container: DIContainer!
    
    let userDefaults = UserDefaults.standard



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupAppearence()
        configureSVProgrssHUD()
        buildDependencyComponent()
        setupRootViewController()
        
        
        self.userDefaults.setValue("trnsl.1.1.20170803T140152Z.ff3df58b936ba3e4.cb34d86877638b493fd3388f2842d20c61948c58", forKey: "yandexApiDefaultsKey")
        
        return true
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

    private func buildDependencyComponent(){
        container = DIContainer()
        container.append(part: AppDIPart.self)
        container.append(part: NetworkDIPart.self)
        container.append(part: MainDIPart.self)
        container.append(part: TextDetectorDIPart.self)
        container.append(part: MapDIPart.self)
        container.append(part: OCRDIPart.self)
        container.append(part: TranslationDIPart.self)
        container.append(part: TextDetectionDIPart.self)
        if !container.validate(){
            fatalError("DI fatal error")
        }
    }
    
    private func setupAppearence(){
        UINavigationBar.appearance().backIndicatorImage = #imageLiteral(resourceName: "back_button_gray").withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_button_gray")
    }
    
    private func configureSVProgrssHUD(){
        SVProgressHUD.setMaximumDismissTimeInterval(1.3)
    }
    
    func setupRootViewController(){
        let mainViewController = *container as TranslationViewController
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.isHidden = true
        //navigationController.style(hidden: false)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
    }

}

