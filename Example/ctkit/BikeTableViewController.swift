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
        
        
        let alertController = UIAlertController(title: "Bike options", message: "", preferredStyle: .actionSheet)
        
        let routeButton = UIAlertAction(title: "Route", style: .default) { (action) -> Void in
            print("To the geozaune")
        }
        
        let geofenceButton = UIAlertAction(title: "Geofences", style: .default) { (action) -> Void in
             var geofenceTableViewController: GeofenceTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "geofenceTableViewController") as! GeofenceTableViewController
            
            geofenceTableViewController.bikeId = bike.id
            
            self.navigationController?.pushViewController(geofenceTableViewController, animated: true)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })

        //Buttons
        alertController.addAction(routeButton)
        alertController.addAction(geofenceButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            let bike = self.bikes[indexPath.row]
            
            CTBikeService().delete(withBikeId: bike.id).subscribe(onCompleted: {
                self.bikes.remove(at: indexPath.row)
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bikes.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
