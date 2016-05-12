//
//  T_SignUpEmailViewController.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 14/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import UIKit
import SwiftValidate
import MBProgressHUD

class T_SignUpEmailViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var overlayView: UIView!
    
    var progressHUD:MBProgressHUD?
    
    var firstNameValidator = T_ValidatorHelper.firstNameValidator()
    private var nameValidator = T_ValidatorHelper.nameValidator()
    private var emailValidator = T_ValidatorHelper.emailValidator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstNameTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        T_DesignHelper.addSubBorder(nameTextField)
        T_DesignHelper.addSubBorder(firstNameTextField)
        T_DesignHelper.addSubBorder(emailTextField)
        
        T_DesignHelper.colorPlaceHolder(emailTextField)
        T_DesignHelper.colorPlaceHolder(nameTextField)
        T_DesignHelper.colorPlaceHolder(firstNameTextField)
        
        T_DesignHelper.addRoundBorder(continueButton)
        T_DesignHelper.colorBorderButton(continueButton)
        T_DesignHelper.colorUIView(overlayView)
        
    }
    
    // MARK: Methods
    func freezeUI() {
        progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD?.mode = .Indeterminate
    }
    
    func unfreezeUI() {
        progressHUD?.hide(true)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === continueButton {
            if let signupPasswordView = segue.destinationViewController as? T_SignUpPasswordViewController {
                let user = T_User()
                user.email = emailTextField.text
                user.firstName = firstNameTextField.text
                user.lastName = nameTextField.text
                signupPasswordView.user = user
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        //Enregistrement et gestion des erreurs ici, si pb envoie d'un alert et un return false pour annuler le segue
        // TODO Vérifier si l'adresse e-mail est pas déjà enregistré
        freezeUI()
        firstNameValidator.validate(firstNameTextField.text, context: nil)
        nameValidator.validate(nameTextField.text, context: nil)
        emailValidator.validate(emailTextField.text, context: nil)
        
        let errors : [String] = T_ValidatorHelper.getAllErrors([firstNameValidator, nameValidator, emailValidator])
        if !errors.isEmpty {
            unfreezeUI()
            T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: errors, viewController: self)
            return false
        }
        
        let emailAlreadyExist = T_ParseUserHelper.emailAlreadyExist(emailTextField.text!)
        unfreezeUI()
        if emailAlreadyExist {
            T_AlertHelper.alert( NSLocalizedString("Error", comment: ""), errors: [NSLocalizedString("This email is already used", comment: "")], viewController: self)
            return false
        }
        return true
    }
    
    
    
    
}

extension T_SignUpEmailViewController: UITextFieldDelegate {
    // MARK: - Text Field Delegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
}
