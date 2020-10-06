//
//  MenuViewController.swift
//  Ryukito_AR
//
//  Created by 又吉琉稀斗 on 2020/08/04.
//  Copyright © 2020 又吉琉稀斗. All rights reserved.
//

import UIKit
class ResultViewController: SuperModeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func didTapMainButton(_ sender: Any) {
        super.goToViewController(storyboardName: "Main", ViewControllerIdentifier: "Main")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

