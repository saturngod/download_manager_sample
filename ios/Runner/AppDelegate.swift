import UIKit
import Flutter
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
     
      GeneratedPluginRegistrant.register(with: self)
      FlutterDownloaderPlugin.setPluginRegistrantCallback({ registry in
          FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)

      })
      let directoryPaths = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)
      print(directoryPaths.first)
      
    
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

  
}
