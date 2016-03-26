//
//  AppDelegate.swift
//  Cricket Score Applet Helper
//
//  Created by Adhithyan Vijayakumar on 26/03/16.
//  Copyright © 2016 Adhithyan Vijayakumar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        NSArray *pathComponents = [[[NSBundle mainBundle] bundlePath] pathComponents];
        NSString *path = [NSString pathWithComponents: pathComponents];
        [[NSWorkspace sharedWorkspace] launchApplication:path];
        [NSApp terminate: nil];
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

