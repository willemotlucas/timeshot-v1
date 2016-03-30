//
//  T_SearchContactViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 23/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import MessageUI

class T_SearchContactViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Properties
    var contactsWithNumbers = T_ContactsHelper.getAllContacts()
    var contactsWithSection = [String:[String]]()
    var sectionHeaderTitles = [String]()
    var contacts = [String]()
    var filteredContacts = [String]()

    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        T_DesignHelper.colorNavBar(self.navigationController!.navigationBar)
        
        contacts = Array(contactsWithNumbers.keys).sort()
        filteredContacts = contacts
        self.updateTableViewSections(self.filteredContacts)
        
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Methods
    private func updateTableViewSections(contacts: [String]) {
        contactsWithSection.removeAll()
        sectionHeaderTitles.removeAll()
        
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
    }
    
    // MARK: IBAction
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendSMS(sender: UIButton) {
        let button = sender as! T_SendMessageUIButton
        let phoneNumber = button.telNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "I discovered a new awesome app! Download it on http://timeshot.co :)";
        messageVC.recipients = [phoneNumber]
        messageVC.messageComposeDelegate = self;
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
}

extension T_SearchContactViewController: UITableViewDelegate {
    
}

extension T_SearchContactViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        if result.rawValue == MessageComposeResultCancelled.rawValue {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if result.rawValue == MessageComposeResultFailed.rawValue {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if result.rawValue == MessageComposeResultSent.rawValue {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("T_ContactTableViewCell") as! T_ContactTableViewCell
        
        let key = sectionHeaderTitles[indexPath.section]
        let values = contactsWithSection[key]
        let name = values![indexPath.row]
        let phoneNumber = contactsWithNumbers[name]
        
        let button = cell.sendSMSButton as! T_SendMessageUIButton
        button.telNumber = phoneNumber!
        cell.contactNameLabel.text = name
        cell.contactTelephoneLabel.text = phoneNumber
        
        return cell
    }
}

extension T_SearchContactViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredContacts = searchText.isEmpty ? contacts : contacts.filter({(dataString: String) -> Bool in
            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        self.updateTableViewSections(filteredContacts)
        contactsTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        filteredContacts = contacts
        self.updateTableViewSections(filteredContacts)
        contactsTableView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
