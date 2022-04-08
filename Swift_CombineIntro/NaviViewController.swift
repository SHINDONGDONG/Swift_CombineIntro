//
//  NaviViewController.swift
//  Swift_CombineIntro
//
//  Created by 申民鐡 on 2022/04/07.
//

import UIKit

class NaviViewController: UINavigationController {

    let mainVC = UINavigationController(rootViewController: MainController())
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([mainVC], animated: true)
    }
    
    
}
