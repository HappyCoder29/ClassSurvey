//
//  ViewController.swift
//  ClassSurvey
//
//  Created by Ashish Ashish on 11/4/21.
//

import UIKit
import Firebase
import SwiftSpinner

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keychain = Keychain().key
        
        if keychain.get("uid") != nil {
            performSegue(withIdentifier: "loggedInSegue", sender: self)
        }
    }

    @IBAction func loginAction(_ sender: Any) {
        let  email = txtEmail.text;
        let password = txtPassword.text
        
        if email?.count == 0 || email?.isValidEmail == false  {
            lblStatus.text = " Please enter a valid Email"
            return
        }

        if password?.count ??  0 < 5 {
            lblStatus.text = "Please enter a valid password"
            return
        }
        
        SwiftSpinner.show("Logging in...")
        Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] authResult, error in
            SwiftSpinner.hide(nil)
            
            guard let self = self else { return }
            
            if error != nil {
                self.lblStatus.text =  error?.localizedDescription
                return
            }
            let uid = Auth.auth().currentUser?.uid
            self.txtPassword.text = ""
            Keychain().key.set(uid!, forKey: "uid" )
            
            self.performSegue(withIdentifier: "loggedInSegue", sender: self)

        }
    }
    
}


extension String{
    var isValidEmail : Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}



