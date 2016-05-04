//
//  T_ProfileEditionViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 20/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_ProfileEditionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
