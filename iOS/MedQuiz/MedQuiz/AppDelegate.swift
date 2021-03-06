//
//  AppDelegate.swift
//  MedQuiz
//
//  Created by Omar Sherief on 9/29/17.
//  Copyright © 2017 Omar Sherief. All rights reserved.
//

import UIKit
import Firebase

/*
 AppDelegate controls application launch operations and handles active/terminated state changes.
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseRef: DatabaseReference!

    /*
     Configure Firebase connection.
     */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        //Database.database().isPersistenceEnabled = true

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    /*
     Exit user out of certain views when app is put into background.
     */
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let topController = getTopController()
        switch topController {
            case is QuizActivityVC:
                DispatchQueue.global(qos: .background).async {
                    if (topController as! QuizActivityVC).quizMode == .Standard {
                        (topController as! QuizActivityVC).standardConcede()
                    }
                    else if (topController as! QuizActivityVC).quizMode == .HeadToHead {
                        (topController as! QuizActivityVC).headToHeadConcede()
                    }
                    print("Game conceded in background")
                    DispatchQueue.main.async {
                        (topController as! QuizActivityVC).errorOccurred(title: "Game Left", message: "You left the app and the quiz.", completion: nil)
                    }
                }
                break
            case is QuizLobbyVC:
                DispatchQueue.global(qos: .background).async {
                    (topController as! QuizLobbyVC).prepLobbyExit()
                    print("Game conceded in background")
                    DispatchQueue.main.async {
                        (topController as! QuizLobbyVC).errorOccurred(title: "Game Left", message: "You left the app and the quiz.", completion: nil)
                    }
                }
            break
            default:
                print("App entered background.")
                print(type(of: topController))
                break
            }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    /*
     Exit user out of certain views when app is terminated.
     */
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let topController = getTopController()
        switch topController {
            case is QuizActivityVC:
                DispatchQueue.global(qos: .background).async {
                    if (topController as! QuizActivityVC).quizMode == .Standard {
                        (topController as! QuizActivityVC).standardConcede()
                    }
                    else if (topController as! QuizActivityVC).quizMode == .HeadToHead {
                        (topController as! QuizActivityVC).headToHeadConcede()
                    }
                    print("Game conceded in background")
                    DispatchQueue.main.async {
                        (topController as! QuizActivityVC).exitQuiz(completion: nil)
                    }
                }
                break
            case is QuizLobbyVC:
                DispatchQueue.global(qos: .background).async {
                    (topController as! QuizLobbyVC).prepLobbyExit()
                    print("Game conceded in background")
                    DispatchQueue.main.async {
                        (topController as! QuizLobbyVC).errorOccurred(title: "Game Left", message: "You left the app and the quiz.", completion: nil)
                    }
                }
                break
            default:
                print("App exited.")
                print(type(of: topController))
                break
            }
    }
    
    /*
     Return topmost view controller.
     */
    
    func getTopController(_ parent:UIViewController? = nil) -> UIViewController {
        if let vc = parent {
            if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
                return getTopController(selected)
            } else if let nav = vc as? UINavigationController, let top = nav.topViewController {
                return getTopController(top)
            } else if let presented = vc.presentedViewController {
                return getTopController(presented)
            } else {
                return vc
            }
        } else {
            return getTopController(UIApplication.shared.keyWindow!.rootViewController!)
        }
    }
}
