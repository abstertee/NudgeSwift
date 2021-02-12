//
//  SoftwareUpdate.swift
//  Nudge
//
//  Created by Rory Murdock on 10/2/21.
//

import Foundation

class ShellCommand {
    static let shared = SoftwareUpdate()
    
    func runShell(_ command: String, _ args: Array<String>) {
        //Log.info(message: "Starting software update")
        let task = Process
        task.launchPath = command
        task.arguments = args
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        do {
            try task.run()
        } catch {
            print("Error running shellcommand")
        }

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        guard let output: String = String(data: outputData, encoding: .utf8) else {
            //Log.info(message: "Standard out did not contain data")
            print("Standard out did not contain data")
            return
        }
        
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        guard let error: String = String(data: errorData, encoding: .utf8) else {
            //Log.info(message: "Standard error did not contain data")
            print("Standard error did not contain data")
            return
        }
        
        //Log.info(message: output)
        //Log.error(message: error)
    }
}

//    func List() {
//            Log.info(message: "Starting software update")
//            let task = Process()
//            task.executableURL = URL(fileURLWithPath: "/usr/sbin/softwareupdate")
//            task.arguments = ["-la"]
//
//            do {
//                try task.run()
//            } catch {
//                print("Error launching VBoxManage")
//            }
//
//            let outputPipe = Pipe()
//            let errorPipe = Pipe()
//
//            task.standardOutput = outputPipe
//            task.standardError = errorPipe
//
//            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
//            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
//
//            let output = String(decoding: outputData, as: UTF8.self)
//            let error = String(decoding: errorData, as: UTF8.self)
//
//            Log.info(message: output)
//            Log.error(message: error)
//        }
//    }
//
//    func Download() {
//
//        // TODO Only run if
//        // If enforceMinorUpdates == true
//
//        if Utils().getCPUTypeString() == "Apple Silicon" {
//            Log.warning(message: "Apple Silicon doesn't support software update download")
//            return
//        }
//
//        Log.info(message: "Starting software update")
//        let task = Process()
//        task.executableURL = URL(fileURLWithPath: "/usr/sbin/softwareupdate")
//        task.arguments = ["-da"]
//
//        do {
//            try task.run()
//        } catch {
//            print("Error launching VBoxManage")
//        }
//
//        let outputPipe = Pipe()
//        let errorPipe = Pipe()
//
//        task.standardOutput = outputPipe
//        task.standardError = errorPipe
//
//        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
//        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
//
//        let output = String(decoding: outputData, as: UTF8.self)
//        let error = String(decoding: errorData, as: UTF8.self)
//
//        Log.info(message: output)
//        Log.error(message: error)
//    }
//
//
//    let SU = SoftwareUpdate()
