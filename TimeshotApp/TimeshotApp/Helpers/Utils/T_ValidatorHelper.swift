//
//  T_Validator.swift
//  TimeshotApp
//
//  Created by Karim Lamouri on 27/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation
import SwiftValidate

class T_ValidatorHelper {
    
    static func firstNameValidator() -> ValidatorChain {
        return ValidatorChain(){
            $0.stopOnException = true
            $0.stopOnFirstError = true
            } <~~ ValidatorRequired() {
                $0.errorMessage = NSLocalizedString("Firstname should not be empty", comment: "")
            } <~~ ValidatorEmpty() {
                $0.allowNil = false
                $0.errorMessage = NSLocalizedString("Firstname should not be empty", comment: "")
            } <~~ ValidatorStrLen() {
                $0.minLength = 2
                $0.maxLength = 30
                $0.errorMessageTooSmall = NSLocalizedString("Firstname not long enough", comment: "")
                $0.errorMessageTooLarge = NSLocalizedString("Firstname too long", comment: "")
        }
    }
    static func nameValidator() -> ValidatorChain {
        return ValidatorChain(){
            $0.stopOnException = true
            $0.stopOnFirstError = true
            } <~~ ValidatorRequired() {
                $0.errorMessage = NSLocalizedString("Name should not be empty", comment: "")
            } <~~ ValidatorEmpty() {
                $0.allowNil = false
                $0.errorMessage = NSLocalizedString("Name should not be empty", comment: "")
            } <~~ ValidatorStrLen() {
                $0.minLength = 2
                $0.maxLength = 30
                $0.errorMessageTooSmall = NSLocalizedString("Name not long enough", comment: "")
                $0.errorMessageTooLarge = NSLocalizedString("Name too long", comment: "")
        }
    }
    static func passwordValidator() -> ValidatorChain {
        return ValidatorChain(){
            $0.stopOnException = true
            $0.stopOnFirstError = true
            } <~~ ValidatorRequired() {
                $0.errorMessage = NSLocalizedString("Password should not be empty", comment: "")
            } <~~ ValidatorEmpty() {
                $0.allowNil = false
                $0.errorMessage = NSLocalizedString("Password should not be empty", comment: "")
            } <~~ ValidatorStrLen() {
                $0.minLength = 2
                $0.maxLength = 30
                $0.errorMessageTooSmall = NSLocalizedString("Password not long enough", comment: "")
                $0.errorMessageTooLarge = NSLocalizedString("Password too long", comment: "")
        }
    }
    static func emailValidator() -> ValidatorChain {
        return ValidatorChain() {
            $0.stopOnException = true
            $0.stopOnFirstError = true
            } <~~ ValidatorRequired() {
                $0.errorMessage = NSLocalizedString("E-mail is required", comment: "")
            } <~~ ValidatorEmpty() {
                $0.allowNil = false
                $0.errorMessage = NSLocalizedString("E-mail should not be empty", comment: "")
            } <~~ ValidatorRegex() {
                $0.pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                $0.errorMessageValueIsNotMatching = NSLocalizedString("Your e-mail is not valid", comment: "")
            /*} <~~ ValidatorEmail() {
                $0.errorMessageInvalidAddress = NSLocalizedString("Your e-mail is not valid", comment: "")*/
        }

    }
    
    static func userNameValidator() -> ValidatorChain {
        return ValidatorChain(){
            $0.stopOnException = true
            $0.stopOnFirstError = true
            } <~~ ValidatorRequired() {
                $0.errorMessage = NSLocalizedString("Username should not be empty", comment: "")
            } <~~ ValidatorEmpty() {
                $0.allowNil = false
                $0.errorMessage = NSLocalizedString("Username should not be empty", comment: "")
            } <~~ ValidatorStrLen() {
                $0.minLength = 2
                $0.maxLength = 30
                $0.errorMessageTooSmall = NSLocalizedString("Username not long enough", comment: "")
                $0.errorMessageTooLarge = NSLocalizedString("Username too long", comment: "")
        }
    }
    
    static func getAllErrors(errorsArray : [[String]]) -> [String] {
        var err : [String] = []
        for errors in errorsArray {
            err += errors
        }
        return err
    }
    static func getAllErrors(errorsArray : [ValidatorChain]) -> [String] {
        var err : [String] = []
        for errors in errorsArray.map({e in return e.errors}) {
            err += errors
        }
        return err
    }
    static func getAllErrors(errorsArray : [[String]]) -> String {
        let errors : [String]  = getAllErrors(errorsArray)
        return errors.joinWithSeparator("\n")
    }
}