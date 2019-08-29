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
        XCTAssertEqual(contentModel?.type, CTContentType.allStatic)

        XCTAssertEqual(contentModel?.title, "Cool new app feature")
        XCTAssertEqual(contentModel?.body, "Today we have a new feature for you to try out, this will blow you out of the water\nBody text even more")
        XCTAssertEqual(contentModel?.imageUrl, "https://example.com/image.png")

        XCTAssertEqual(contentModel?.pages.count, 0)

        XCTAssertEqual(contentModel?.actions[0].text, "Theft")
        XCTAssertEqual(contentModel?.actions[0].link, "app://sparta/cool_feature_link")

        XCTAssertEqual(contentModel?.actions[1].text, "Feature")
        XCTAssertEqual(contentModel?.actions[1].link, "app://sparta/cool_feature_link")
    }

    func test_AllMoving() {
        let content = Resolver().getMarkownForResource(name: "allMoving")
        let parser = CTMarkdownParser()

        let contentModel = parser.parseContent(withContentString: content)
        XCTAssertEqual(contentModel?.type, CTContentType.allMoving)

        XCTAssertNil(contentModel?.title)
        XCTAssertNil(contentModel?.body)
        XCTAssertNil(contentModel?.imageUrl)

        XCTAssertEqual(contentModel?.pages.count, 3)

        XCTAssertEqual(contentModel?.pages[0].title, "Added Statistics page")
        XCTAssertEqual(contentModel?.pages[0].body, "Today we have a new feature for you to try out, this will blow you out of the water\nBody text")
        XCTAssertEqual(contentModel?.pages[0].imageUrl, "https://example.com/image.png")


        XCTAssertEqual(contentModel?.pages[1].title, "All new activity center")
        XCTAssertEqual(contentModel?.pages[1].body, "Today we have a new feature for you to try out, this will blow you out of the water\nBody text more")
        XCTAssertEqual(contentModel?.pages[1].imageUrl, "https://example.com/image.png")

        XCTAssertEqual(contentModel?.pages[2].title, "Theft lock now active")
        XCTAssertEqual(contentModel?.pages[2].body, "Today we have a new feature for you to try out, this will blow you out of the water\nBody text even more")
        XCTAssertEqual(contentModel?.pages[2].imageUrl, "https://example.com/image.png")

        XCTAssertEqual(contentModel?.actions.count, 0)
    }

    func test_staticTitle() {
        let content = Resolver().getMarkownForResource(name: "titleStatic")
        let parser = CTMarkdownParser()

        let contentModel = parser.parseContent(withContentString: content)
        XCTAssertEqual(contentModel?.type, CTContentType.titleStatic)

        XCTAssertEqual(contentModel?.title, "Cool new app feature")
        XCTAssertNil(contentModel?.body)
        XCTAssertNil(contentModel?.imageUrl)

        XCTAssertEqual(contentModel?.pages.count, 3)
        XCTAssertNil(contentModel?.pages[0].title)
        XCTAssertEqual(contentModel?.pages[0].body, "Body text")
        XCTAssertEqual(contentModel?.pages[0].imageUrl, "https://example.com/image.png")


        XCTAssertNil(contentModel?.pages[1].title)
        XCTAssertEqual(contentModel?.pages[1].body, "Body text more")
        XCTAssertEqual(contentModel?.pages[1].imageUrl, "https://example.com/image.png")

        XCTAssertNil(contentModel?.pages[2].title)
        XCTAssertEqual(contentModel?.pages[2].body, "Body text even more")
        XCTAssertEqual(contentModel?.pages[2].imageUrl, "https://example.com/image.png")

        XCTAssertEqual(contentModel?.actions[0].text, "Show me the feature")
        XCTAssertEqual(contentModel?.actions[0].link, "app://sparta/cool_feature_link")
    }

    func test_staticBodyAndTitle() {
        let content = Resolver().getMarkownForResource(name: "titleAndBodyStatic")
        let parser = CTMarkdownParser()

        let contentModel = parser.parseContent(withContentString: content)
        XCTAssertEqual(contentModel?.type, CTContentType.titleAndBodyStatic)

        XCTAssertEqual(contentModel?.title, "Cool new app feature")
        XCTAssertEqual(contentModel?.body, "Today we have a new feature for you to try out, this will blow you out of the water")
        XCTAssertNil(contentModel?.imageUrl)

        XCTAssertEqual(contentModel?.pages.count, 3)

        XCTAssertNil(contentModel?.pages[0].title)
        XCTAssertNil(contentModel?.pages[0].body)
        XCTAssertEqual(contentModel?.pages[0].imageUrl, "https://example.com/image.png")


        XCTAssertNil(contentModel?.pages[1].title)
        XCTAssertNil(contentModel?.pages[1].body)
        XCTAssertEqual(contentModel?.pages[1].imageUrl, "https://example.com/image.png")

        XCTAssertNil(contentModel?.pages[2].title)
        XCTAssertNil(contentModel?.pages[2].body)
        XCTAssertEqual(contentModel?.pages[2].imageUrl, "https://example.com/image.png")

        XCTAssertEqual(contentModel?.actions[0].text, "Show me the feature")
        XCTAssertEqual(contentModel?.actions[0].link, "app://sparta/cool_feature_link")
    }
}
