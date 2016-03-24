//
//  AppDelegate.swift
//  Cricket Score Applet
//
//  Created by Adhithyan Vijayakumar on 19/03/16.
//  Copyright © 2016 Adhithyan Vijayakumar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSXMLParserDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        if #available(OSX 10.10, *) {
            if let button = statusItem.button{
                button.image = NSImage(named: "cricscore_indicator-default")
                button.action = Selector("togglePopover:")
            }
        } else {
            // Fallback on earlier versions
        }
        
        popover.contentViewController = ScoreViewController(nibName: "ScoreViewController", bundle: nil)

        //parse()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func showPopover(sender: AnyObject?){
        if #available(OSX 10.10, *) {
            if let button = statusItem.button{
                popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func closePopover(sender: AnyObject?){
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?){
        if(popover.shown){
            closePopover(sender)
        }else{
            showPopover(sender)
        }
        
    }
    
}

