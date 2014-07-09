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

    @IBOutlet var sourcePath: NSTextField
    @IBOutlet var destPath: NSTextField
  
    @IBOutlet var linkButton: NSButton

    // Initialize all the global stuff
    var sourceFolder: NSURL = NSURL()
    var homeFolder = NSHomeDirectory()
    var manager: NSFileManager = NSFileManager()
  
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
      
        // Set up everything for displaying/hiding
        sourcePath.hidden = true
        destPath.stringValue = homeFolder
        linkButton.enabled = false
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
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
  
    @IBAction func selectDest(sender: AnyObject) {
      var selector: NSOpenPanel = NSOpenPanel()
      
    }
  
  @IBAction func symlinkFolder(sender: AnyObject) {
    var files = []
    files = manager.contentsOfDirectoryAtURL(sourceFolder, includingPropertiesForKeys: nil, options:nil, error:nil)
    for file in files {
      var filePath: String = file.path
      println(filePath)
      println(manager.createSymbolicLinkAtPath(filePath, withDestinationPath: homeFolder as String, error: nil))
    }
  }
}

