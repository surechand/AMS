//
//  AuctionsSC.swift
//  AMS
//
//  Created by Angelika Jeziorska on 25/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import UIKit
import Eureka
import Foundation

extension AuctionsVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    //    MARK: Search Controller's functionalities.
    
    func initiateFiltered () {
        UIView.setAnimationsEnabled(false)
        form.removeAll()
        for row in self.currentOptions {
            print(row.tag!)

            form +++ row
        }
        UIView.setAnimationsEnabled(true)
    }
    
    private func filterOptionsForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            currentOptions = originalOptions
        } else {
            currentOptions = originalOptions.filter { $0.title?.matchesSearchQuery(searchText) ?? false}
        }    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text else { return }
        
        filterOptionsForSearchText(query)
        self.initiateFiltered()
    }
    
    public func searchBar(_ searchBar: UISearchBar) {
        filterOptionsForSearchText(searchBar.text!)
        self.initiateFiltered()
    }
}
