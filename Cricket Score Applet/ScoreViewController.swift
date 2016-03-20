//
//  ScoreViewController.swift
//  Cricket Score Applet
//
//  Created by Adhithyan Vijayakumar on 19/03/16.
//  Copyright © 2016 Adhithyan Vijayakumar. All rights reserved.
//

import Cocoa

class ScoreViewController: NSViewController, NSXMLParserDelegate {
    @IBOutlet var scoreCard: NSTextField!
    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var contentTitle = NSMutableString()
    var content = NSMutableString()
    var link = NSMutableString()
    var currentScoreIndex: Int = 0{
        didSet{
            updateScore()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginParsing()
        print(posts.count)
    }
    
    
    func beginParsing(){
        posts = []
        parser = NSXMLParser(contentsOfURL: NSURL(string:"http://live-feeds.cricbuzz.com/CricbuzzFeed?format=xml")!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName
        
        if (elementName as NSString).isEqualToString("item"){
            elements = NSMutableDictionary()
            elements = [:]
            
            contentTitle = NSMutableString()
            contentTitle = ""
            
            link = NSMutableString()
            link = ""
            
            content = NSMutableString()
            content = ""
        }
    }

    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
       
        
        if(elementName as NSString).isEqualToString("item"){
            if (contentTitle.length == 0){
                elements.setObject(contentTitle, forKey: "title")
            }
            
            if(content.length == 0){
                elements.setObject(content, forKey: "description")
            }
            
            if(link.length == 0){
                elements.setObject(link, forKey: "link")
            }
            posts.addObject(elements)
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if element.isEqualToString("title") {
            contentTitle.appendString(string)
        } else if element.isEqualToString("description") {
            content.appendString(string)
        } else if element.isEqualToString("link"){
            link.appendString(string)
        }
    }
    
    func updateScore(){
        scoreCard.stringValue = posts[currentScoreIndex] as! String
    }
}

extension ScoreViewController{
    @IBAction func goLeft(sender: NSButton){
        currentScoreIndex = (currentScoreIndex - 1 + posts.count) % (posts.count)
        print(currentScoreIndex)
    }
    
    @IBAction func goRight(sender: NSButton){
        currentScoreIndex = (currentScoreIndex + 1) % (posts.count)
        print(currentScoreIndex)
    }
}



