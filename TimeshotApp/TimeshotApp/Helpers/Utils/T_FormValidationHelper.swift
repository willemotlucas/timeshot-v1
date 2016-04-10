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
    
    static let FirstNameMinCharacterError = "Don't be ridiculous, this first name is too short 😉"
    static let LastNameMinCharacterError = "Don't be ridiculous, this last name is too short 😉"
    
    static let InvalidEmailAddressError = "Your email address is not valid ✉️"
    static let EmptyEmailAddressError = "Your email address is mandatory ✉️"
    
    static let EmptyCurrentPasswordError = "Please enter your current password"
    static let EmptyNewPasswordError = "Please enter your new password"
    static let EmptyConfirmNewPasswordError = "Please confirm your new password"
    static let PasswordDontMatchError = "Your confirmation password does not match with your new password"
    static let PasswordMinCharacterError = "Your password must be 8 characters at least"
    static let InvalidCurrentPasswordError = "Your current password is invalid"

    
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