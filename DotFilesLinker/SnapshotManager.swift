//
//  Snapshot.swift
//  DotFilesLinker
//
//  Created by Matthew Davies on 7/10/14.
//  Copyright (c) 2014 Matthew Davies. All rights reserved.
//

import Foundation

class SnapshotManager {
  
  /** 
   * Saves a snapshot to a plist file for safekeeping
   * @param {NSDictionary} snapshot - the snapshot to save
   * @return {Bool} Whether the file was successfully saved
   */
  func saveSnapshot(snapshot: NSDictionary) -> Bool {
    
    var toSave: NSDictionary = ["date": NSDate(), "files": snapshot]
    var formatter: NSDateFormatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-dd-mm_hh-ss"
    var date = NSDate()
    var filename = "Snapshot-"+formatter.stringFromDate(date)
    var filePath = getAppSupportFolder().stringByAppendingString("/Snapshots/")
    
    var fileManager = NSFileManager()
    if(fileManager.fileExistsAtPath(filePath) == false){
      fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
    
    if (toSave.writeToFile(filePath.stringByAppendingString(filename+".plist"), atomically: false) == false) {
      return false
    }
    
    return true
  }
  
}