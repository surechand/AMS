//
//  AuctionsVC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 08/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//
import UIKit
import Eureka
import Firebase

class MyAuctionsVC: FormViewController {
    
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
    var scopeTitles = ["All", "Selling", "Bidding", "Sold"]
    // All - sellerId, buyerId, in bidders; Selling - sellerId; Bidding - buyerId, in bidders; Sold - sellerId, finishDate < Date
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.searchControllerSetup()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        let user = Auth.auth().currentUser
        if(user == nil) {
            print("not logged")
            UIView.setAnimationsEnabled(false)
            self.performSegue(withIdentifier: "LoginScreenSegue", sender: self)
            UIView.setAnimationsEnabled(true)
        }
        
        self.initiateForm()
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.AMSColors.yellow)
        self.tableView.separatorStyle = .none
        
        self.viewCustomisation.setYellowBackgroundGradient(view: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.currentOptions = self.originalOptions
        self.viewCustomisation.setYellowGradients(viewController: self)
        
    }
    
    func searchControllerSetup () {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.scopeButtonTitles = scopeTitles
        for subView in searchController.searchBar.subviews {
            if let scopeBar = subView as? UISegmentedControl {
                scopeBar.backgroundColor = UIColor.white
                scopeBar.tintColor = UIColor.systemYellow
            }
        }
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemYellow], for: .selected)
        searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        if let topView = searchController.searchBar.subviews.first {
            for subView in topView.subviews {
                if let cancelButton = subView as? UIButton {
                    cancelButton.tintColor = UIColor.white
                    cancelButton.isEnabled = true
                }
            }
        }
        searchController.searchBar.delegate = self
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.AMSColors.transparentWhite
            textfield.tintColor = UIColor.systemYellow
            textfield.textColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
            }
        }
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
            self.themeDelegate = destinationVC
            self.auctionDelegate?.finishPassing(chosenAuction: chosenAuction)
            self.themeDelegate?.finishPassing(theme: UIColor.AMSColors.yellow, gradient: UIImage())
        } else if let destinationVC = segue.destination as? DisplayAuctionVC{
            self.auctionDelegate = destinationVC
            self.auctionDelegate?.finishPassing(chosenAuction: chosenAuction)
        } else if let destinationVC = segue.destination as? DisplayProfileVC{
            self.themeDelegate = destinationVC
            self.themeDelegate?.finishPassing(theme: UIColor.AMSColors.yellow, gradient: CAGradientLayer.yellowGradient(on: self.view)!)
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
            auctionDocument.getMyAuctionsDocument(uid: user.uid, completion: { loadedAuctions in
                self.auctions = loadedAuctions
                UIView.setAnimationsEnabled(false)
                self.form.removeAll()
                self.originalOptions.removeAll()
                self.currentOptions.removeAll()
                let dateConverter = DateConversion()
                for (index, auction) in self.auctions.enumerated() {
                    self.form +++
                        AuctionRow () {
                            self.originalOptions.append($0)
                            $0.type = String(auction.type)
                            $0.tag = String(index)
                            $0.title = auction.name
                            $0.onCellSelection(self.assignCellRow)
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textColor = UIColor.white
                            cell.indentationLevel = 2
                            cell.indentationWidth = 10
                            cell.textLabel!.textAlignment = .left
                        }.cellSetup { cell, _ in
                            cell.configure(with: AuctionCellModel(auctionName: auction.name, price: auction.price, auctionImageReference: auction.key + "/photo1.jpeg", auctionEndDate: dateConverter.dateFromString(string: auction.finishDate)))
                            cell.backgroundColor = UIColor.AMSColors.transparentWhite
                            cell.layer.borderColor = UIColor.white.cgColor
                            cell.layer.borderWidth = 2.5
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
