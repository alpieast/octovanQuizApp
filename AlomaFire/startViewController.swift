//
//  startViewController.swift
//  AlomaFire
//
//  Created by Alperen Dogu on 29.06.2018.
//  Copyright © 2018 Alperen Dogu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import FirebaseDatabase
import Firebase


class startViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userView : ViewController = segue.destination as! ViewController
        userView.userName = userNameField.text!
    }
    @IBAction func resultView(_ sender: UIButton) {
        
        }
    @IBOutlet weak var userNameField: UITextField!
    @IBAction func nameSender(_ sender: Any) {
     }
    
    override func viewDidLoad() {
      
    }
}
