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
    let price: Int
    let auctionImageReference: String
}

class AuctionCell: BaseCell, CellType {
    var row: RowOf<String>!
    
    typealias Value = String
    
    @IBOutlet weak var auctionNameLabel: UILabel!
    @IBOutlet weak var auctionPriceLabel: UILabel!
    @IBOutlet weak var auctionImage: UIImageView!
    
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
        auctionNameLabel.text = model.auctionName
        auctionPriceLabel.text = String(model.price) + "zł"
    }
    
}


final class AuctionRow: Row<AuctionCell>, RowType {
    var type: String?
    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<AuctionCell>(nibName: "AuctionCell")
    }
}
