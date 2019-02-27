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

        let subscription = CTBikeService().fetchAll().subscribe(onNext: { result in
            self.bikes = result
            self.tableView.reloadData()
        })

        disposeBag.insert(subscription)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "bikeCell", for: indexPath)
        let bike = self.bikes[indexPath.row]
        cell.textLabel?.text = "\(bike.id) \(bike.name)"
        cell.detailTextLabel?.text = "\(bike.owner!.displayName)"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bike = self.bikes[indexPath.row]

        let alertController = UIAlertController(title: "Bike options", message: "", preferredStyle: .actionSheet)

        let routeButton = UIAlertAction(title: "Route", style: .default) { (_) -> Void in
            print("To the geozaune")
        }

        let geofenceButton = UIAlertAction(title: "Geofences", style: .default) { (_) -> Void in
             let geofenceTableViewController: GeofenceTableViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "geofenceTableViewController") as! GeofenceTableViewController

            geofenceTableViewController.bikeId = bike.id

            self.navigationController?.pushViewController(geofenceTableViewController, animated: true)
        }

        let rideButton = UIAlertAction(title: "Rides", style: .default) { (_) -> Void in
            let rideTableViewController: RideTableViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "rideTableViewController") as! RideTableViewController
            rideTableViewController.bikeId = bike.id
            self.navigationController?.pushViewController(rideTableViewController, animated: true)
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
            print("Cancel button tapped")
        })

        //Buttons
        alertController.addAction(routeButton)
        alertController.addAction(geofenceButton)
        alertController.addAction(rideButton)
        alertController.addAction(cancelButton)

        self.present(alertController, animated: true)
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let bike = self.bikes[indexPath.row]
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (_, indexPath) in
            CTBikeService().delete(withBikeId: bike.id).subscribe(onNext: { _ in
                self.bikes.remove(at: indexPath.row)
                self.tableView.reloadData()
            }).disposed(by: self.disposeBag)
        }

        let edit = UITableViewRowAction(style: .normal, title: "edit") { (_, _) in
            // action2 item at indexPath
            print("Editing")
        }

        if bike.owner?.id == CTUserService().getActiveUserId() {
            return [delete, edit]
        } else {
            return [delete]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bikes.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
