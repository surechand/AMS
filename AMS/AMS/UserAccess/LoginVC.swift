//
//  LoginVC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 13/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Firebase
import AnimatedGradientView

// MARK: TODO: Add more login options (Google account, log in with Apple)

class LoginVC: UIViewController {
    
    @IBOutlet weak var LoggedButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var ForgotPasswordButton: UIButton!
    
    @IBOutlet weak var ErrorMessageLabel: UILabel!
    
    @IBOutlet weak var LoginTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var appIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.animations = [
        AnimatedGradientView.Animation(colorStrings: ["#8686E6", "#5E5CE6"], direction: .up, locations: [0.0, 0.5, 1.0], type: .axial),
        AnimatedGradientView.Animation(colorStrings: ["#91CC00", "#30D33B"], direction: .upRight, locations: [0.0, 0.5, 1.0], type: .axial),
        AnimatedGradientView.Animation(colorStrings: ["#FF7471", "#FF375F"], direction: .upRight, locations: [0.0, 0.5, 1.0], type: .axial)
        ]
        view.insertSubview(animatedGradient, at: 0)
        
        self.setPaddingAndBorders(textField: PasswordTextField)
        self.setPaddingAndBorders(textField: LoginTextField)
        self.setBorders(button: LoginButton)
        self.setBorders(button: RegisterButton)
        
        setLayerShadow(layer: appIcon.layer)
        
        LoginTextField.attributedPlaceholder = NSAttributedString(string: "Email adress",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "LoggedSegue"{
            if (LoginTextField.text == nil) || (PasswordTextField.text == nil) {
                return false
            }
            let email = LoginTextField.text!
            let password = PasswordTextField.text!
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
            }
            let user = Auth.auth().currentUser
            if(user == nil) {
                print("Error logging in")
                return false
            }
        }
        return true
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        if (LoginTextField.text != nil) &&  (LoginTextField.text!.isValidEmail) {
            Auth.auth().sendPasswordReset(withEmail: LoginTextField.text!) { error in
                let alert = UIAlertController(title: "Password reset email sent.", message: nil, preferredStyle: .alert)
                alert.view.tintColor = UIColor.systemIndigo
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Incorrect email adress.", message: "Unable to send a password reset email.", preferredStyle: .alert)
            alert.view.tintColor = UIColor.systemIndigo

            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }
    }
    
    func setBorders (button : UIButton) {
        button.contentEdgeInsets = UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15);
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3.0
    }
    
    func setPaddingAndBorders (textField: UITextField) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 3.0
    }
    
    func setLayerShadow (layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2.5
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.masksToBounds = false
    }
    
}

extension String {
  var isValidEmail: Bool {
     let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
     let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
     return testEmail.evaluate(with: self)
  }
}
