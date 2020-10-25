//
//  RegisterVC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 13/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import AnimatedGradientView

class AMSLogoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let logoImage = UIImage(named: "icontransparent")
        let imageView = UIImageView(image: logoImage)
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.autoresizingMask = .flexibleWidth
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.systemIndigo
        addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RegisterVC: FormViewController {
    
    @IBOutlet weak var GoToSecondStepButton: UIButton!
    
    let viewCustomisation = ViewCustomisation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemIndigo)
        self.initiateNameForm()
        self.initiateEmailForm()
        self.initiatePasswordForm()
        self.initiateValidationForm()
    }
    
    func initiateNameForm() {
        form +++
            Section() {
                $0.header = HeaderFooterView<AMSLogoView>(.class)
        }
            
            <<< TextRow("name") {
                $0.title = "Name"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
            }
            
            <<< TextRow("surname") {
                $0.title = "Surname"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
        }
    }
    func initiateEmailForm() {
        form
            +++ Section()
            <<< EmailRow("email") {
                $0.title = "Email adress"
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChangeAfterBlurred
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
        }
    }
    
    
    func initiatePasswordForm() {
        form
            +++ Section()
            <<< PasswordRow("password") {
                $0.title = "Password"
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 20))
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
            }
            <<< PasswordRow() {
                $0.title = "Confirm Password"
                $0.add(rule: RuleEqualsToRow(form: form, tag: "password"))
                $0.add(rule: RuleRequired())
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged { cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                    row.section?.remove(at: rowIndex + 1)
                }
                if !row.isValid {
                    for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                        let labelRow = LabelRow() {
                            $0.title = validationMsg
                            $0.cell.height = { 30 }
                        }
                        let indexPath = row.indexPath!.row + index + 1
                        row.section?.insert(labelRow, at: indexPath)
                    }
                }
        }
    }
    
    func initiateValidationForm() {
        form
            +++ Section()
            <<< CheckRow("agreement1") {
                $0.title = "I agree to T&C of AMS app:"
                $0.cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                $0.add(rule: RuleRequired())
            }.onChange({ row in
                let agr2: CheckRow? = self.form.rowBy(tag: "agreement2")
                if row.value == true {
                    agr2!.value = true
                } else {
                    agr2!.value = false
                }
                agr2?.reload()
            })
            
            <<< TextAreaRow() {
                $0.value = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32.Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32."
                $0.textAreaMode = .readOnly
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 30)
                $0.hidden = "$agreement1 == true"
            }
            
            <<< CheckRow("agreement2") {
                $0.title = "I agree to T&C of AMS app"
                $0.cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            }.onChange({ row in
                let agr1: CheckRow? = self.form.rowBy(tag: "agreement1")
                if row.value == true {
                    agr1!.value = true
                } else {
                    agr1?.value = false
                }
                agr1?.reload()
            })
            
            <<< ButtonRow() {
                $0.title = "Next"
            }
            .onCellSelection { cell, row in
                var allValid = true
                let invalidRow = self.form.rows.firstIndex(where: { $0.isValid == false })
                let agreement1: CheckRow? = self.form.rowBy(tag: "agreement1")
                
                if (invalidRow != nil) { allValid = false }
                
                if allValid == true && agreement1?.value != true {
                    let alert = UIAlertController(title: "T&C", message: "You have to accept T&C of AMS to use it", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                if allValid == true && agreement1?.value == true {
                    //                    add user to firebase
                    let emailRow: EmailRow? = self.form.rowBy(tag: "email")
                    let email = emailRow!.value!
                    let passwordRow: PasswordRow? = self.form.rowBy(tag: "password")
                    let password = passwordRow!.value!
                    let nameRow: TextRow? = self.form.rowBy(tag: "name")
                    let name = nameRow!.value!
                    let surnameRow: TextRow? = self.form.rowBy(tag: "surname")
                    let surname = surnameRow!.value!
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = name + " " + surname
                            changeRequest?.commitChanges { (error) in
                                let user = Auth.auth().currentUser
                                if let user = user {
                                    // set user document
                                    let userDocument = UserDocument(uid: user.uid)
                                    userDocument.setUserDocument(name: nameRow!.value!, surname: surnameRow!.value!, email: emailRow!.value!)
                                }
                                self!.performSegue(withIdentifier: "RegisterSecondStepSegue", sender: self!.GoToSecondStepButton)
                            }
                        }
                    }
                }
            }.cellUpdate { cell, row in
                let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
                self.viewCustomisation.setLabelRowCellProperties(cell: cell, textColor: UIColor.systemIndigo, borderColor: UIColor(patternImage: blueGradientImage!))
        }
    }
}
