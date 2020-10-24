//
//  PlanProtocols.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 15/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation

protocol passPlan {
    func finishPassing (chosenPlan: Plan, chosenPlanIndex: Int?)
}

protocol passWeek {
    func finishPassing (chosenWeek: Week, chosenWeekIndex: Int?)
}

protocol passDay {
    func finishPassing (chosenDay: Day, chosenDayIndex: Int?)
}

protocol passAuctionFromPlans {
    func finishPassingFromPlans (chosenAuction: Auction)
}

protocol passAuctionAndIndex {
    func finishPassingWithIndex (chosenAuction: Auction, chosenAuctionIndex: Int?)
}
