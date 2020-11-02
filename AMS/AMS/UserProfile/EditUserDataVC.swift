//
//  EditUserDataVC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 14/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase

protocol sendUpdatedUsername {
    func sendUpdatedUsernameToUserDisplay(username: String)
}

class EditUserDataVC: FormViewController, passTheme {
    
    let viewCustomisation = ViewCustomisation()
    
    var delegate: sendUpdatedUsername? = nil
    var theme: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: self.theme!)
        
        self.initiateNameForm()
        self.initiateAddressForm()
        self.initiateEmailAndPhoneNumberForm()
        self.initiatePasswordForm()
        self.initiateUserDeleteForm()
    }
    
    func finishPassing(theme: UIColor, gradient: UIImage) {
        self.theme = theme
    }
    
    private func redOnInvalidCallback(cell: TextCell, row: TextRow) {
        if !row.isValid {
            cell.titleLabel?.textColor = .red
        }
    }
    
    private func validationErrorsCallback(cell: TextCell, row: TextRow) {
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
    
    private func validationErrorsCallback(cell: EmailCell, row: EmailRow) {
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
    
    private func validationErrorsCallback(cell: PasswordCell, row: PasswordRow) {
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
    
    func initiateNameForm() {
        form +++
            Section()
        let user = Auth.auth().currentUser
        if let user = user {
            let fullName = user.displayName!.components(separatedBy: " ")
            form +++
                Section()
                
                <<< TextRow("name") {
                    $0.title = "Name"
                    $0.value = fullName[0]
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged(validationErrorsCallback(cell:row:))
                
                <<< TextRow("surname") {
                    $0.title = "Surname"
                    $0.value = fullName[1]
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged(validationErrorsCallback(cell:row:))
        }
    }
    
    func initiateAddressForm() {
        let user  = Auth.auth().currentUser
        if let user = user {
            let userDocument = UserDocument(uid: user.uid)
            
            form
                +++ Section()
                <<< TextRow("address") {
                    $0.title = "Address"
                    $0.add(rule: RuleRequired())
                }.cellSetup({ cell, row in
                    userDocument.getUserExtraData(key: "address", handler: { address in
                        row.value = address
                        row.reload()
                    })
                })
                .cellUpdate(redOnInvalidCallback(cell:row:))
                .onRowValidationChanged(validationErrorsCallback(cell:row:))
            
                <<< TextRow("city") {
                    $0.title = "City"
                    $0.add(rule: RuleRequired())
                }.cellSetup({ cell, row in
                    userDocument.getUserExtraData(key: "city", handler: { city in
                        row.value = city
                        row.reload()
                    })
                }).cellUpdate(redOnInvalidCallback(cell:row:))
                .onRowValidationChanged(validationErrorsCallback(cell:row:))
            
                <<< TextRow("postcode") {
                    $0.title = "Postcode"
                    $0.add(rule: RuleRequired())
                }.cellSetup({ cell, row in
                    userDocument.getUserExtraData(key: "postcode", handler: { postcode in
                        row.value = postcode
                        row.reload()
                    })
                }).cellUpdate(redOnInvalidCallback(cell:row:))
                .onRowValidationChanged(validationErrorsCallback(cell:row:))
            
                <<< TextRow("country") {
                    $0.title = "Country"
                    $0.add(rule: RuleRequired())
                }.cellSetup({ cell, row in
                    userDocument.getUserExtraData(key: "country", handler: { country in
                        row.value = country
                        row.reload()
                    })
                }).cellUpdate(redOnInvalidCallback(cell:row:))
                .onRowValidationChanged(validationErrorsCallback(cell:row:))
        }
    }
    
    func initiateEmailAndPhoneNumberForm() {
        let user = Auth.auth().currentUser
        if let user = user {
            let userDocument = UserDocument(uid: user.uid)

            form
                +++ Section()
                <<< EmailRow("email") {
                    $0.title = "Email adress"
                    $0.value = user.email
                    $0.add(rule: RuleRequired())
                    $0.add(rule: RuleEmail())
                    $0.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged(validationErrorsCallback(cell:row:))

            
                <<< PhoneRow("phoneNumber") {
                    $0.title = "Phone Number"
                    $0.add(rule: RuleRequired())
                }.cellSetup({ cell, row in
                    userDocument.getUserExtraData(key: "phoneNumber", handler: {
                        number in
                        row.value = number
                        row.reload()
                    })
                })
        }
    }
    
    
    func initiatePasswordForm() {
        form
            +++ Section()
            <<< PasswordRow("newpassword") {
                $0.title = "New password"
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 20))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged(validationErrorsCallback(cell:row:))
            
            <<< PasswordRow() {
                $0.title = "Confirm new password"
                $0.add(rule: RuleEqualsToRow(form: form, tag: "newpassword"))
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            .onRowValidationChanged(validationErrorsCallback(cell:row:))
    }
    
    func initiateUserDeleteForm() {
        form
            +++ Section()
            <<< ButtonRow("deleteProfile") {
                $0.title = "Delete profile"
            }.cellUpdate({ cell, row in
                cell.textLabel?.textColor = .systemRed
            })
            .onCellSelection({ cell, row in
                
                let deletionAlert = UIAlertController(title: "Do you want to delete your profile?", message: "You won't be able to recover it!", preferredStyle: .alert)
                deletionAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                deletionAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    let userCollerctionRef = Firestore.firestore().collection("users")
                    let user = Auth.auth().currentUser
                    
                    if let user = user {
                        
                        userCollerctionRef.document(user.uid).collection("bids").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Failed to delete user Bids, \(err)")
                                return
                            } else {
                                querySnapshot?.documents.forEach({
                                    $0.reference.delete()
                                })
                                print("User bids succesfully deleted")
                            }
                        }
                                                
                        userCollerctionRef.document(user.uid).delete() { err in
                            if let err = err {
                                print("Failed to delete user document: \(err)")
                                return
                            } else {
                                print("User document succesfully deleted")
                            }
                        }
                        
                        ImageManagement.shareInstance.deleteImage()

                        user.delete { err in
                            if let err = err {
                                print("Error deleting user \(err)")
                                if let errCode = AuthErrorCode(rawValue: err._code) {
                                    if errCode == .requiresRecentLogin {
                                        
                                        var relogAlert = UIAlertController(title: "Login needed", message: "You need to login again for safe account delete.", preferredStyle: .alert)
                                        relogAlert.addTextField(configurationHandler: { textField in
                                            textField.placeholder = "Login email"
                                        })
                                        relogAlert.addTextField(configurationHandler: { textField in
                                            textField.placeholder = "Password"
                                            textField.isSecureTextEntry = true
                                        })
                                        relogAlert.addAction(UIAlertAction(title: "Login", style: .cancel, handler: { [weak relogAlert] (_) in
                                            let login = (relogAlert!.textFields![0] as UITextField).text
                                            let password = (relogAlert!.textFields![1] as UITextField).text
                                            let credential: AuthCredential = EmailAuthProvider.credential(withEmail: login ?? "", password: password ?? "")
                                            
                                            user.reauthenticate(with: credential) { result, error in
                                                if let error = error {
                                                    print("Error during relog; deletion impossible: \(error)")
                                                } else {
                                                    user.delete() { error in
                                                        if let error = error {
                                                            print("Error deleting user account after relog; deletion impossible: \(error)")
                                                        } else {
                                                            print("Succesfully deleted user account: \(error)")
                                                            self.performSegue(withIdentifier: "EditToLoginSegue", sender: self)
                                                        }
                                                    }
                                                }
                                            }
                                        }))
                                        self.present(relogAlert, animated: true, completion: nil)
                                    }
                                }
                            } else {
                                print("Succesfully deleted user account")
                                self.performSegue(withIdentifier: "EditToLoginSegue", sender: self)
                            }
                        }

                    }
                }))
                self.present(deletionAlert, animated: true, completion: nil)
            })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var allValid = true
        if form.validate().isEmpty {
            allValid = true
        } else {
            allValid = false
        }

        if allValid == true {
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                
                let emailRow: EmailRow? = self.form.rowBy(tag: "email")
                if (emailRow!.value != user.email){
                    Auth.auth().currentUser?.updateEmail(to: emailRow!.value!) { (error) in
                      // ...
                    }
                }
                
                let passwordRow: PasswordRow? = self.form.rowBy(tag: "newpassword")
                if (passwordRow!.value != nil) {
                    Auth.auth().currentUser?.updatePassword(to: passwordRow!.value!) { (error) in
                      // ...
                    }
                }
                
                let nameRow: TextRow? = self.form.rowBy(tag: "name")
                let surnameRow: TextRow? = self.form.rowBy(tag: "surname")
                
                let addressRow: TextRow? = self.form.rowBy(tag: "address")
                let cityRow: TextRow? = self.form.rowBy(tag: "city")
                let postcodeRow: TextRow? = self.form.rowBy(tag: "postcode")
                let countryRow: TextRow? = self.form.rowBy(tag: "country")
                
                let phoneRow: PhoneRow? = self.form.rowBy(tag: "phoneNumber")
                
                if (nameRow!.value! + " " + surnameRow!.value!) != user.displayName {
                    changeRequest?.displayName = nameRow!.value! + " " + surnameRow!.value!
                    self.delegate?.sendUpdatedUsernameToUserDisplay(username: (nameRow!.value! + " " + surnameRow!.value!))
                }
                let userDocument = UserDocument(uid: user.uid)
                userDocument.setUserDocument(name: nameRow!.value!, surname: surnameRow!.value!, email: emailRow!.value!)
            userDocument.setUserExtraData(address: addressRow!.value!, city: cityRow!.value!, postcode: postcodeRow!.value!, country: countryRow!.value!, phoneNumber: phoneRow!.value!)
                changeRequest?.commitChanges { (error) in
                }
            }
        }
    }
    
}
