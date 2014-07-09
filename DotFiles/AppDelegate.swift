//
//  AppDelegate.swift
//  DotFiles
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

  @IBOutlet var linkButton: NSButton

  // Initialize all the global stuff
  var sourceFolder: NSURL = NSURL()
  var destFolder = NSHomeDirectory()
  var manager: NSFileManager = NSFileManager()
  var ignoredFiles = [
    ".git": true,
    ".gitignore": true,
    ".DS_Store": true,
    "folder": true
  ]

  func applicationDidFinishLaunching(aNotification: NSNotification?) {
    
    // Set up everything for displaying/hiding
    sourcePath.hidden = true
    destPath.stringValue = destFolder
    linkButton.enabled = false
    window.center()
  
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
      if(manager.fileExistsAtPath(sourceFolder.path) == true) {
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
    var error : NSError?
    var files = []
    files = manager.contentsOfDirectoryAtURL(sourceFolder, includingPropertiesForKeys: nil, options:nil, error:nil)
    for file in files {
      var filePath: String = file.path
      if ignoredFiles[filePath.lastPathComponent] == true {
        continue;
      }
      var destination = destFolder + "/" + filePath.lastPathComponent
      println(filePath)
      println(destination)
      let linked = manager.createSymbolicLinkAtPath(destination, withDestinationPath: filePath, error: &error)
      if !linked{
        if let err = error{
          println(err.localizedDescription)
        }
      }
    }
  }

}