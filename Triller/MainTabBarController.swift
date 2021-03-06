//
//  CustomTabBarController.swift
//  Triller
//
//  Created by Sherif  Wagih on 10/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import Firebase
import IQAudioRecorderController
class MainTabBarController: UITabBarController,UIGestureRecognizerDelegate,UITabBarControllerDelegate,IQAudioRecorderViewControllerDelegate{
    func audioRecorderController(_ controller: IQAudioRecorderViewController, didFinishWithAudioAtPath filePath: String) {
        let someV = ShareAudioViewController()
        someV.filePath = filePath
        if let nav = self.viewControllers?[1] as? UINavigationController
        {
          //  print(nav)
            if let rootView = nav.viewControllers[0] as? SearchController
            {
                guard let home = rootView.navigationController else {return}
                if home.viewControllers.count >= 2
                {
                  if let homeController = home.viewControllers[1] as? MainHomeFeedController
                {
                    if let hashTag = homeController.hashTag
                    {
                        someV.hashTagName = "#" + hashTag.hashTagName
                    }
                }
                }
            }
        }
        
        present(UINavigationController(rootViewController: someV), animated: true) {
              self.dismiss(animated: true)
        }
       
    }
    func audioRecorderControllerDidCancel(_ controller: IQAudioRecorderViewController) {
        dismiss(animated: true, completion: nil)
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2
        {
            let audioController = AudioRecorderView(delegate_:self)
            audioController.PresentAudioRecorder(target: self)
            return false
        }
        return true
    }
    
    let customBackGroundView = UIView()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil
        {
            self.delegate = self
            setupViewControllers()
            DispatchQueue.main.async {
                self.createCustomStatusBar(color: .blue)
            }
            self.tabBar.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        }
        else
        {
            let loginNav = UINavigationController(rootViewController:  LoginController())
            self.present(loginNav, animated: true, completion: nil)
        }
    }
    override func viewDidLayoutSubviews() {
        self.navigationController?.navigationBar.isHidden = true
    }
    func createCustomStatusBar(color:UIColor){
       
        customBackGroundView.backgroundColor = .blue
        customBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        let height = UIApplication.shared.statusBarFrame.height
        guard let window = UIApplication.shared.keyWindow else {return}
        window.addSubview(customBackGroundView)
        customBackGroundView.anchorToView(top: window.topAnchor, leading: window.leadingAnchor, bottom: nil, trailing: window.trailingAnchor, padding: .zero, size: .init(width: 0, height: height))
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        customBackGroundView.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        createCustomStatusBar(color: .blue)
    }
    private var popGesture: UIGestureRecognizer?
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        guard let nav = navigationController else {return}
        if nav.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            self.popGesture = navigationController!.interactivePopGestureRecognizer
             self.navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
        }
        
    }
    
    func setupViewControllers()
    {
        let layout = UICollectionViewFlowLayout()
        let homeNav = UINavigationController(rootViewController: MainHomeFeedController(collectionViewLayout:layout) )
        homeNav.tabBarItem.image = #imageLiteral(resourceName: "home_selected").withRenderingMode(.alwaysTemplate)
        let layout2 = UICollectionViewFlowLayout()
        let searchNav = UINavigationController(rootViewController: SearchController(collectionViewLayout:layout2) )
        searchNav.tabBarItem.image = #imageLiteral(resourceName: "search_selected").withRenderingMode(.alwaysTemplate)
        let layout3 = UICollectionViewFlowLayout()
        let notificationNav = UINavigationController(rootViewController: MainNotificationController(collectionViewLayout:layout3) )
        notificationNav.tabBarItem.image = #imageLiteral(resourceName: "icons8-notification-filled-50").withRenderingMode(.alwaysTemplate)
        let layout4 = UICollectionViewFlowLayout()
        let profileNav = UINavigationController(rootViewController: MainProfileController(collectionViewLayout:layout4))
        profileNav.tabBarItem.image = #imageLiteral(resourceName: "profile_selected").withRenderingMode(.alwaysTemplate)
        let recordImage =  UIViewController()
        recordImage.view.backgroundColor = .white
        recordImage.tabBarItem.image = #imageLiteral(resourceName: "microphone").withRenderingMode(.alwaysOriginal)
        viewControllers = [homeNav,searchNav,recordImage,notificationNav,profileNav]
    }
}
