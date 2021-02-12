//
//  HelperProtocol.swift
//  Nudge
//
//  Created by Abraham Tarverdi on 2/11/21.
//

import Foundation
@objc(HelperProtocol)

protocol HelperProtocol {
    
    func runCommandLs(withPath: String, completion: @escaping (NSNumber) -> Void)
    func runCommandLs(withPath: String, authData: NSData?, completion: @escaping (NSNumber) -> Void)
    func installPkgs(pkgFilePath: String, _ completion: @escaping (NSNumber) -> Void )
    
}
