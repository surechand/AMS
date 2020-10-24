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
        
        
        isValid = self.getTitle()
        
        print(isValid)
        if !isValid {
            AlertView.showInvalidDataAlert(view: self, theme: UIColor.systemIndigo)
        } else {
            //            add data to Cloud Firestore
            let user = Auth.auth().currentUser
            if let user = user {
                chosenAuction.buyerId = user.uid
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
    
    func getTitle () -> Bool {
        let titleRow: TextRow? = form.rowBy(tag: "Title")
        if titleRow!.value == nil {
            return false
        } else {
            self.chosenAuction.name = titleRow!.value!
            return true
        }
    }
}
