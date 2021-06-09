//
//  CTMarkdownParserTests.swift
//  ctkit_Tests
//
//  Created by Gert-Jan Vercauteren on 28/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
import RxBlocking
import Mockingjay

@testable import ctkit

class CTMarkdownParserTests: XCTestCase {
    
    func test_allStatic() {
        let content = Resolver().getMarkownForResource(name: "static")
        let parser = CTMarkdownParser()
        
        let contentModel = parser.parseContent(withContentString: content)
        
        XCTAssertEqual(contentModel?.body?.title, "Cool new app feature")
        XCTAssertEqual(contentModel?.body?.body, "Today we have a new feature for you to try out, this will blow you out of the water\nBody text even more")
        XCTAssertEqual(contentModel?.body?.imageUrl, "https://example.com/image.png")
        
        XCTAssertEqual(contentModel?.pages?.count, 0)
        
        XCTAssertEqual(contentModel?.button?.text, "Theft")
        XCTAssertEqual(contentModel?.button?.link, "app://sparta/cool_feature_link")
    }
    
    func test_AllMoving() {
        let content = Resolver().getMarkownForResource(name: "allMoving")
        let parser = CTMarkdownParser()
        
        let contentModel = parser.parseContent(withContentString: content)
        
        
        XCTAssertNil(contentModel?.body?.title)
        XCTAssertNil(contentModel?.body?.body)
        XCTAssertNil(contentModel?.body?.imageUrl)
        
        
        if let pages = contentModel?.pages {
            
            XCTAssertEqual(pages.count, 3)
            
            XCTAssertEqual(pages[0]?.title, "Added Statistics page")
            XCTAssertEqual(pages[0]?.body, "Today we have a new feature for you to try out, this will blow you out of the water\nBody text")
            XCTAssertEqual(pages[0]?.imageUrl, "https://example.com/image.png")
            
            
            XCTAssertEqual(pages[1]?.title, "All new activity center")
            XCTAssertEqual(pages[1]?.body, "Today we have a new feature for you to try out, this will blow you out of the water\nBody text more")
            XCTAssertEqual(pages[1]?.imageUrl, "https://example.com/image.png")
            
            XCTAssertEqual(pages[2]?.title, "Theft lock now active")
            XCTAssertEqual(pages[2]?.body, "Today we have a new feature for you to try out, this will blow you out of the water\nBody text even more")
            XCTAssertEqual(pages[2]?.imageUrl, "https://example.com/image.png")
            
        }
    }
    func test_staticTitle() {
        let content = Resolver().getMarkownForResource(name: "titleStatic")
        let parser = CTMarkdownParser()
        
        let contentModel = parser.parseContent(withContentString: content)
        
        
        XCTAssertEqual(contentModel?.body?.title, "Cool new app feature")
        XCTAssertNil(contentModel?.body?.body)
        XCTAssertNil(contentModel?.body?.imageUrl)
        
        if let pages = contentModel?.pages {
            
            XCTAssertEqual(pages.count, 3)
            XCTAssertNil(pages[0]?.title)
            XCTAssertEqual(pages[0]?.body, "Body text")
            XCTAssertEqual(pages[0]?.imageUrl, "https://example.com/image.png")
            
            
            XCTAssertNil(pages[1]?.title)
            XCTAssertEqual(pages[1]?.body, "Body text more")
            XCTAssertEqual(pages[1]?.imageUrl, "https://example.com/image.png")
            
            XCTAssertNil(pages[2]?.title)
            XCTAssertEqual(pages[2]?.body, "Body text even more")
            XCTAssertEqual(pages[2]?.imageUrl, "https://example.com/image.png")
        }
        XCTAssertEqual(contentModel?.button?.text, "Show me the feature")
        XCTAssertEqual(contentModel?.button?.link, "app://sparta/cool_feature_link")
    }
    
    func test_staticBodyAndTitle() {
        let content = Resolver().getMarkownForResource(name: "titleAndBodyStatic")
        let parser = CTMarkdownParser()
        
        let contentModel = parser.parseContent(withContentString: content)
        
        XCTAssertEqual(contentModel?.body?.title, "Cool new app feature")
        XCTAssertEqual(contentModel?.body?.body, "Today we have a new feature for you to try out, this will blow you out of the water")
        XCTAssertNil(contentModel?.body?.imageUrl)
        
        if let pages = contentModel?.pages {
            XCTAssertEqual(pages.count, 3)
            
            XCTAssertNil(pages[0]?.title)
            XCTAssertNil(pages[0]?.body)
            XCTAssertEqual(pages[0]?.imageUrl, "https://example.com/image.png")
            
            
            XCTAssertNil(pages[1]?.title)
            XCTAssertNil(pages[1]?.body)
            XCTAssertEqual(pages[1]?.imageUrl, "https://example.com/image.png")
            
            XCTAssertNil(pages[2]?.title)
            XCTAssertNil(pages[2]?.body)
            XCTAssertEqual(pages[2]?.imageUrl, "https://example.com/image.png")
        }
        XCTAssertEqual(contentModel?.button?.text, "Show me the feature")
        XCTAssertEqual(contentModel?.button?.link, "app://sparta/cool_feature_link")
    }
}
