//
//  Helpers.swift
//  DotFilesLinker
//
//  Created by Matthew Davies on 7/10/14.
//  Copyright (c) 2014 Matthew Davies. All rights reserved.
//

import Foundation
import Cocoa


/**
 * Resizes a window
 * @param {NSWindow} window - the window to manipulate
 * @param {String: CGFloat} options - a dictionary of the width and height as CGFloats
 * @param {Bool} animate - whether the window resizing should be animated (default: true)
 * @return {void}
 */
func resizeWindow(window: NSWindow, options: [String: CGFloat], animate: Bool = true) {

  // Initialize the array
  var opts = [
    "width": 0.0,
    "height": 0.0
  ]

  // Set the width and height to either the options or (if the width/height was left out) to the window's current size
  opts["width"] = options["width"] ? options["width"] : window.frame.size.width
  opts["height"] = options["height"] ? options["height"] : window.frame.size.height

  // Create a CGRect so that it can be used by setFrame()
  var frame = CGRectMake(window.frame.origin.x, window.frame.origin.y, opts["width"]!, opts["height"]!)

  // Set the frame using the CGRect
  window.setFrame(frame, display: true, animate: animate)
}