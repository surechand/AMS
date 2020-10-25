//
//  NewAuction.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/02/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import ImageRow

class NewAuctionVC: FormViewController, passAuction {
    
    let viewCustomisation = ViewCustomisation()
    var chosenRow: ButtonRowOf<String>?
    
    var chosenAuction = Auction(name: "")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.replaceBackButton()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemIndigo)
        
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
        self.viewCustomisation.setBlueGradients(viewController: self)
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenAuction: Auction) {
        self.chosenAuction = chosenAuction
        print("finished passing")
    }
    
    //    MARK: Form handling.
    
    func createAuctionTitleForm () {
        let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
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
                cell.textField!.textColor = UIColor.systemIndigo
                self.viewCustomisation.setLabelRowCellProperties(cell: cell, textColor: UIColor.systemIndigo, borderColor: UIColor(patternImage: blueGradientImage!))
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
            
            TextRow("description") {
                $0.title = "Description"
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
            
            <<< TextRow("parameters") {
                $0.title = "Parameters"
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
        
        <<< TextRow("shippingDetails") {
            $0.title = "Shipping details"
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
        
        <<< TextRow("startingPrice") {
            $0.title = "Starting price"
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
        
        <<< TextRow("finishDate") {
            $0.title = "Finish date"
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
    
    func initiatePictureForm() {
        form +++
         ImageRow() {
            $0.tag = "photo1"
            $0.title = "Auction image 1"
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
    
}
