//
//  SearchViewController.swift
//  swifty-companion
//
//  Created by Nordine Sayah on 05/12/2020.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    var finished: Bool = false
    var user: User?
    var coa: [Coalition]?

    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.delegate = self
            loginTextField.becomeFirstResponder()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.shared.getToken()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        executeRequest()
        self.view.endEditing(true)
        
        return false
    }
    
    func executeRequest() {
        if let userLogin = loginTextField.text?.lowercased() {
            if userLogin.isLoginConform {
                APIService.shared.getUser(userLogin) { user in
                    guard let user = user else {
                        let alert = UIAlertController(title: "User not found", message: "Please enter a valid login", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                        return}
                    self.user = user
                    APIService.shared.getUserCoa(userLogin) { coa in
                        guard let coa = coa else {
                            let alert = UIAlertController(title: "Coalition not found", message: "We could not find the user coalition", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                            self.present(alert, animated: true)
                            return}
                        self.coa = coa
                        self.finished = true
                        self.readyForSegue()
                    }
                }
            } else {
                let alert = UIAlertController(title: "Invalid login", message: "Please enter a valid login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func getLogin(_ sender: UIButton) {
         executeRequest()
        
    }

    func readyForSegue() {
        if finished == true {
            performSegue(withIdentifier: "getUserinfo", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getUserinfo" {
            let destVC = segue.destination as! StudentViewController
            destVC.user = self.user
            destVC.coa = self.coa
        }
    }
}

extension String {
    var isLoginConform: Bool {
        return !isEmpty && range(of: "[^a-zA-Z-]", options: .regularExpression) == nil
    }
}
