//
//  BikeTableViewController.swift
//  ctkit_Example
//
//  Created by Gert-Jan Vercauteren on 02/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import ctkit

class BikeTableViewController: UITableViewController {
    
    var bikes: [CTBikeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CTBikeService().fetchAll().subscribe(onNext: { bikes in
            self.bikes = bikes
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "bikeCell", for: indexPath)
        cell.textLabel?.text = self.bikes[indexPath.row].name
        cell.detailTextLabel?.text = self.bikes[indexPath.row].owner.displayName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bikes.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
