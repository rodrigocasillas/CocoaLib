//
//  DaLiUser.swift
//  CocoaLib
//
//  Created by Rodrigo Casillas on 7/18/19.
//

import Foundation

class DaLiUserConfiguration {
    var userKey: String?
    var userToken: String?
    var packageName: String?
    var deviceID: String?
    var domainList: [String]?
    
    init() {}
    
    init(userKey: String, userToken: String, packageName: String, deviceID: String, domainList: [String]?) {
        self.userKey = userKey
        self.userToken = userToken
        self.packageName = packageName
        self.deviceID = deviceID
        self.domainList = domainList
    }
}
