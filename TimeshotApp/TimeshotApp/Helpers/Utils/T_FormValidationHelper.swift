//
//  T_FormValidationHelper.swift
//  TimeshotApp
//
//  Created by Lucas Willemot on 10/04/2016.
//  Copyright © 2016 Timeshot. All rights reserved.
//

import Foundation

class T_FormValidationHelper {
    static let FirstNameMinCharacter = 3
    static let FirstNameMaxCharacter = 20
    static let LastNameMinCharacter = 2
    static let LastNameMaxCharacter = 20
    static let PasswordMinCharacter = 8
    static let EmailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    static let FirstNameMinCharacterError = NSLocalizedString("Don't be ridiculous, this first name is too short 😉", comment: "")
    static let LastNameMinCharacterError = NSLocalizedString("Don't be ridiculous, this last name is too short 😉", comment: "")
    
    static let InvalidEmailAddressError = NSLocalizedString("Your email address is not valid ✉️", comment: "")
    static let EmptyEmailAddressError = NSLocalizedString("Your email address is mandatory ✉️", comment: "")
    
    static let EmptyCurrentPasswordError = NSLocalizedString("Please enter your current password", comment: "")
    static let EmptyNewPasswordError = NSLocalizedString("Please enter your new password", comment: "")
    static let EmptyConfirmNewPasswordError = NSLocalizedString("Please confirm your new password", comment: "")
    static let PasswordDontMatchError = NSLocalizedString("Your confirmation password does not match with your new password", comment: "")
    static let PasswordMinCharacterError = NSLocalizedString("Your password must be 8 characters at least", comment: "")
    static let InvalidCurrentPasswordError = NSLocalizedString("Your current password is invalid", comment: "")
    static let NetworkError = NSLocalizedString("You are not connected to the internet 😕. Please try again later. ", comment: "")

    
    static func isValidEmail(email: String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", EmailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
    static func isValidPassword(currentPassword: String, newPassword: String, confirmNewPassword: String) -> String {
        if currentPassword.isEmpty {
            return EmptyCurrentPasswordError
        }
        else if newPassword.isEmpty {
            return EmptyNewPasswordError
        }
        else if confirmNewPassword.isEmpty {
            return EmptyConfirmNewPasswordError
        }
        else if newPassword != confirmNewPassword {
            return PasswordDontMatchError
        }
        else if newPassword.characters.count < PasswordMinCharacter || confirmNewPassword.characters.count < PasswordMinCharacter {
            return PasswordMinCharacterError
        }
        else {
            return ""
        }
    }
}