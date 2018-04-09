//
//  AppDelegate.swift
//  Cricket Score Applet
//
//  Created by Adhithyan Vijayakumar on 19/03/16.
//  Copyright © 2016 Adhithyan Vijayakumar. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, XMLParserDelegate {

    @IBOutlet weak var window: NSWindow!
    var button: NSButton!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        //print(applicationIsInStartupItem())
        
        if #available(OSX 10.10, *) {
            if let button = statusItem.button{
                
                button.image = NSImage(named: getIconName())
                button.action = #selector(togglePopover(_:))
            }
        } else {
            // Fallback on earlier versions
        }
        
        popover.contentViewController = ScoreViewController(nibName: "ScoreViewController", bundle: nil)

               //parse()
        //toggleLaunchAtStartup()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @objc func showPopover(_ sender: Any?){
        if #available(OSX 10.10, *) {
            if let button = statusItem.button{
                button.image = NSImage(named: self.getIconName())
                //window.collectionBehavior = NSWindowCollectionBehavior.FullScreenAuxiliary
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc func closePopover(_ sender: Any?){
        popover.performClose(sender)
    }
    
    @available(OSX 10.10, *)
    @objc func togglePopover(_ sender: Any?){
        if(popover.isShown){
            statusItem.button!.action = #selector(closePopover(_:))
        }else{
            statusItem.button!.action = #selector(showPopover(_:))
        }
        
    }
    
    func getIconName() -> String {
        let appearance = NSAppearance.current().name
        var iconName : String
        
        if(appearance) == "Dark"{
            iconName = "cricscore_indicator-default-dark"
        }else{
            iconName = "cricscore_indicator-default"
        }
        
        return iconName;
        
    }
    

}

