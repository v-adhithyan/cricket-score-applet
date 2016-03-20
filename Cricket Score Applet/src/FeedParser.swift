//
//  FeedParser.swift
//  Cricket Score Applet
//
//  Created by Adhithyan Vijayakumar on 20/03/16.
//  Copyright © 2016 Adhithyan Vijayakumar. All rights reserved.
//

import Foundation

var parser = NSXMLParser()
var posts = NSMutableArray()
var elements = NSMutableDictionary()
var element = NSString()
var title = NSMutableString()
var description = NSMutableString()

func beginParsing(){
    posts = []
    
    parser = NSXMLParser(contentsOfURL: NSURL(string: "http://live-feeds.cricbuzz.com/CricbuzzFeed?format=xml")!)!
    parser.parse()
    
    print(parser)
}