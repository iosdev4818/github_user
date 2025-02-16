//
//  AppDelegate.swift
//  GithubUser
//
//  Created by Bao Nguyen on 16/2/25.
//

import UIKit
import LifetimeTracker

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
#if DEBUG
        LifetimeTracker.setup(
            onUpdate: LifetimeTrackerDashboardIntegration(
                visibility: .alwaysVisible,
                style: .bar,
                textColorForNoIssues: .systemGreen,
                textColorForLeakDetected: .systemRed
            ).refreshUI
        )
#endif
        return true
    }
}
