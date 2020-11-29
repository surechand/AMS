//
//  DisplayAuctionVC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 19/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Firebase

class DisplayAuctionVC: UIViewController, passAuction, passTheme, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bidButton: UIButton!
    @IBOutlet weak var offerTextInput: UITextField!
    @IBOutlet weak var auctionDetailsTextView: UITextView!
    @IBOutlet weak var auctionImageView: UIImageView!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var biddersTextView: UITextView!
    let user = Auth.auth().currentUser
    var chosenAuction = Auction(name: "")
    
    var auctionDelegate: passAuction?
    
    var theme: UIColor?
    var gradientImage = UIImage()
    let viewCustomisation = ViewCustomisation()
    
    
    let storage = Storage.storage()
    var imageIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLabels()
        
        self.view.backgroundColor = UIColor.white
        self.setPaddingAndBorders(textField: offerTextInput)
        
        let left = UIScreenEdgePanGestureRecognizer(target : self, action : #selector(self.leftSwipe))
        left.edges = .left
        self.view.addGestureRecognizer(left)
        
        let right = UIScreenEdgePanGestureRecognizer(target : self, action : #selector(self.rightSwipe))
        right.edges = .right
        self.view.addGestureRecognizer(right)
        
        offerTextInput.attributedPlaceholder = NSAttributedString(string: "Enter your offer",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        setImage(index: imageIndex)
    }
    
    @objc
    func leftSwipe(){
        print("left")
        if(imageIndex < 3) {
            imageIndex += 1
            self.setImage(index: imageIndex)
        }
    }
    
    @objc
    func rightSwipe(){
        print("right")
        if(imageIndex != 1) {
            imageIndex += -1
            self.setImage(index: imageIndex)
        }
    }
    
    func setImage(index: Int) {
        let storageRef = storage.reference()
        let imgRef = storageRef.child(self.chosenAuction.key + "/photo" + String(imageIndex) + ".jpeg")
        self.auctionImageView.sd_setImage(with: imgRef, placeholderImage: UIImage(systemName: "bag"))
    }
    
    func setTextViewAppearance(textView: UITextView) {
        textView.delegate  = self
        textView.showsHorizontalScrollIndicator = false
        //        textView.adjustUITextViewHeight()
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.borderWidth = 2.5
        setLayerShadow(layer: textView.layer)
        textView.clipsToBounds = true
        textView.textColor = .white
    }
    
    func setButtons () {
        if let user = user {
            bidButton.isEnabled =  Date() < self.chosenAuction.dateFromString(string: self.chosenAuction.finishDate)! || user.uid != self.chosenAuction.sellerId
            
            endButton.isHidden = !(self.chosenAuction.sellerId == user.uid && Date() < self.chosenAuction.dateFromString(string: self.chosenAuction.finishDate)!)
        }
        bidButton.layer.borderColor = bidButton.isEnabled ? UIColor.white.cgColor : UIColor.gray.cgColor
        bidButton.layer.borderWidth = 2.5
        bidButton.setTitle("BID", for: .normal)
        bidButton.setTitleColor(bidButton.isEnabled ? .white : UIColor.gray, for: .normal)
        setLayerShadow(layer: bidButton.layer)
        setLayerShadow(layer: endButton.layer)
    }
    
    
    
    func auctionFinished() {
        let auctionDocument = AuctionDocument(key: self.chosenAuction.key)
        auctionDocument.getHighestBidder(completion: { id in
            self.chosenAuction.buyerId = id
            self.biddersTextView.text = ""
            if (self.chosenAuction.buyerId != "") {
                self.biddersTextView.text += "Your auction has ended. The buyer is: \n"
                let userDocument = UserDocument(uid: id)
                userDocument.getUserDocument(handler: { data in
                    self.biddersTextView.text += (data["name"] as! String) + " " + (data["surname"] as! String)
                    self.biddersTextView.text += (data["email"] as! String) + "\n" + (data["phoneNumber"] as! String)
                    self.setTextViewAppearance(textView: self.biddersTextView)
                })
            } else { self.biddersTextView.text += "Your auction has ended. There is no buyer."
            }
            self.setTextViewAppearance(textView: self.biddersTextView)
        })
    }
    
    func setPaddingAndBorders (textField: UITextField) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 2.5
    }
    
    func setLayerShadow (layer: CALayer) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2.5
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.masksToBounds = false
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenAuction: Auction) {
        self.chosenAuction = chosenAuction
        loadAfterPassing()
    }
    
    func finishPassing(theme: UIColor, gradient: UIImage) {
        self.theme = theme
        self.gradientImage = gradient
    }
    
    func finishPassingFromAuctions(chosenAuction: Auction) {
        self.chosenAuction = chosenAuction
        self.theme = .systemPink
        gradientImage = CAGradientLayer.pinkGradient(on: self.view)!
        loadAfterPassing()
    }
    
    func loadAfterPassing() {
        if let user = user {
            self.chosenAuction.sellerId == user.uid && Date() > self.chosenAuction.dateFromString(string: self.chosenAuction.finishDate)! ? self.auctionFinished() : self.loadBidders()
        }
        self.setButtons()
        self.loadAuctionDetails()
        self.viewDidLoad()
    }
    
    //    MARK: Assigning data to labels and text views.
    
    func setLabels () {
        titleLabel.text = " " +  self.chosenAuction.name + " "
        titleLabel.layer.borderColor = UIColor.white.cgColor
        titleLabel.layer.borderWidth = 2.5
        setLayerShadow(layer: titleLabel.layer)
        titleLabel.textColor = .white
        
        dateLabel.text = " " + self.chosenAuction.basicDateFromString(string: self.chosenAuction.startDate) + " - " + self.chosenAuction.basicDateFromString(string: self.chosenAuction.finishDate)
        dateLabel.textColor = .white
        setLayerShadow(layer: dateLabel.layer)
        
        setLayerShadow(layer: offerTextInput.layer)
    }
    
    func loadAuctionDetails () {
        auctionDetailsTextView.text += "\n"
        auctionDetailsTextView.text += "Description: " + String(self.chosenAuction.description) + "\n"
        auctionDetailsTextView.text += "Parameters: " + String(self.chosenAuction.parameters) + "\n"
        auctionDetailsTextView.text += "Shipping details: " + String(self.chosenAuction.shippingDetails) + "\n"
        self.setTextViewAppearance(textView: auctionDetailsTextView)
    }
    
    func loadBidders () {
        self.biddersTextView.text = ""
        if (chosenAuction.bidders.isEmpty) {
            biddersTextView.text += "There are no bidders yet."
        } else {
            for bidder in chosenAuction.bidders {
                biddersTextView.text += "\n" + String(bidder.offer) + "€         " + self.chosenAuction.basicDateFromString(string: bidder.date)
            }
            biddersTextView.text += "\n"
        }
        self.setTextViewAppearance(textView: biddersTextView)
    }
    
    @IBAction func endButtonPressed(_ sender: UIButton) {
        if let user = user {
            if Date() < chosenAuction.dateFromString(string: chosenAuction.finishDate)! {
                let confirmAlert = UIAlertController(title: "End auction?", message: "Do you really want to manually end auction?", preferredStyle: .alert)
                confirmAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] alert in
                    // Ending auction
                    
                    // Finish date setting
                    self.chosenAuction.finishDate = self.chosenAuction.stringFromDate(date: Date())
                    
                    // Setting end price and winner
                    if self.chosenAuction.bidders.isNotEmpty {
                        let sortedBidders = self.chosenAuction.bidders.sorted(by: { $0.offer > $1.offer })
                        self.chosenAuction.price = sortedBidders.first!.offer
                        self.chosenAuction.buyerId = sortedBidders.first!.id
                    } else {
                        self.chosenAuction.price = self.chosenAuction.startingPrice
                    }
                    
                    let auctionDocument = AuctionDocument(key: self.chosenAuction.key)
                    auctionDocument.updateAuctionDocument(auction: self.chosenAuction, completion: { self.dismiss(animated: true, completion: nil) })
                }))
                confirmAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                
                self.present(confirmAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func placeBid(_ sender: Any) {
        if(!(offerTextInput.text?.isEmpty ?? false)) {
            let bidder = Bidder()
            bidder.offer = Double(offerTextInput.text!)!
            let isBigger = chosenAuction.bidders.map{ $0.offer < bidder.offer }.allSatisfy({ $0 })
            if isBigger || chosenAuction.bidders.isEmpty {
                bidder.date = self.chosenAuction.stringFromDate(date: Date())
                //self.chosenAuction.bidders.append(bidder)
                let auctionDocument = AuctionDocument(key: chosenAuction.key)
                if let user = user {
                    bidder.id = user.uid
                    auctionDocument.setBiddersDocument(bidderId: user.uid, bidder: bidder, auctionKey: chosenAuction.key, completion: {
                        self.chosenAuction.bidders.append(bidder)
                        self.chosenAuction.price = bidder.offer
                        auctionDocument.setUserBidsDocument(uid: user.uid, bidder: bidder, auctionKey: self.chosenAuction.key, completion: { self.loadBidders()})
                    })
                }
            }
        }
    }
    
}

//MARK: - UITextView extension for height adjustment.
extension UITextView{
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
    func adjustUITextViewHeight()
    {
        var frame = self.frame
        if self.contentSize.height < 250 {
            frame.size.height = self.contentSize.height
        } else {
            frame.size.height = 250
        }
        self.frame = frame
        
    }
    
}
