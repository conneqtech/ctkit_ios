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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let subscription = CTBikeService().fetchAll().subscribe(onNext: { bikes in
            self.bikes = bikes
            self.tableView.reloadData()
        })
        
        disposeBag.insert(subscription)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "bikeCell", for: indexPath)
        let bike = self.bikes[indexPath.row]
        cell.textLabel?.text = "\(bike.id) \(bike.name)"
        cell.detailTextLabel?.text = "\(bike.owner.displayName) owner=\(bike.owner.id == CTUserService().getActiveUserId())"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bike = self.bikes[indexPath.row]
        let calendar = Calendar.current
       
        let from = calendar.date(byAdding: .hour, value: -10, to: Date())!
        
        let subscription = CTBikeLocationService().getHistoryForBike(withId: bike.id, from: from, until: Date()).subscribe(onNext: { locations in
            print("Locations: \(locations.count)")
            locations.forEach { location in
                print("\(location.latitude) \(location.longitude)")
            }
        }, onError: { error in
            print("DEAD")
            print(error)
        })
        
        disposeBag.insert(subscription)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bikes.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
