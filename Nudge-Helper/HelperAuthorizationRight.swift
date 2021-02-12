//
//  HelperAuthorizationRight.swift
//  Nudge
//
//  Created by Abraham Tarverdi on 2/11/21.
//

import Foundation
struct HelperAuthorizationRight {
    
    let command: Selector
    let name: String
    let description: String
    let rule: [String: Any]
    
    static let ruleDefault: [String: Any] = [
        kAuthorizationRightKeyClass   : "user",
        kAuthorizationRightKeyGroup   : "admin",
        kAuthorizationRightKeyTimeout : 0,
        kAuthorizationRightKeyVersion : 1
    ]
    
    init(command: Selector, name: String? = nil, description: String, rule: [String: Any]? = nil) {
        self.command = command
        self.name = name ?? HelperConstants.machServiceName + "." + command.description
        self.description = description
        self.rule = rule ?? HelperAuthorizationRight.ruleDefault
    }
}
