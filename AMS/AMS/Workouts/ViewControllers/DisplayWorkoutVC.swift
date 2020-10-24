//
//  DisplayAuctionVC.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 19/03/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit

class DisplayAuctionVC: UIViewController, passAuction, passAuctionFromPlans, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var specyficsLabel: UILabel!
    @IBOutlet weak var startAuctionButton: UIButton!
    
    @IBOutlet weak var biddersTextView: UITextView!
    @IBOutlet weak var timeRepsTextView: UITextView!
    
    var chosenAuction = Auction(name: "")
    
    var auctionDelegate: passAuction?
    
    var theme: UIColor?
    var gradientImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLabels()
        
        self.view.backgroundColor = UIColor.white
        
    }
    
    func setLabels () {
        titleLabel.text = " " +  self.chosenAuction.name + " "
        typeLabel.text = " " + self.chosenAuction.type
        titleLabel.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        titleLabel.layer.borderWidth = 3.0
        titleLabel.textColor = theme
        typeLabel.textColor = UIColor.lightGray
    }
    
    func setTextViewAppearance(textView: UITextView) {
        textView.delegate  = self
        textView.showsHorizontalScrollIndicator = false
        textView.adjustUITextViewHeight()
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
        textView.layer.borderWidth = 3.0
        textView.textColor = theme
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == biddersTextView{
            timeRepsTextView.contentOffset = biddersTextView.contentOffset
        }else{
            biddersTextView.contentOffset = timeRepsTextView.contentOffset
        }
    }
    
    //    MARK: Protocol stubs.
    
    func finishPassing(chosenAuction: Auction) {
        self.chosenAuction = chosenAuction
        self.theme = .systemIndigo
        self.gradientImage = CAGradientLayer.blueGradient(on: self.view)!
        self.viewDidLoad()
    }
    
    func finishPassingFromPlans(chosenAuction: Auction) {
        self.chosenAuction = chosenAuction
        self.theme = .systemPink
        gradientImage = CAGradientLayer.pinkGradient(on: self.view)!
        self.viewDidLoad()
    }
    
    //    MARK: Assigning data to labels and text views.
    
//    func checkType () {
//        var rounds: String?
//        specyficsLabel.text! = ""
//        specyficsLabel.text! += " " + " "
//        if (self.chosenAuction.type != "AMRAP" && self.chosenAuction.rounds>1) {
//            rounds = " rounds of:"
//        }
//        else {
//            rounds = " round of:"
//        }
//        switch self.chosenAuction.type {
//        case "AMRAP":
//            specyficsLabel.text! +=  "Time cap: " +  (self.chosenAuction.time) + "'. "
//        case "EMOM":
//            specyficsLabel.text! += "Every " + (self.chosenAuction.time
//                ) + ". "
//            specyficsLabel.text! +=  String(self.chosenAuction.rounds) + rounds!
//        case "FOR TIME":
//            specyficsLabel.text! += "Time cap: " +  (self.chosenAuction.time) + "'. "
//            specyficsLabel.text! += String(self.chosenAuction.rounds) + rounds!
//        case "TABATA":
//            specyficsLabel.text! += (self.chosenAuction.time) + " on " + (self.chosenAuction.restTime) + " off. "
//            specyficsLabel.text! +=  String(self.chosenAuction.rounds) + rounds!
//        default:
//            specyficsLabel.text! = ""
//        }
//
//        specyficsLabel.layer.borderColor = UIColor(patternImage: gradientImage).cgColor
//        specyficsLabel.layer.borderWidth = 3.0
//        specyficsLabel.textColor = theme
//
//    }
    
//    func loadExercises () {
//        print(chosenAuction.bidders.count)
//        for exercise in chosenAuction.bidders {
//            print(exercise.exerciseName)
//            timeRepsTextView.text += "\n"
//            biddersTextView.text += "\n"
//            if exercise.exerciseType == "Reps" {
//                timeRepsTextView.text += String(exercise.reps) + "\n"
//                print()
//                biddersTextView.text += exercise.exerciseName + "\n"
//            }
//            else if exercise.exerciseType == "Time" {
//                timeRepsTextView.text += exercise.exerciseTime + "\n"
//                biddersTextView.text += exercise.exerciseName + "\n"
//            }
//            if exercise.notes != " " && exercise.notes != "" {
//                let linesBefore = biddersTextView.numberOfLines()
//                biddersTextView.text += exercise.notes + "\n"
//                let linesAfter = biddersTextView.numberOfLines()
//                for _ in 1...(linesAfter-linesBefore) {
//                    timeRepsTextView.text += "\n"
//                }
//            }
//        }
//
//        self.setTextViewAppearance(textView: biddersTextView)
//        self.setTextViewAppearance(textView: timeRepsTextView)
//    }
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
        if self.contentSize.height < 500 {
            frame.size.height = self.contentSize.height
        } else {
            frame.size.height = 500
        }
        self.frame = frame
        
    }
    
}
