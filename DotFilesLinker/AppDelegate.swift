//
//  AppDelegate.swift
//  DotFilesLinker
//
//  Created by Matthew Davies on 7/8/14.
//  Copyright (c) 2014 Matthew Davies. All rights reserved.
//

import Cocoa
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
  
// All the UI Elements \\
  
  @IBOutlet var selectSource: NSButton
  @IBOutlet var selectDest: NSButton
  @IBOutlet var window: NSWindow

  @IBOutlet var sourcePath: NSTextField
  @IBOutlet var destPath: NSTextField
  
  @IBOutlet var errorLabel: NSTextField
  @IBOutlet var errorList: NSScrollView

  var errorListText: NSTextView {
    get {
      return errorList.contentView.documentView as NSTextView
    }
  }

  @IBOutlet var linkButton: NSButton
  @IBOutlet var disclosureTriangle: NSButton

  // Initialize all the global stuff
  var sourceFolder: NSURL = NSURL()
  var destFolder = NSHomeDirectory()
  var fileManager: NSFileManager = NSFileManager()
  let ignoredFiles = [
    ".git": true,
    ".gitignore": true,
    ".DS_Store": true
  ]
  var snapshotManager = SnapshotManager()
  
  func applicationDidFinishLaunching(aNotification: NSNotification?) {
    
    // Set up everything for displaying/hiding
    sourcePath.hidden = true
    disclosureTriangle.hidden = true
    errorLabel.hidden = true
    errorList.hidden = true
    destPath.stringValue = destFolder
    linkButton.enabled = false
    window.center()
    
    resizeWindow(window, ["height": 205.00], animate: false)
  }

  func applicationWillTerminate(aNotification: NSNotification?) {
      // Insert code here to tear down your application
  }
  
  // Opens a modal for selecting a source folder
  @IBAction func selectFolder(sender: AnyObject) {
    var selector: NSOpenPanel = NSOpenPanel()
    
    selector.canChooseDirectories = true
    if(selector.runModal() == NSOKButton) {
      sourceFolder = selector.URLs[0] as NSURL
      sourcePath.stringValue = sourceFolder.path
      if(fileManager.fileExistsAtPath(sourceFolder.path) == true) {
        sourcePath.hidden = false
        linkButton.enabled = true
      }
    }
  }
  
  // Opens a modal for selecting a destination folder
  @IBAction func selectDest(sender: AnyObject) {
    var selector: NSOpenPanel = NSOpenPanel()
    
    selector.canChooseDirectories = true
    if(selector.runModal() == NSOKButton) {
      destFolder = selector.URLs[0].path
      destPath.stringValue = destFolder
    }
  }
  
  // Symlink the files
  @IBAction func symlinkFolder(sender: AnyObject) {
    var error: NSError?
    var errors = [String]()
    var files = []
    var snapshot = Dictionary<String, String>()
    files = fileManager.contentsOfDirectoryAtURL(sourceFolder, includingPropertiesForKeys: nil, options:nil, error:nil)
    for file in files {
      var filePath: String = file.path
      if ignoredFiles[filePath.lastPathComponent] == true {
        continue;
      }
      var destination = destFolder + "/" + filePath.lastPathComponent
      println(filePath)
      println(destination)
      let linked = fileManager.createSymbolicLinkAtPath(destination, withDestinationPath: filePath, error: &error)
      if !linked {
        if let err = error{
          errors.append(err.localizedDescription)
        }
      } else {
        snapshot[filePath] = destination
      }
    }
    
    if(!errors.isEmpty) {
      disclosureTriangle.hidden = false
      errorLabel.stringValue = "There were \(errors.count) error(s)"
      errorLabel.hidden = false
      var errorListString = ""
      for error in errors {
        errorListString += error + "\n"
      }
      errorListText.string = errorListString
      resizeWindow(window, ["height": 255.00])
    }

    if snapshot.count > 0 {
       snapshotManager.saveSnapshot(snapshot)
    }
  
  }
  
  
  @IBAction func showErrors(sender: NSButton) {
    if sender.state == 1 {
      resizeWindow(window, ["height": 400])
      errorList.hidden = false
    } else if sender.state == 0 {
      resizeWindow(window, ["height": 255])
      errorList.hidden = true
    }
    
  }
}