//
//  RegisterSecondStepVC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 21/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import AnimatedGradientView
import PostalAddressRow

class RegisterSecondStepVC: FormViewController {
    
    @IBOutlet weak var RegisteredButton: UIButton!
    
    
    let viewCustomisation = ViewCustomisation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemIndigo)
        self.initiateAddressForm()
        self.initiateValidationForm()
    }

    
    func initiateAddressForm() {
        form +++
            Section() {
                $0.header = HeaderFooterView<AMSLogoView>(.class)
        }
            
            <<< TextRow("address") {
                $0.title = "Address"
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
            
            <<< TextRow("city") {
                $0.title = "City"
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
        
        <<< TextRow("postcode") {
            $0.title = "Postcode"
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
        
        <<< TextRow("country") {
            $0.title = "Country"
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
        
        <<< PhoneRow("phoneNumber") {
            $0.title = "Phone number"
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
    
    func initiateValidationForm() {
        form
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Register"
            }
            .onCellSelection { cell, row in
                var allValid = true
                let invalidRow = self.form.rows.firstIndex(where: { $0.isValid == false })
                if (invalidRow != nil) { allValid = false }
                if allValid == true {
                    let addressRow: TextRow? = self.form.rowBy(tag: "address")
                    let cityRow: TextRow? = self.form.rowBy(tag: "city")
                    let postcodeRow: TextRow? = self.form.rowBy(tag: "postcode")
                    let countryRow: TextRow? = self.form.rowBy(tag: "country")
                    let phoneRow: PhoneRow? = self.form.rowBy(tag: "phoneNumber")
                    let user = Auth.auth().currentUser
                    if let user = user {
                        // set user document
                        let userDocument = UserDocument(uid: user.uid)
                        userDocument.setUserExtraData(address: addressRow!.value!, city: cityRow!.value!, postcode: postcodeRow!.value!, country: (countryRow?.value!)!, phoneNumber: (phoneRow?.value!)!)
                        self.performSegue(withIdentifier: "RegisteredSegue", sender: self.RegisteredButton)
                    }
                }
            }.cellUpdate { cell, row in
                let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
                self.viewCustomisation.setLabelRowCellProperties(cell: cell, textColor: UIColor.systemIndigo, borderColor: UIColor(patternImage: blueGradientImage!))
        }
    }
}
