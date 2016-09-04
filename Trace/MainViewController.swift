//
//  MainViewController.swift
//  Trace
//
//  Created by liuzhihui on 16/9/4.
//  Copyright © 2016年 ryushiki. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    @IBAction func signOut(sender: UIBarButtonItem) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            dismissViewControllerAnimated(true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing error: \(signOutError)")
        }
    }
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    private var _refHandle: FIRDatabaseHandle!
    
    deinit {
        self.ref.child("messages").removeObserverWithHandle(_refHandle)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.messages.append(snapshot)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.messages.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
    }
    
    override func viewDidLoad() {
        configureDatabase()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell: UITableViewCell! = self.tableView .dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath)
        return cell
    }
}
