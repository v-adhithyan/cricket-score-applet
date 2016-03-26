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
        //print(applicationIsInStartupItem())
        
        if #available(OSX 10.10, *) {
            if let button = statusItem.button{
                
                button.image = NSImage(named: getIconName())
                button.action = Selector("togglePopover:")
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

    func showPopover(sender: AnyObject?){
        if #available(OSX 10.10, *) {
            if let button = statusItem.button{
                button.image = NSImage(named: self.getIconName())
                //window.collectionBehavior = NSWindowCollectionBehavior.FullScreenAuxiliary
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
    
    func getIconName() -> String {
        let appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
        var iconName : String
        
        if(appearance) == "Dark"{
            iconName = "cricscore_indicator-default-dark"
        }else{
            iconName = "cricscore_indicator-default"
        }
        
        return iconName;
        
    }
    
    func applicationIsInStartupItem() -> Bool {
        return (itemInLoginItems().existingReference != nil)
    }
    
    func itemInLoginItems() -> (existingReference: LSSharedFileListItemRef?, lastReference: LSSharedFileListItemRef?){
        let itemUrl: UnsafeMutablePointer<Unmanaged<CFURL>?> = UnsafeMutablePointer<Unmanaged<CFURL>?>.alloc(1)
        
        if let appUrl: NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath){
            let loginItemRef = LSSharedFileListCreate(nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil).takeRetainedValue() as LSSharedFileListRef?
            
            if loginItemRef != nil{
                let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemRef, nil).takeRetainedValue() as NSArray
                print("login items count \(loginItems.count)")
                let lastItemRef: LSSharedFileListItemRef = loginItems.lastObject as! LSSharedFileListItemRef
                
                if(loginItems.count > 0){
                    for var i=0; i<loginItems.count; i++ {
                        let currentItemRef: LSSharedFileListItemRef = loginItems.objectAtIndex(i) as! LSSharedFileListItemRef
                        
                        if LSSharedFileListItemResolve(currentItemRef,0 ,itemUrl, nil) == noErr {
                            if let urlRef: NSURL = itemUrl.memory?.takeRetainedValue() {
                                print("url ref: \(urlRef.lastPathComponent)")
                                if(urlRef.isEqual(appUrl)){
                                    return (currentItemRef, lastItemRef)
                                }
                            }
                        } else{
                            print("unknown application")
                        }
                    }
                    return (nil, lastItemRef)

                }else{
                    let addAtStart: LSSharedFileListItemRef = kLSSharedFileListItemBeforeFirst.takeRetainedValue()
                    return (nil, addAtStart)

                }
            }

        }
        return (nil, nil)
    }
    
    func toggleLaunchAtStartup() {
        let itemReferences = itemInLoginItems()
        let shouldBeToggled = (itemReferences.existingReference == nil)
        
        let loginItemsRef = LSSharedFileListCreate(nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileListRef!
        
        if loginItemsRef != nil {
            if shouldBeToggled {
                if let appUrl: CFURLRef = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath){
                    LSSharedFileListInsertItemURL(
                        loginItemsRef,
                        itemReferences.lastReference,
                        nil,
                        nil,
                        appUrl,
                        nil,
                        nil
                    )
                    print("app added to login items")
                }
            } else{
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef, itemRef);
                    print("app was removed from login items")
                }
            }
        }
        
    }
    
    
    
}

