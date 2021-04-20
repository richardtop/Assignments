import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.makeKeyAndVisible()
    
    // SizeRange = Screen bounds for this demo.
    // In real app, feed may take only a part of the screen
    let screen = UIScreen.main.bounds
    let maxSize = CGSize(width: screen.size.width,
                         height: .greatestFiniteMagnitude)
    let sizeRange = SizeRange(min: .zero, max: maxSize)
    let context = ComponentContext(sizeRange: sizeRange, styleSheet: StyleSheet())
    
    let provider = PostComponentProvider()
    let logicController = LogicController(context: context,
                                          componentProvider: provider)

    let viewController = logicController.viewController

    window?.rootViewController = viewController
    
    return true
  }
}
