//
//  HelperConnect.swift
//  Nudge
//
//  Created by Abraham Tarverdi on 2/11/21.
//
import ServiceManagement
import Cocoa
import Foundation
class HelperConnection: NSObject, HelperConnectProtocol {
    // MARK: -
    // MARK: AppProtocol Methods
    
    func log(stdOut: String) {
        guard !stdOut.isEmpty else { return }
        OperationQueue.main.addOperation {
            debugPrint(stdOut)
        }
    }
    
    func log(stdErr: String) {
        guard !stdErr.isEmpty else { return }
        OperationQueue.main.addOperation {
            debugPrint(stdErr)
        }
    }
    
    func log(exitCode: Int32) {
        //guard exitCode != nil else { return }
        OperationQueue.main.addOperation {
          
            debugPrint(exitCode)
        }
    }
    
    // MARK: -
    // MARK: Variables

    private var currentHelperConnection: NSXPCConnection?

    @objc dynamic private var currentHelperAuthData: NSData?
    private var currentHelperAuthDataKeyPath: String = ""
 
    
    @objc dynamic private var helperIsInstalled = false
    private var helperIsInstalledKeyPath: String = ""
     

    override init() {
        self.currentHelperAuthDataKeyPath = NSStringFromSelector(#selector(getter: self.currentHelperAuthData))
       // self.helperIsInstalledKeyPath = NSStringFromSelector(#selector(getter: self.helperIsInstalled))
        super.init()
    }

    // MARK: -
    // MARK: Helper Connection Methods

    func helperConnection() -> NSXPCConnection? {
        guard self.currentHelperConnection == nil else {
            return self.currentHelperConnection
        }
        
        let connection = NSXPCConnection(machServiceName: HelperConstants.machServiceName, options: .privileged)
        connection.exportedInterface = NSXPCInterface(with: HelperConnectProtocol.self)
        connection.exportedObject = self
        connection.remoteObjectInterface = NSXPCInterface(with: HelperProtocol.self)
        connection.invalidationHandler = {
            self.currentHelperConnection?.invalidationHandler = nil
            OperationQueue.main.addOperation {
                self.currentHelperConnection = nil
            }
        }
        
        self.currentHelperConnection = connection
        self.currentHelperConnection?.resume()
        
        return self.currentHelperConnection
    }

    func helper(_ completion: ((Bool) -> Void)?) -> HelperProtocol? {
        
        // Get the current helper connection and return the remote object (Helper.swift) as a proxy object to call functions on.
        
        guard let helper = self.helperConnection()?.remoteObjectProxyWithErrorHandler({ error in
            debugPrint("Error from helper: \(error)")
            if let onCompletion = completion { onCompletion(false) }
        }) as? HelperProtocol else { return nil }
        return helper
    }
    
    func helperInstall() throws -> Bool {
        debugPrint("Attempting to Install")
        // Install and activate the helper inside our application bundle to disk.
        
        var cfError: Unmanaged<CFError>?
        var authItem = AuthorizationItem(name: kSMRightBlessPrivilegedHelper, valueLength: 0, value:UnsafeMutableRawPointer(bitPattern: 0), flags: 0)
        var authRights = AuthorizationRights(count: 1, items: &authItem)
        
        guard
            let authRef = try HelperAuthorization.authorizationRef(&authRights, nil, [.interactionAllowed, .extendRights, .preAuthorize]),
            SMJobBless(kSMDomainSystemLaunchd, HelperConstants.machServiceName as CFString, authRef, &cfError) else {
                if let error = cfError?.takeRetainedValue() {
                    debugPrint("Error in installing: \(error)")
                    throw error }

                return false
        }
        
        self.currentHelperConnection?.invalidate()
        self.currentHelperConnection = nil
        
        return true
    }
}
var helperConnection = HelperConnection() //HelperConnection().helper(nil)
