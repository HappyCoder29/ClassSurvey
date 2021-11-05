//
//  Keychain.swift
//  ClassSurvey
//
//  Created by Ashish Ashish on 11/4/21.
//

import Foundation
import KeychainSwift

class Keychain{
    var _key = KeychainSwift()
    
    var key : KeychainSwift {
        get{
            return _key
        }
        set {
            _key = newValue
        }
    }
}
