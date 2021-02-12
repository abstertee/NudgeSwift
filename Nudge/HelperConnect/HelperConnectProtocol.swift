//
//  HelperConnectProtocol.swift
//  Nudge
//
//  Created by Abraham Tarverdi on 2/11/21.
//

import Foundation
@objc(HelperConnectProtocol)
protocol HelperConnectProtocol {
    func log(stdOut: String) -> Void
    func log(stdErr: String) -> Void
    func log(exitCode: Int32) -> Void
}
