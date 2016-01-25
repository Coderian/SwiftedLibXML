//
//  SwiftedLibXMLTests.swift
//  SwiftedLibXMLTests
//
//  Created by 佐々木 均 on 2016/01/25.
//  Copyright © 2016年 S-Parts. All rights reserved.
//

import XCTest
@testable import SwiftedLibXML

class SwiftedLibXMLTests: XCTestCase {
    let bundle = NSBundle(forClass: SwiftedLibXMLTests.self)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testXSDValidate() {
        let xsdPath = bundle.pathForResource("test", ofType: "xsd")
        let xmlPath = bundle.pathForResource("test", ofType: "xml")
        let schema:XmlSchema = XmlSchema(path: xsdPath!)
        let xml:XmlDoc = XmlReader.read(xmlPath!)
        XCTAssert(schema.validate(xml))
        
        let invalidXmlPath = bundle.pathForResource("invalidtest", ofType: "xml")
        let invalidxml:XmlDoc = XmlReader.read(invalidXmlPath!)
        XCTAssert(schema.validate(invalidxml) == false)
    }
    
    func testXMLNode(){
        let xmlPath = bundle.pathForResource("test", ofType: "xml")
        let xml:XmlDoc = XmlReader.read(xmlPath!)
        XCTAssertNotNil(xml.root)
        print(xml.root)
        XCTAssertNotNil(xml.root.name)
        print(xml.root.name)
        XCTAssertNotNil(xml.root.content)
        print(xml.root.content)
        XCTAssertNotNil(xml.root.elementType)
        print(xml.root.elementType)
        XCTAssertNotNil(xml.root.attributes)
        print(xml.root.attributes)
        XCTAssertFalse(xml.root.IsBlankNode)
        XCTAssertFalse(xml.root.IsText)
        var node : XmlNode = xml.root.firstElementChild()
        while node.IsNil == false {
            print(node)
            print(node.attributes)
            print(node.content)
            if 0 < node.childElementCount() {
                node = node.children
            }
            else {
                node = node.next()
            }
        }
        print(xml.root.firstElementChild().name)
        print(xml.root.firstElementChild().content)
        print(xml.root.firstElementChild().attributes)
        print(xml.root.firstElementChild().firstElementChild().name)
        print(xml.root.firstElementChild().firstElementChild().content)
        print(xml.root.children.name)
        print(xml.root.children.content)

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
