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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let bundle = NSBundle(forClass: SwiftedLibXMLTests.self)
        let xsdPath = bundle.pathForResource("test", ofType: "xsd")
        let xmlPath = bundle.pathForResource("test", ofType: "xml")
        let schema:XmlSchema = XmlSchema(path: xsdPath!)
        let xml:XmlDoc = XmlReader.read(xmlPath!)
        
        XCTAssert(schema.validate(xml))
        if schema.validate(xml) {
            print("OK")
        }
        else{
            print("NG")
        }
        let invalidXmlPath = bundle.pathForResource("invalidtest", ofType: "xml")
        let invalidxml:XmlDoc = XmlReader.read(invalidXmlPath!)
        XCTAssert(schema.validate(invalidxml) == false)
        if schema.validate(invalidxml) {
            print("OK")
        }
        else{
            print("NG")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
