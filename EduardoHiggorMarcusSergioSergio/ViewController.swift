//
//  ViewController.swift
//  EduardoHiggorMarcusSergioSergio
//
//  Created by Eduardo Silva on 04/10/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func entrar(_ sender: Any) {
        self.gotoMainScreen()
    }
    
    private func gotoMainScreen() {
        if let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ToyTableViewController") {
            show(listTableViewController, sender: nil)
        }
    }
    
}

