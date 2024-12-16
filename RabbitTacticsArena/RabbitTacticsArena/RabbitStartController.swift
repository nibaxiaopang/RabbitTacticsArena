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

}

