//
//  DataClasses.swift
//  AMS
//
//  Created by Angelika Jeziorska on 22/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation

class Auction: DateFns, SearchItem, Equatable, CustomStringConvertible {
    static func == (lhs: Auction, rhs: Auction) -> Bool {
        return true
    }
    
    var name: String
    var key: String
    // user's auctions, auctions user's bidding in, winning
    var type: String
    var description: String
    var parameters: String
    var shippingDetails: String
    var startingPrice: Double
    var price: Double
    
    var sellerId: String
    var buyerId: String
    
    var startDate: String
    var finishDate: String
    
    var bidders = [Bidder]()
    
    init(name: String) {
        self.name = name
        self.type = ""
        self.description = ""
        self.parameters = ""
        self.shippingDetails = ""
        self.startingPrice = 0
        self.price = startingPrice
        
        self.sellerId = ""
        self.buyerId = ""
        self.startDate = ""
        self.finishDate = ""
        self.key = ""
    }
    
    func addBidder (bidder: Bidder) {
        self.bidders.append(bidder)
    }
    
    func assign(auctionToAssign: Auction) {
        self.name = auctionToAssign.name
        self.key = auctionToAssign.key
        self.type = auctionToAssign.type
        self.description = auctionToAssign.description
        self.parameters = auctionToAssign.parameters
        self.startingPrice = auctionToAssign.price
        self.price = auctionToAssign.price
        self.shippingDetails = auctionToAssign.shippingDetails
        self.sellerId = auctionToAssign.sellerId
        self.buyerId = auctionToAssign.buyerId
        self.startDate = auctionToAssign.startDate
        self.finishDate = auctionToAssign.finishDate
        self.bidders = auctionToAssign.bidders
    }
    
    func matchesSearchQuery(_ query: String) -> Bool {
        return name.lowercased().contains(query.lowercased())
    }
    
    func matchesScope(_ type: String) -> Bool {
        return self.type == type
    }
}


class Bidder {
    var offer: Double
    var date: String
    
    init() {
        self.offer = 0
        self.date = ""
    }
    
    func assign(bidderToAssign: Bidder) {
        self.offer = bidderToAssign.offer
        self.date = bidderToAssign.date
    }
}
