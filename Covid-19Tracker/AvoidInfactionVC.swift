//
//  AvoidInfactionVC.swift
//  Covid-19Tracker
//
//  Created by Mayur Parmar on 16/04/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import UIKit

class AvoidInfactionVC: UIViewController {
     
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- IBACtion
    @IBAction func btnBackPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
