import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let customerId = "sasha"
        //let eventId = "integrationtest2"
        let eventId = "itl10"
        let configId = "configId1"
        let widget1 = Widget("CountDown", 1)
        let widget2 = Widget("Progress", 1)
        let engine = QueueITEngine(customerId: customerId,
            eventId: eventId,
            configId: configId,
            widgets: widget1, widget2,
            layoutName: "",
            language: "",
            onQueueItemAssigned: (onQueueItemAssigned),
            onQueuePassed: (onQueuePassed),
            onPostQueue: (onPostQueue),
            onIdleQueue: (onIdleQueue),
            onWidgetChanged: (onWidgetChanged),
            onQueueIdRejected: (onQueueIdRejected))
        
        engine.run()
        
        return true
    }
    
    func onQueueItemAssigned(queueItemDetails: QueueItemDetails) {
        print(queueItemDetails.queueId)
    }
    
    func onQueuePassed(queuePassedDetails: QueuePassedDetails) {
        print("REDIRECTED!!! RedirectType: \(queuePassedDetails.passedType)")
    }
    
    func onPostQueue() {
        print("Postqueue published...")
    }
    
    func onIdleQueue() {
        print("Idle queue published...")
    }
    
    func onWidgetChanged(widget: WidgetDTO) {
        print("Widget changd!: \(widget.name)")
    }
    
    func onQueueIdRejected(reason: String) {
        print("QueueId rejected! Reason: \(reason)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

