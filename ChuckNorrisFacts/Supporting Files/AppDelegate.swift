//
//  AppDelegate.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 18/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let container = Container { container in
        // Mappers
        container.register(FactsMapperProtocol.self) { _ in FactsMapper() }
        container.register(FactsPresentationMapperProtocol.self) { _ in FactsPresentationMapper() }

        // Services
        container.register(FactServiceProtocol.self) { r in FactService(mapper: r.resolve(FactsMapperProtocol.self)!) }

        // View models
        container.register(ListFactsViewModel.self) { r in
            ListFactsViewModel(service: r.resolve(FactServiceProtocol.self)!,
                                        mapper: r.resolve(FactsPresentationMapperProtocol.self)!)
        }
        
        // Views
        container.storyboardInitCompleted(ListFactsTableViewController.self) { r, c in
            c.viewModel = r.resolve(ListFactsViewModel.self)!
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        self.window = window
        
        let sb = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        window.rootViewController = sb.instantiateViewController(withIdentifier: "Navigation")
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
}
