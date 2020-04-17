//
//  SelfAssesmentResultVC.swift
//  Covid-19Tracker
//
//  Created by Mayur Parmar on 17/04/20.
//  Copyright © 2020 Mayur Parmar. All rights reserved.
//

import UIKit

class SelfAssesmentResultVC: UIViewController {
    
    //MARK:- Outlet and Variable
    @IBOutlet var txtResult: UITextView!
    @IBOutlet var btnHome: UIButton!
    
    var result = ""
    
    //MAEK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //Setup UI
    func setupUI() {
        txtResult.text = result
        btnHome.layer.cornerRadius = 10
        btnHome.clipsToBounds = true
    }
    
    //MARK:- IBAction
    @IBAction func btnHomePress(_ sender: Any) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    @IBAction func btnBackPress(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
