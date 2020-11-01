//
//  DisplayAuctionVC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 19/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Firebase

class DisplayAuctionVC: UIViewController, passAuction, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bidButton: UIButton!
    @IBOutlet weak var offerTextInput: UITextField!
    @IBOutlet weak var auctionDetailsTextView: UITextView!
    @IBOutlet weak var auctionImageView: UIImageView!
    
    @IBOutlet weak var biddersTextView: UITextView!
    var chosenAuction = Auction(name: "")
    
    var auctionDelegate: passAuction?
    
    var theme: UIColor?
    var gradientImage = UIImage()
    
    var imageIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLabels()
        
        self.view.backgroundColor = UIColor.white
        self.setPaddingAndBorders(textField: offerTextInput)
        
        offerTextInput.attributedPlaceholder = NSAttributedString(string: "Enter your offer",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        self.setButton()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child(self.chosenAuction.key + "/photo" + String(imageIndex) + ".jpeg")
        self.auctionImageView.sd_setImage(with: imgRef, placeholderImage: UIImage(systemName: "bag"))
        
    }
    
    func setTextViewAppearance(textView: UITextView) {
        textView.delegate  = self
        textView.showsHorizontalScrollIndicator = false
        //        textView.adjustUITextViewHeight()
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        textView.layer.borderWidth = 3.0
        textView.textColor = theme
    }
    
    func setButton () {
        bidButton.isEnabled = self.chosenAuction.compareDates(startDate: self.chosenAuction.startDate, finishDate: self.chosenAuction.finishDate)
        bidButton.layer.borderColor = bidButton.isEnabled ? UIColor(patternImage: gradientImage).cgColor : UIColor.gray.cgColor
        bidButton.layer.borderWidth = 3.0
        bidButton.setTitle("BID", for: .normal)
        bidButton.setTitleColor(bidButton.isEnabled ? theme  : UIColor.gray, for: .normal)
    }
    
    func setPaddingAndBorders (textField: UITextField) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.borderColor = theme?.cgColor
        textField.layer.borderWidth = 3.0
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenAuction: Auction) {
        self.chosenAuction = chosenAuction
        self.theme = .systemIndigo
        self.gradientImage = CAGradientLayer.blueGradient(on: self.view)!
        self.loadBidders()
        self.loadAuctionDetails()
        self.viewDidLoad()
    }
    
    func finishPassingFromPlans(chosenAuction: Auction) {
        self.chosenAuction = chosenAuction
        self.theme = .systemPink
        gradientImage = CAGradientLayer.pinkGradient(on: self.view)!
        self.loadBidders()
        self.loadAuctionDetails()
        self.viewDidLoad()
    }
    
    //    MARK: Assigning data to labels and text views.
    
    func setLabels () {
        titleLabel.text = " " +  self.chosenAuction.name + " "
        dateLabel.text = " " + self.chosenAuction.basicDateFromString(string: self.chosenAuction.startDate) + "-" + self.chosenAuction.basicDateFromString(string: self.chosenAuction.finishDate)
        titleLabel.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        titleLabel.layer.borderWidth = 3.0
        titleLabel.textColor = theme
        dateLabel.textColor = UIColor.lightGray
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
    
    @IBAction func placeBid(_ sender: Any) {
        if(!(offerTextInput.text?.isEmpty ?? false)) {
            let bidder = Bidder()
            bidder.offer = Double(offerTextInput.text!)!
            let isBigger = chosenAuction.bidders.map{ $0.offer < bidder.offer }.allSatisfy({ $0 })
            if isBigger {
                bidder.date = self.chosenAuction.stringFromDate(date: Date())
                //self.chosenAuction.bidders.append(bidder)
                let user = Auth.auth().currentUser
                let auctionDocument = AuctionDocument(key: chosenAuction.key)
                if let user = user {
                    bidder.id = user.uid
                    self.chosenAuction.bidders.append(bidder)
                    auctionDocument.setBiddersDocument(bidderId: user.uid, bidder: bidder, auctionKey: chosenAuction.key, completion: { self.loadBidders() })
//                    auctionDocument.setUserBidsDocument(uid: user.uid, bidder: bidder, auctionKey: chosenAuction.key, completion: { self.loadBidders() })
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
