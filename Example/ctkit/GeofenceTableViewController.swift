//
//  GeofenceTableViewController.swift
//  ctkit_Example
//
//  Created by Gert-Jan Vercauteren on 05/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import ctkit
import RxSwift

class GeofenceTableViewController: UITableViewController {

    var bikeId:Int?
    var geofences: [CTGeofenceModel] = []
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let bikeId = bikeId else {
            print("Bike id not set")
            return
        }
        
        let sub = CTGeofenceService().fetchAll(withBikeId: bikeId).subscribe(onNext: { result in
            self.tableView.reloadData()
        })
        
        disposeBag.insert(sub)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geofences.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "geofenceCell", for: indexPath)
        let geofence = self.geofences[indexPath.row]
        cell.textLabel?.text = "\(geofence.name)"
        cell.detailTextLabel?.text = "\(geofence.center.latitude);\(geofence.center.longitude) \(geofence.radius)m"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            let geofence = self.geofences[indexPath.row]
            
            CTGeofenceService().delete(withGeofenceId: geofence.id).subscribe(onCompleted: {
                self.geofences.remove(at: indexPath.row)
                self.tableView.reloadData()
            }, onError: { error in
                print("Completed with an error: \(error.localizedDescription)")
            }).disposed(by: self.disposeBag)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "edit") { (action, indexPath) in
            // action2 item at indexPath
            print("Editing")
        }
        
        return [delete, edit]
    }
}
