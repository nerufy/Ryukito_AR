//
//  SuperViewController.swift
//  Ryukito_AR
//
//  Created by kouki on 2020/10/05.
//  Copyright © 2020 又吉琉稀斗. All rights reserved.
//

import Foundation
import UIKit

class SuperViewController: UIViewController {
    func goToViewController(storyboardName: String, ViewControllerIdentifier: String) {
        //Storyboardを指定
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        //生成するViewControllerを指定
        let next = storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifier)
        //表示
        self.present(next, animated: true)
    }
}
