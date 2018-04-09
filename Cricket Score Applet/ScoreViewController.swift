//
//  ScoreViewController.swift
//  Cricket Score Applet
//
//  Created by Adhithyan Vijayakumar on 19/03/16.
//  Copyright © 2016 Adhithyan Vijayakumar. All rights reserved.
//

import Cocoa

class ScoreViewController: NSViewController, XMLParserDelegate {
    @IBOutlet var scoreCard: NSTextField!
    

    var parser = XMLParser()
    var posts = NSMutableArray()
    var content = NSMutableString()
    var currentItem = ""
    var itemCount = 0
    var appendCount = 0
    var currentScoreIndex: Int = 0{
        didSet{
            updateScore()
        }
    }
    //let scores = Score.all
    //viewdidload is available only on 10.10 and later
    override func viewDidLoad() {
        if #available(OSX 10.10, *) {
            super.viewDidLoad()
            
        } else {
            // Fallback on earlier versions
        }
        self.beginParsing()
        updateScore()
    }
    
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf: URL(string:"http://live-feeds.cricbuzz.com/CricbuzzFeed?format=xml")!)!
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    
        if(elementName == "item"){
            itemCount = itemCount + 1;
            content = NSMutableString()
        }
        
        switch(elementName){
            case "title":
                currentItem = "title"
                break
            case "description":
                currentItem = "description"
                break
            case "link":
                currentItem = "link"
                break
            default:
                break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if(elementName == "item"){
            itemCount = itemCount - 1;
            currentItem = ""
            appendCount = 0
            posts.add(content)
        }
    }
    
    @nonobjc func parser(parser: XMLParser, foundCharacters string: String) {
        
        if(itemCount == 1){
            if(currentItem == "title" || currentItem == "description"){
                
                if(appendCount < 3){
                    content.append(string)
                }
                appendCount = appendCount + 1;
            }
        }
    }
    
    func updateScore(){
        scoreCard.stringValue = String(describing: posts[currentScoreIndex])
    }
    
    func removeHtml(string: String){
        
    }
}

extension ScoreViewController{
    @IBAction func goLeft(sender: NSButton){
        currentScoreIndex = (currentScoreIndex - 1 + posts.count) % (posts.count)
    }
    
    @IBAction func goRight(sender: NSButton){
        currentScoreIndex = (currentScoreIndex + 1) % (posts.count)
    }
    
    @IBAction func refresh(sender: NSButton){
        beginParsing()
        updateScore()
    }
    
    
}



