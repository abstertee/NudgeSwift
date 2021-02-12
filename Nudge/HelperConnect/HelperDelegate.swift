//
//  HelperDelegate.swift
//  Nudge
//
//  Created by Abraham Tarverdi on 2/11/21.
//

import Foundation

class HelperDelegate {
    
    static let shared = HelperDelegate()
    
    func updateAuthTable() {
        do {
            try HelperAuthorization.authorizationRightsUpdateDatabase()
        } catch {
            debugPrint("Failed to update the authorization database rights with error: \(error)")
        }
    }

    func helperStatus(completion: @escaping (Bool) -> Void) {
        let privilegedHelperToolPath = "/Library/PrivilegedHelperTools/" + HelperConstants.machServiceName
        
        if FileManager.default.fileExists(atPath: privilegedHelperToolPath) == false {
            debugPrint("HelperFile Does NOT exist at \(privilegedHelperToolPath)")
            completion(false)
        }
        debugPrint("HelperFile Exists at \(privilegedHelperToolPath)")
        // Compare the CFBundleShortVersionString from the Info.plist in the helper inside our application bundle with the one on disk.
        
        let helperURL = Bundle.main.bundleURL.appendingPathComponent("Contents/Library/LaunchServices/" + HelperConstants.machServiceName)
        //debugPrint(helperURL)
        guard
            let helperBundleInfo = CFBundleCopyInfoDictionaryForURL(helperURL as CFURL) as? [String: Any],
            let helperVersion = helperBundleInfo["CFBundleShortVersionString"] as? String,
            let helper = HelperConnection().helper(completion) else {
                completion(false)
                return
        }
        
        helper.getVersion {
            installedHelperVersion in
                debugPrint("Installed Helper App Version is: \(installedHelperVersion)")
                if installedHelperVersion != helperVersion {
                    debugPrint("Helper version mismatch")
                }
                //debugPrint("Installed version is \(installedHelperVersion)")
                debugPrint("Helper App Version Installed is: \(helperVersion)")
                
                completion(installedHelperVersion == helperVersion)
        }
    }


    func helperInstaller() {
        do {
            if try HelperConnection().helperInstall() {
                debugPrint("Helper Installed Successfully.")
                return
            } else {
                debugPrint("Helper NOT Installed.")
            }
        } catch {
            debugPrint("FAILED to install helper.")
        }
    }
}
