//
//  ViewController.swift
//  Soulab
//
//  Created by Jabir Momin on 12/11/19.
//  Copyright © 2019 Yash Barot. All rights reserved.
//

import UIKit

struct DisModel {
    var distance: String
    var distanceTotal: String
     var date: Date
    init(distance: String,distanceTotal: String,date: Date) {
        self.distance = distance
          self.distanceTotal = distanceTotal
        self.date = date
    }
}


class ListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    var arrayModel: [DisModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
       
    
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
          NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(_:)), name: .myNotificationKey, object: nil)
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayModel.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = "\(self.arrayModel[indexPath.row].distanceTotal) Meters"
        cell.detailTextLabel?.text = "\(self.arrayModel[indexPath.row].date)"
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    @objc func notificationReceived(_ notification: Notification) {
        //  let userInfo = [ "total" : traveledDistance , "dis" : dis , "date" : Date()]
         guard let total = notification.userInfo?["total"] as? String else { return }
        guard let dis = notification.userInfo?["dis"] as? String else { return }
        guard let date = notification.userInfo?["date"] as? Date else { return }
       
            var aStruct = DisModel(distance: dis, distanceTotal: total, date: date)
       self.arrayModel.append(aStruct)
        
        DispatchQueue.main.async {
              self.tableView.reloadData()
        }
    
    }
}

extension Notification.Name {
    public static let myNotificationKey = Notification.Name(rawValue: "myNotificationKey")
}
