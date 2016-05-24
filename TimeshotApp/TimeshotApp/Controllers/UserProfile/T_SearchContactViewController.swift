//
//  T_SearchContactViewController.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 23/03/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import MessageUI
import DZNEmptyDataSet

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
    var contactsToInvite: [String] = []

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
        contactsTableView.emptyDataSetSource = self
        contactsTableView.emptyDataSetDelegate = self
        contactsTableView.tableFooterView = UIView()
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
    
    @IBAction func checkboxButtonSelected(sender: T_SendMessageUIButton) {
        if sender.selected == false {
            sender.selected = true
            let phoneNumber = sender.telNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
            self.contactsToInvite.append(phoneNumber)
        } else {
            sender.selected = false
            let phoneNumber = sender.telNumber.stringByReplacingOccurrencesOfString(" ", withString: "")
            //TODO : Remove the phone number
            self.contactsToInvite = self.contactsToInvite.filter{$0 != phoneNumber}
        }
    }
    
    @IBAction func inviteButtonTapped(sender: UIBarButtonItem) {
        if self.contactsToInvite.isEmpty {
            let alertController = UIAlertController(title: "No contacts selected", message:
                "Select some contacts to invite them!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "I discovered a new awesome app! Download it on http://timeshot.co :)";
            messageVC.recipients = self.contactsToInvite
            messageVC.messageComposeDelegate = self;
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
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
        var phoneNumber = contactsWithNumbers[name]
        
        let button = cell.checkboxButton as T_SendMessageUIButton
        button.telNumber = phoneNumber!
        cell.contactNameLabel.text = name
        cell.contactTelephoneLabel.text = phoneNumber
        
        // Need to initialize the state of the button ... 
        // If not, it will use the last state which not the good option for us
        // Je renleve les espaces pour faire une comparaison avec les valeurs du tableau
        phoneNumber = phoneNumber!.stringByReplacingOccurrencesOfString(" ", withString: "")
        if contactsToInvite.contains(phoneNumber!) {
            button.selected = true
        } else {
            button.selected = false
        }
        
        
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
        for ob: UIView in ((self.searchBar.subviews[0] )).subviews {
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        filteredContacts = contacts
        self.updateTableViewSections(filteredContacts)
        contactsTableView.reloadData()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension T_SearchContactViewController: DZNEmptyDataSetSource {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        if self.searchBar.text!.isEmpty {
            let str = "Search one of your contact!"
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        } else {
            let str = "Nobody have been found ..."
            let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
            return NSAttributedString(string: str, attributes: attrs)
        }
    }
}

extension T_SearchContactViewController: DZNEmptyDataSetDelegate {
    
}


