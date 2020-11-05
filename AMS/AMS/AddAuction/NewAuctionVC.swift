//
//  NewAuction.swift
//  AMS
//
//  Created by Angelika Jeziorska on 17/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class NewAuctionVC: FormViewController, passAuction, passTheme {
    let viewCustomisation = ViewCustomisation()
    var chosenRow: ButtonRowOf<String>?
    var chosenAuction = Auction(name: "")
    
    var themeColor: UIColor?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.replaceBackButton()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: themeColor!)
        
        createAuctionTitleForm()
        initiateAuctionForm()
        initiatePictureForm()
        
    }
    
    func replaceBackButton () {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.checkInput(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if themeColor == UIColor.AMSColors.lighterBlue {
            self.viewCustomisation.setBlueGradients(viewController: self)
        } else if themeColor == UIColor.AMSColors.yellow {
            self.viewCustomisation.setYellowGradients(viewController: self)
        }
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenAuction: Auction) {
        self.chosenAuction = chosenAuction
        print("finished passing")
    }
    
    //    MARK: Form handling.
    
    func createAuctionTitleForm () {
        form +++
            
            TextRow("Title").cellSetup { cell, row in
                row.add(rule: RuleRequired())
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
                if (self.chosenAuction.name != "Auction" && self.chosenAuction.name != "") {
                    cell.textField!.placeholder = self.chosenAuction.name
                    row.value = self.chosenAuction.name
                }
                else {
                    cell.textField.placeholder = row.tag
                }
                self.viewCustomisation.setLabelRowCellProperties(cell: cell, textColor: UIColor.black, borderColor: self.themeColor!)
            }.onRowValidationChanged { cell, row in
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
    
    func initiateAuctionForm() {
        form +++
            LabelRow() {
                $0.title = "Item Description"
                $0.cell.height = { 30 }
            }
            <<< TextAreaRow("description") {
                $0.placeholder = "Item Description..."
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 80)
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.placeholderLabel?.textColor = .red
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
            
            <<< LabelRow() {
                $0.title = "Item Parameters"
                $0.cell.height = { 30 }
            }
            <<< TextAreaRow("parameters") {
                $0.placeholder = "Parameters..."
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 80)
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.placeholderLabel?.textColor = .red
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
        
            <<< LabelRow() {
                $0.title = "Shipping Details"
                $0.cell.height = { 30 }
            }
            <<< TextAreaRow("shippingDetails") {
                $0.placeholder = "Shipping details..."
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 80)
            }
            .cellUpdate { cell, row in
                if !row.isValid {
                    cell.placeholderLabel?.textColor = .red
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
            
            <<< DecimalRow("startingPrice") {
                $0.title = "Starting Price"
                $0.add(rule: RuleGreaterThan(min: 0.0, msg: "Price too low!", id: ""))
                $0.validationOptions = .validatesOnChange
                $0.value = 0.0
            }
            .cellSetup({ cell, row in
                let priceFormatter = DecimalFormatter()
                priceFormatter.numberStyle = .currency
                priceFormatter.currencyDecimalSeparator = "."
                priceFormatter.currencySymbol = "€"
                
                row.formatter = priceFormatter
                row.useFormatterDuringInput = true
                row.useFormatterOnDidBeginEditing = true
            })
            .cellUpdate({ cell, row in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            })
            .onRowValidationChanged({ cell, row in
                let rowIndex = row.indexPath!.row
                while row.section!.count > rowIndex + 1 && row.section?[rowIndex + 1] is LabelRow {
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
            })
            
        <<< DateTimeInlineRow("finishDate") {
            $0.title = "Finish date"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnChange
            $0.value = Date(timeIntervalSinceNow: TimeInterval(600))
        }
        .cellUpdate({ cell, row in
            row.minimumDate = Date(timeIntervalSinceNow: TimeInterval(600))
            if !row.isValid {
                cell.textLabel?.textColor = .red
            }
        })
        .onRowValidationChanged({ cell, row in
            let rowIndex = row.indexPath!.row
            while row.section!.count > rowIndex + 1 && row.section?[rowIndex + 1] is LabelRow {
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
        })
    }
    
    func initiatePictureForm() {
        form +++
         ImageRow() {
            $0.tag = "photo1"
            $0.title = "Auction image 1 (miniature)"
            $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
            $0.clearAction = .yes(style: .default)
        }
        <<< ImageRow() {
            $0.tag = "photo2"
            $0.title = "Auction image 2"
            $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
            $0.clearAction = .yes(style: .default)
        }
        <<< ImageRow() {
            $0.tag = "photo3"
            $0.title = "Auction image 3"
            $0.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
            $0.clearAction = .yes(style: .default)
        }
    }
    
    func finishPassing(theme: UIColor, gradient: UIImage) {
        self.themeColor = theme
    }
    
}
