//
//  PlansVC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 08/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class AuctionsVC: FormViewController {
    
    @IBOutlet weak var NewAuctionButton: UIButton!
    @IBOutlet weak var UserProfileButton: UIButton!
    
    let viewCustomisation = ViewCustomisation()
    var auctionDelegate: passAuction?
    var themeDelegate: passTheme?
    
    var auctions = [Auction]()
    var chosenAuction = Auction(name: "")
    var chosenAuctionIndex: Int?
    
    // search controller's properties
    let searchController = UISearchController(searchResultsController: nil)
    var originalOptions = [AuctionRow]()
    var currentOptions = [AuctionRow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initiateForm()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewCustomisation.setPinkGradients(viewController: self)
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassingWithIndex(chosenAuction: Auction, chosenAuctionIndex: Int?) {
        self.chosenAuction = chosenAuction
        self.chosenAuctionIndex = chosenAuctionIndex
        print("finished passing")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? NewAuctionVC{
            self.auctionDelegate = destinationVC
            self.auctionDelegate?.finishPassing(chosenAuction: chosenAuction)
        } else if let destinationVC = segue.destination as? DisplayAuctionVC{
            self.auctionDelegate = destinationVC
            self.auctionDelegate?.finishPassing(chosenAuction: chosenAuction)
        } else if let destinationVC = segue.destination as? DisplayProfileVC{
            self.themeDelegate = destinationVC
            self.themeDelegate?.finishPassing(theme: UIColor.systemIndigo, gradient: CAGradientLayer.blueGradient(on: self.view)!)
        }
    }
    //    MARK: Form handling.
    
    @IBAction func addNewAuction(_ sender: Any) {
        UIView.setAnimationsEnabled(false)
        let newAuction = Auction(name: "")
        self.auctions.append(newAuction)
        self.chosenAuction = auctions.last!
        self.chosenAuctionIndex = auctions.count-1
        UIView.setAnimationsEnabled(true)
        self.performSegue(withIdentifier: "NewAuctionSegue", sender: nil)
    }
    
    func initiateForm () {
        let user = Auth.auth().currentUser
        if let user = user {
            let auctionDocument = AuctionDocument(key: chosenAuction.key)
            auctionDocument.getAuctionDocument(completion: { loadedAuctions in
                self.auctions = loadedAuctions
                UIView.setAnimationsEnabled(false)
                self.form.removeAll()
                self.originalOptions.removeAll()
                self.currentOptions.removeAll()
                for (index, auction) in self.auctions.enumerated() {
                    self.form +++
                        AuctionRow () {
                            self.originalOptions.append($0)
                            $0.type = String(auction.type)
                            $0.tag = String(index)
                            $0.title = auction.name
                            $0.onCellSelection(self.assignCellRow)
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textColor = UIColor.systemIndigo
                            cell.indentationLevel = 2
                            cell.indentationWidth = 10
                            cell.textLabel!.textAlignment = .left
                        }.cellSetup { cell, _ in
                            cell.configure(with: AuctionCellModel(auctionName: auction.name, price: auction.price, auctionImageReference: auction.key + "/photo1.jpeg"))
                            let blueGradientImage = CAGradientLayer.blueGradient(on: self.view)
                            cell.backgroundColor = UIColor.white
                            cell.layer.borderColor = UIColor(patternImage: blueGradientImage!).cgColor
                            cell.layer.borderWidth = 3.0
                    }
                }
                UIView.setAnimationsEnabled(true)
                self.tableView.reloadData()
                self.viewDidAppear(false)
            })
        }
    }
    
    func assignCellRow(cell: AuctionCell, row: AuctionRow) {
        row.deselect()
        self.chosenAuctionIndex = Int(row.tag!)
        self.chosenAuction = auctions[self.chosenAuctionIndex!]
        self.performSegue(withIdentifier: "DisplayAuctionSegue", sender: self.NewAuctionButton)
    }
    
    func reIndex() {
        for (index, row) in self.form.rows.enumerated() {
            row.tag = String(index)
        }
    }
    
}

