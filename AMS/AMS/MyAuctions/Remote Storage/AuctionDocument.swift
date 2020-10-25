//
//  AuctionDocument.swift
//  AMS
//
//  Created by Angelika Jeziorska on 17/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class AuctionDocument : Document {
    
    var collectionRef: CollectionReference? = nil
    
    override init(key: String) {
        super.init(key: key)
        self.collectionRef = db.collection("auctions")
    }
    
    //    MARK: Methods for setting values for auctions.
    
    func setAuctionDocument (auction: Auction, completion: @escaping () -> Void) {
        let batch = db.batch()
        let auctionRef = self.collectionRef!.document(self.key)
        batch.setData([
            "name": auction.name,
            "key": auction.key,
            "description": auction.description,
            "parameters": auction.parameters,
            "shippingDetails": auction.shippingDetails,
            "startingPrice": auction.startingPrice,
            "price": auction.price,
            
            "sellerId": auction.sellerId,
            "buyerId": auction.buyerId,
            "startDate": auction.startDate,
            "finishDate": auction.finishDate
        ], forDocument: auctionRef)
        for bidder in auction.bidders {
            setBiddersDocument(bidder: bidder, rootDoc: self.collectionRef!.document(self.key), batch: batch, completion: {
            })
        }
        batch.commit() { err in
            if let err = err {
                completion()
                print("Error writing batch \(err)")
            } else {
                completion()
                print("Batch write succeeded.")
            }
        }
    }
    
    func setBiddersDocument(bidder: Bidder, rootDoc: DocumentReference, batch: WriteBatch, completion: @escaping () -> Void) {
        let exerciseRef = rootDoc.collection("bidders").document(bidder.id)
        batch.setData([
            "name": bidder.name,
            "surname": bidder.surname,
            "id": bidder.id,
            "offer": bidder.offer,
            "date": bidder.date
        ], forDocument: exerciseRef)
        completion()
    }
    
    //    MARK: Methods for getting the values for auctions.
    
    func getAuctionDocument (completion: @escaping ([Auction]) -> Void)  {
        var loadedAuctions = [Auction]()
        self.collectionRef!.getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(loadedAuctions)
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let auction = Auction(name: "")
                    self.manageLoadedAuctionData(auction: auction, data: document.data())
                    self.getAuctionBidders(auctionKey: auction.key, completion: { bidders in
                        auction.bidders = bidders
                    })
                    loadedAuctions.append(auction)
                }
                completion(loadedAuctions)
            }
        }
    }
    
    //    Assigning data to a auction.
    func manageLoadedAuctionData (auction: Auction, data: [String:Any]) {
        for data in data {
            switch data.key {
            case "name":
                auction.name = data.value as! String
            case "key":
                auction.key = data.value as! String
            case "description":
                auction.description = data.value as! String
            case "parameters":
                auction.parameters = data.value as! String
            case "shippingDetails":
                auction.shippingDetails = data.value as! String
            case "startingPrice":
                auction.startingPrice = data.value as! Double
            case "price":
                auction.price = data.value as! Double
            case "sellerId":
                auction.sellerId = data.value as! String
            case "buyerId":
                auction.buyerId = data.value as! String
            case "startDate":
                auction.startDate = data.value as! String
            case "finishDate":
                auction.finishDate = data.value as! String
            default:
                print("Undefined key.")
            }
        }
    }
    
    func getAuctionBidders (auctionKey: String, completion: @escaping ([Bidder]) -> Void) {
        var bidders = [Bidder]()
        self.collectionRef!.document(auctionKey).collection("bidders").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(bidders)
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let bidder = Bidder()
                    self.manageLoadedBiddereData(bidder: bidder, data: document.data())
                    bidders.append(bidder)
                }
                bidders.sort {
                    $0.date < $1.date
                }
                completion(bidders)
            }
        }
    }
    
    //    Assigning data to an exercise.
    func manageLoadedBiddereData (bidder: Bidder, data: [String:Any]) {
        for data in data {
            switch data.key {
            case "name":
                bidder.name = data.value as! String
            case "surname":
                bidder.surname = data.value as! String
            case "id":
                bidder.id = data.value as! String
            case "offer":
                bidder.offer = data.value as! Int
            case "date":
                bidder.date = data.value as! String
            default:
                print("Undefined key.")
            }
        }
    }
    
    //    MARK: Methods for deleting auctions.
    
    func deleteAuctionDocument (auction: Auction) {
        let batch = db.batch()
        let auctionRef = self.collectionRef!.document(auction.key)
        for bidder in auction.bidders {
            deleteBiddersDocument(bidder: bidder, rootDoc: self.collectionRef!.document(auction.key), batch: batch, completion: {
            })
        }
        batch.deleteDocument(auctionRef)
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
            }
        }
    }
    
    func deleteBiddersDocument(bidder: Bidder, rootDoc: DocumentReference, batch: WriteBatch, completion: @escaping () -> Void) {
        let exerciseRef = rootDoc.collection("bidders").document(bidder.id)
        batch.deleteDocument(exerciseRef)
    }
    
}
