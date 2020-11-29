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
    
    func updateAuctionDocument(auction: Auction, completion: @escaping () -> Void) {
        let auctionRef = self.collectionRef?.document(self.key)
        
        auctionRef?.updateData([
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
        ]) { err in
            if let err = err {
                print("Error updating auction document: \(err)")
            } else {
                print("Auction document updated")
                completion()
            }
        }
        
        
    }
    
    func setBiddersDocument(bidderId: String, bidder: Bidder, auctionKey: String, completion: @escaping () -> Void) {
        let reference = self.collectionRef!.document(auctionKey).collection("bidders").document(getRandomKey())
        self.getHighestBid(completion: { bid in
            if(bidder.offer > bid && bid != Double(-1)) {
                let batch = self.db.batch()
                batch.setData([
                    "price": bidder.offer,
                    "date": bidder.date,
                    "id": bidder.id
                ], forDocument: reference)
                batch.commit() { err in
                    if let err = err {
                        completion()
                        print("Error writing batch \(err)")
                    } else {
                        completion()
                        print("Batch write succeeded.")
                    }
                }
            } else {
                print("Price too low.")
            }
        })
    }
    
    func setUserBidsDocument(uid: String, bidder: Bidder, auctionKey: String, completion: @escaping () -> Void) {
        let batch = db.batch()
        let userBidsRef = db.collection("users").document(uid).collection("bids").document(getRandomKey())
        batch.setData([
            "price": bidder.offer,
            "date": bidder.date,
            "auctionId": auctionKey
        ], forDocument: userBidsRef)
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
    
    func getMyAuctionsDocument (uid: String, completion: @escaping ([Auction]) -> Void) {
        var loadedAuctions = [Auction]()
        let userBidsQuery = db.collection("users").document(uid).collection("bids")
        
        userBidsQuery.getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var processedAuctionsIds = [String]()
                for document in querySnapshot!.documents {
                    if let auctionId = document.data()["auctionId"] as? String {
                        if auctionId != "" && !processedAuctionsIds.contains(where: { $0 == auctionId }) {
                            processedAuctionsIds.append(auctionId)
                        }
                    }
                }
                
                self.collectionRef?.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let auction = Auction(name: "")
                            self.manageLoadedAuctionData(auction: auction, data: document.data())
                            self.getAuctionBidders(auctionKey: auction.key, completion: { bidders in
                                auction.bidders = bidders
                            })
                            if auction.sellerId == uid {
                                if auction.compareDates(startDate: auction.stringFromDate(date: Date()), finishDate: auction.finishDate) {
                                    auction.type = "Sold"
                                } else {
                                    auction.type = "Selling"
                                }
                                loadedAuctions.append(auction)
                            } else if auction.buyerId == uid {
                                auction.type = "Sold"
                                loadedAuctions.append(auction)
                            } else if processedAuctionsIds.contains(where: { $0 == auction.key }) {
                                auction.type = "Bidding"
                                loadedAuctions.append(auction)
                            }
                        }
                        completion(loadedAuctions)
                    }
                }
            }
        }
    }
    
    func getHighestBidder(completion: @escaping (String) -> Void) {
        (self.collectionRef?.document(self.key).collection( "bidders").order(by: "price", descending: true).limit(to: 1))!.getDocuments(completion: { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                for data in document.data() {
                    if (data.key == "id") {
                        completion(data.value as! String)
                    }
                }
            }})
        completion("")
    }
    
    func getHighestBid(completion: @escaping (Double) -> Void) {
        (self.collectionRef?.document(self.key).collection( "bidders").order(by: "price", descending: true).limit(to: 1))!.getDocuments(completion: { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                for data in document.data() {
                    print("bid")
                    print(data.value)
                    if (data.key == "price") {
                        print(data.value)
                        completion(data.value as! Double)
                    }
                }
            }})
        completion(Double(-1))
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
            case "price":
                bidder.offer = data.value as! Double
            case "date":
                bidder.date = data.value as! String
            case "id":
                bidder.id = data.value as! String
            default:
                print("Undefined key.")
            }
        }
    }
    
    //    MARK: Methods for deleting auctions.
    
    func deleteAuctionDocument (uid: String, auction: Auction) {
        let batch = db.batch()
        let auctionRef = self.collectionRef!.document(auction.key)
        for bidder in auction.bidders {
            deleteBiddersDocument(bidder: bidder, rootDoc: self.collectionRef!.document(auction.key), batch: batch, completion: {
            })
        }
        deleteUserBids(auction: auction, uid: uid, completion: { })
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
        rootDoc.collection("bidders").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
    
    func deleteUserBids(auction: Auction, uid: String, completion: @escaping () -> Void) {
        let userBidRef = db.collection("users").document(uid).collection("bids").whereField("auctionId", isEqualTo: auction.key)
        
        userBidRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Failed to delete user Bids, \(err)")
            } else {
                querySnapshot?.documents.forEach({
                    $0.reference.delete()
                })
            }
        }
    }
}
