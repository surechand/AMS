//
//  AuctionCell.swift
//  AMS
//
//  Created by Angelika Jeziorska on 25/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import FirebaseUI

struct AuctionCellModel {
    let auctionName: String
    let price: Double
    let auctionImageReference: String
    let auctionEndDate: String
}

class AuctionCell: BaseCell, CellType {
    var row: RowOf<String>!
    
    typealias Value = String
    
    @IBOutlet weak var auctionNameLabel: UILabel!
    @IBOutlet weak var auctionPriceLabel: UILabel!
    @IBOutlet weak var auctionImage: UIImageView!
    @IBOutlet weak var auctionEndDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    public func configure(with model: AuctionCellModel) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child(model.auctionImageReference)
        auctionImage.sd_setImage(with: imgRef, placeholderImage: UIImage(systemName: "bag"))
        auctionImage.layer.cornerRadius = 10
        auctionImage.layer.shadowColor = UIColor.black.cgColor
        auctionImage.layer.shadowRadius = 2.5
        auctionImage.layer.shadowOpacity = 0.8
        auctionImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        auctionImage.layer.masksToBounds = false
        
        auctionNameLabel.text = model.auctionName
        auctionNameLabel.layer.shadowColor = UIColor.black.cgColor
        auctionNameLabel.layer.shadowRadius = 2.5
        auctionNameLabel.layer.shadowOpacity = 1.0
        auctionNameLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        auctionNameLabel.layer.masksToBounds = false
        
        auctionPriceLabel.text = String(model.price) + "€"
        auctionPriceLabel.layer.shadowColor = UIColor.black.cgColor
        auctionPriceLabel.layer.shadowRadius = 1.5
        auctionPriceLabel.layer.shadowOpacity = 0.8
        auctionPriceLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        auctionPriceLabel.layer.masksToBounds = false
        
        auctionEndDateLabel.text = "Ends: " + model.auctionEndDate
        
        self.layer.cornerRadius = 15
    }
    
    public func reloadImage(with model: AuctionCellModel) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child(model.auctionImageReference)
        auctionImage.sd_setImage(with: imgRef, placeholderImage: UIImage(systemName: "bag"))
    }
    
}


final class AuctionRow: Row<AuctionCell>, RowType {
    var type: String?
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<AuctionCell>(nibName: "AuctionCell")
    }
}
