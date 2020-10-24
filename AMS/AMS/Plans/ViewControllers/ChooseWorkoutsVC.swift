//
//  ChooseAuctionsVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 05/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Firebase

class ChooseAuctionsVC: FormViewController, passPlan, passWeek, passDay {
    
    var auctionDelegate: passAuctionFromPlans?
    var chosenAuction = Auction(name: "")
    var auctions = [Auction]()
    
    let viewCustomisation = ViewCustomisation()
    
    let auctionsSelectable = SelectableSection<ImageCheckRow<String>>("Swipe right for auction preview", selectionType: .multipleSelection)
    
    var chosenPlan = Plan (name: "")
    var chosenPlanIndex: Int?
    var chosenWeek = Week()
    var chosenWeekIndex: Int?
    var chosenDay = Day()
    var chosenDayIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewCustomisation.customiseTableView(tableView: self.tableView, themeColor: UIColor.systemPink)
        
        self.createSelectableAuctionForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewCustomisation.setPinkGradients(viewController: self)
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenDay: Day, chosenDayIndex: Int?) {
        
        self.chosenDay = chosenDay
        self.chosenDayIndex = chosenDayIndex
    }
    
    func finishPassing(chosenPlan: Plan, chosenPlanIndex: Int?) {
        self.chosenPlan = chosenPlan
        self.chosenPlanIndex = chosenPlanIndex
    }
    
    func finishPassing(chosenWeek: Week, chosenWeekIndex: Int?) {
        self.chosenWeek = chosenWeek
        self.chosenWeekIndex = chosenWeekIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DisplayAuctionVC{
            self.auctionDelegate = destinationVC
            self.auctionDelegate?.finishPassingFromPlans(chosenAuction: self.chosenAuction)
        }
    }
    
    //    MARK: Form handling.
    
    func createSelectableAuctionForm () {
        let user = Auth.auth().currentUser
        if let user = user {
            let auctionDocument = AuctionDocument(key: chosenAuction.key)
            auctionDocument.getAuctionDocument(completion: { loadedAuctions in
                self.auctions = loadedAuctions
                print(loadedAuctions.count)
                let infoAction = SwipeAction(
                    style: .normal,
                    title: "Info",
                    handler: { (action, row, completionHandler) in
                        for (index, auction) in self.auctions.enumerated()  {
                            if auction.name + String(index) == row.tag {
                                self.chosenAuction = self.auctions[index]
                                self.performSegue(withIdentifier: "DisplayAuctionSegueFromChecklist", sender: self)
                                completionHandler?(true)
                            }
                        }
                })
                infoAction.actionBackgroundColor = .lightGray
                infoAction.image = UIImage(systemName: "info")
                
                self.form +++ self.auctionsSelectable
                for (index, auction) in self.auctions.enumerated()  {
                    self.form.last! <<< ImageCheckRow<String>(auction.name + String(index)){ lrow in
                        lrow.title = auction.name
                        lrow.selectableValue = auction.name
                        lrow.value = nil
                        lrow.leadingSwipe.actions = [infoAction]
                        lrow.leadingSwipe.performsFirstActionWithFullSwipe = true
                        for alreadyChosenAuction in self.chosenPlan.weeks[self.chosenWeekIndex!].days[(self.chosenDayIndex)!].auctions {
                            if auction.name == alreadyChosenAuction.name {
                                lrow.value = auction.name
                                lrow.didSelect()
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                self.viewDidAppear(false)
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.chosenPlan.weeks[self.chosenWeekIndex!].days[(self.chosenDayIndex)!].auctions.removeAll()
        for auction in self.auctions {
            for selectableAuctionRow in auctionsSelectable.selectedRows() {
                if selectableAuctionRow.title! == auction.name {
                    self.chosenPlan.weeks[self.chosenWeekIndex!].days[(self.chosenDayIndex)!].auctions.append(auction)
                }
            }
        }
    }
    
}
