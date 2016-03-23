//
//  T_SearchContactViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 23/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit

class T_SearchContactViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var contactsTableView: UITableView!
    
    // MARK: Properties
    var contacts = T_ContactsHelper.getAllContacts().sort()
    var sectionHeaderTitles = [String]()
    var contactsWithSection = [String:[String]]()

    // MARK : Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        for contact in contacts {
            if let letter = contact.characters.first {
                if contactsWithSection.indexForKey(String(letter)) == nil {
                    contactsWithSection[String(letter)] = [String]()
                }
                contactsWithSection[String(letter)]?.append(contact)
                
                if !sectionHeaderTitles.contains(String(letter)) {
                    sectionHeaderTitles.append(String(letter))
                }
            }
        }
        
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: IBAction
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension T_SearchContactViewController: UITableViewDelegate {
    
}

extension T_SearchContactViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return contactsWithSection.keys.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaderTitles[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionHeaderTitles[section]
        let values = contactsWithSection[key]
        return (values?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let key = sectionHeaderTitles[indexPath.section]
        let values = contactsWithSection[key]
        let name = values![indexPath.row]
        
        cell.textLabel?.text = name
        
        return cell
    }
}
