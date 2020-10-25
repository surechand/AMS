//
//  NewAuctionVCinputExtension.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 17/04/2020.
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
            auctionDocument.deleteAuctionDocument(auction: self.chosenAuction)
        } else {
            chosenAuction.key = getRandomKey()
        }
        
        getPhotoData()
        isValid = self.getData()
        
        if !isValid {
            AlertView.showInvalidDataAlert(view: self, theme: UIColor.systemIndigo)
        } else {
            //            add data to Cloud Firestore
            let user = Auth.auth().currentUser
            if let user = user {
                chosenAuction.sellerId = user.uid
                let auctionDocument = AuctionDocument(key: chosenAuction.key)
                auctionDocument.setAuctionDocument(auction: self.chosenAuction, completion: {
                    let rootVC = self.navigationController!.viewControllers.first as! MyAuctionsVC
                    rootVC.initiateForm()
                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                })
            }
        }
        
    }
    
    //    MARK: Input validation.
    
    func getData () -> Bool {
        let titleRow: TextRow? = form.rowBy(tag: "Title")
        if titleRow!.value == nil {
            return false
        } else {
            self.chosenAuction.name = titleRow!.value!
        }
        let descriptionRow: TextRow? = form.rowBy(tag: "description")
        if descriptionRow!.value == nil {
            return false
        } else {
            self.chosenAuction.description = descriptionRow!.value!
        }
        let parametersRow: TextRow? = form.rowBy(tag: "parameters")
        if parametersRow!.value == nil {
            return false
        } else {
            self.chosenAuction.parameters = parametersRow!.value!
        }
        let startingPriceRow: TextRow? = form.rowBy(tag: "startingPrice")
        if startingPriceRow!.value == nil {
            return false
        } else {
            self.chosenAuction.startingPrice = Int(startingPriceRow!.value!)!
        }
        let finishDateRow: TextRow? = form.rowBy(tag: "finishDate")
        if finishDateRow!.value == nil {
            return false
        } else {
            self.chosenAuction.finishDate = finishDateRow!.value!
        }
        return true
    }
    
    // ja pierdole ale to woła o tablice i mapowanie
    func getPhotoData() {
        let photoOneRow: ImageRow? = form.rowBy(tag: "photo1")
        let photoTwoRow: ImageRow? = form.rowBy(tag: "photo2")
        let photoThreeRow: ImageRow? = form.rowBy(tag: "photo3")
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let photoOneRef = storageRef.child(chosenAuction.key + "/" + photoOneRow!.tag!)
        let photoTwoRef = storageRef.child(chosenAuction.key + "/" + photoTwoRow!.tag!)
        let photoThreeRef = storageRef.child(chosenAuction.key + "/" + photoThreeRow!.tag!)
        if let photoOne = photoOneRow!.value {
            photoOneRef.putData(photoOne.pngData()! as Data, metadata: nil)
        }
        if let photoTwo = photoTwoRow!.value {
            photoTwoRef.putData(photoTwo.pngData()! as Data, metadata: nil)
        }
        if let photoThree = photoThreeRow!.value {
            photoThreeRef.putData(photoThree.pngData()! as Data, metadata: nil)
        }
    }
}
