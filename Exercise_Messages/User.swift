//
//  User.swift
//  Exercise_Messages
//
//  Created by Omer Edut on 01/09/2016.
//  Copyright © 2016 Omer Edut. All rights reserved.
//

import Foundation

class User: NSObject {
    
    private var _userName: String;
    private var _password: String;
    
    init(userName: String, password: String){
        self._userName = userName;
        self._password = password;
    }
    
    var userName: String {
        set { _userName = newValue; }
        get { return _userName; }
    }
    
    var password: String {
        set { _password = newValue; }
        get { return _password; }
    }
    
    
    
    
}
