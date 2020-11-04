//
//  NewAuctionVCinputExtension.swift
//  AMS
//
//  Created by Angelika Jeziorska on 17/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase
import ImageRow

extension NewAuctionVC {
    
    //    MARK: Input handling.
    
    @objc func checkInput (sender: UIBarButtonItem) {
        
        var isValid = true
        
        if chosenAuction.key != "" {
            let auctionDocument = AuctionDocument(key: chosenAuction.key)
            auctionDocument.deleteAuctionDocument(uid: Auth.auth().currentUser!.uid, auction: self.chosenAuction)
        } else {
            chosenAuction.key = getRandomKey()
        }
        
        isValid = self.getData()
        
        if !isValid {
            AlertView.showInvalidDataAlert(view: self, theme: themeColor!)
        } else {
            //            add data to Cloud Firestore
            savePhotoData()
            let user = Auth.auth().currentUser
            if let user = user {
                chosenAuction.sellerId = user.uid
                let auctionDocument = AuctionDocument(key: chosenAuction.key)
                auctionDocument.setAuctionDocument(auction: self.chosenAuction, completion: {
                    let rootVC = self.navigationController!.viewControllers.first as! MyAuctionsVC
                    let secondVC = (self.tabBarController?.viewControllers![1] as! UINavigationController).children[0] as! AuctionsVC
                    rootVC.initiateForm()
                    secondVC.initiateForm()
                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                })
            }
        }
        
    }
    
    //    MARK: Input validation.
    
    func getData () -> Bool {
        let converter = DateFns()
        let titleRow: TextRow? = form.rowBy(tag: "Title")
        if titleRow!.value == nil {
            return false
        } else {
            self.chosenAuction.name = titleRow!.value!
        }
        let descriptionRow: TextAreaRow? = form.rowBy(tag: "description")
        if descriptionRow!.value == nil {
            return false
        } else {
            self.chosenAuction.description = descriptionRow!.value!
        }
        let parametersRow: TextAreaRow? = form.rowBy(tag: "parameters")
        if parametersRow!.value == nil {
            return false
        } else {
            self.chosenAuction.parameters = parametersRow!.value!
        }
        let shippingDetailsRow: TextAreaRow? = form.rowBy(tag: "shippingDetails")
        if shippingDetailsRow!.value == nil {
            return false
        } else {
            self.chosenAuction.shippingDetails = shippingDetailsRow!.value!
        }
        let startingPriceRow: DecimalRow? = form.rowBy(tag: "startingPrice")
        if startingPriceRow!.value == nil {
            return false
        } else {
            self.chosenAuction.startingPrice = startingPriceRow!.value!
            self.chosenAuction.price = self.chosenAuction.startingPrice
        }
        let finishDateRow: DateTimeInlineRow? = form.rowBy(tag: "finishDate")
        if finishDateRow!.value == nil {
            return false
        } else {
            let finishDate = finishDateRow?.value
            self.chosenAuction.finishDate = converter.stringFromDate(date: finishDate!)
        }
        self.chosenAuction.startDate = converter.stringFromDate(date: Date())
        return true
    }
    
    // ja pierdole ale to woła o tablice i mapowanie
    func savePhotoData() {
        let photoOneRow: ImageRow? = form.rowBy(tag: "photo1")
        let photoTwoRow: ImageRow? = form.rowBy(tag: "photo2")
        let photoThreeRow: ImageRow? = form.rowBy(tag: "photo3")
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoOneRef = storageRef.child(chosenAuction.key + "/" + photoOneRow!.tag! + ".jpeg")
        let photoTwoRef = storageRef.child(chosenAuction.key + "/" + photoTwoRow!.tag! + ".jpeg")
        let photoThreeRef = storageRef.child(chosenAuction.key + "/" + photoThreeRow!.tag! + ".jpeg")
        if let photoOne = photoOneRow!.value {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            photoOneRef.putData(photoOne.jpegData(compressionQuality: 0.5)! as Data, metadata: metadata)
        }
        if let photoTwo = photoTwoRow!.value {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            photoTwoRef.putData(photoTwo.jpegData(compressionQuality: 0.5)! as Data, metadata: metadata)
        }
        if let photoThree = photoThreeRow!.value {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            photoThreeRef.putData(photoThree.jpegData(compressionQuality: 0.5)! as Data, metadata: metadata)
        }
    }
}
