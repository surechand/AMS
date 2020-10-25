//
//  EditUserDataVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 14/04/2020.
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
    
    override func viewWillDisappear(_ animated: Bool) {
        var allValid = true
        for row in self.form.rows {
            if !row.isValid {
                allValid = false
            }
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
