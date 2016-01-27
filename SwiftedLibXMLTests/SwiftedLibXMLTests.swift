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
        
        let kmlXsdPath = bundle.pathForResource("ogckml22", ofType: "xsd")
        let kmlXmlPath = bundle.pathForResource("KML_Sample", ofType: "kml")
        let kmlSchema:XmlSchema = XmlSchema()
        kmlSchema.parse(kmlXsdPath!)
        let kmlXml:XmlDoc = XmlReader.read(kmlXmlPath!)
        XCTAssert(kmlSchema.validate(kmlXml))
        
        // XmlSchema 使い回しテスト
        schema.parse(kmlXsdPath!)
        XCTAssertFalse(schema.validate(xml))
    }
    
    func testXMLNode(){
        let xmlPath = bundle.pathForResource("test", ofType: "xml")
        let xml:XmlDoc = XmlReader.read(xmlPath!)
        XCTAssertFalse(xml.root.IsNil)
        print(xml.root)

        XCTAssertNotNil(xml.root.name)
        print(xml.root.name)
        XCTAssertNotNil(xml.root.content)
        print(xml.root.content)
        XCTAssertNotNil(xml.root.elementType)
        print(xml.root.elementType)
        XCTAssertFalse(xml.root.attribute.IsNil)
        print(xml.root.attribute)
        XCTAssert(xml.root.attribute.prev().IsNil)
        XCTAssertFalse(xml.root.IsBlankNode)
        XCTAssertFalse(xml.root.IsText)
        var node : XmlNode = xml.root.firstElementChild()
        print(node.parent)
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
        print(xml.root.lastElementChild().name)
        print(xml.root.children.next().name)
        print(xml.root.children.next().prev().name)
        print(xml.root.children.last().IsBlankNode)
        print(xml.root.children.lastChlid().IsBlankNode)
    }
    
    
    func testSAXParser(){
        let xmlPath = bundle.pathForResource("test", ofType: "xml")
        let parser: XmlSAXParser = XmlSAXParser()
        parser.parse(xmlPath!)
        print("kml parse...")
        let kmlparser: XmlSAXParser = XmlSAXParser()
        let kmlPath = bundle.pathForResource("KML_Sample", ofType: "kml")
        kmlparser.parse(kmlPath!)
        
        print("CustomHandler...")
        // CustomHandler テスト
        // テスト用カスタムSAX2Handler
        struct CustomXmlSAXHandler : HasSAX2Handler {
            func OnStartElementNs(ctx: UnsafeMutablePointer<Void>,
                localname:UnsafePointer<xmlChar>,
                prefix: UnsafePointer<xmlChar>,
                uri: UnsafePointer<xmlChar>,
                nb_namespaces:CInt,
                namespaces:UnsafeMutablePointer<UnsafePointer<xmlChar>>,
                nb_attributes:CInt,
                nb_defaulted:CInt,
                attributes:UnsafeMutablePointer<UnsafePointer<xmlChar>> ) {
                    print("CustomXMlSAParser called OnStartElementNs: [\(String.fromLIBXMLString(localname))]")
                    if prefix != nil {
                        print("prefix[\(String.fromLIBXMLString(prefix))]")
                    }
                    if uri != nil {
                        print("uri[\(String.fromLIBXMLString(uri))]")
                    }
                    // これでいいのか不明...
                    for namespaceIndex:Int in 0..<Int(nb_namespaces) {
                        let namespaceFirstArgIndex:Int = namespaceIndex * 2
                        if namespaces[namespaceFirstArgIndex] != nil {
                                print("namespaces[\(namespaceIndex)][0]=[\(String.fromLIBXMLString(namespaces[namespaceFirstArgIndex]))]")
                        }
                        if namespaces[namespaceFirstArgIndex+1] != nil {
                                print("namespaces[\(namespaceIndex)][1]=[\(String.fromLIBXMLString(namespaces[namespaceFirstArgIndex+1]))]")
                        }
                    }
                    for attributeIndex:Int in 0..<Int(nb_attributes) {
                        // [0]name,[1]?,[2]?,[3]value開始位置,[4]value終了位置
                        let attributeNameIndex:Int = attributeIndex * 5
                        let attributeValueIndex:Int = attributeNameIndex + 3
                        let str = String.fromLIBXMLString(attributes[attributeValueIndex])
                        let len = str.characters.count - String.fromLIBXMLString(attributes[attributeValueIndex+1]).characters.count
                        let endIndex = str.startIndex.advancedBy(len)
                        let attributeValue = str.substringToIndex(endIndex)
                        print("attributes[\(attributeIndex)] [\(String.fromLIBXMLString(attributes[attributeNameIndex]))]=[\(attributeValue))]")
                    }
            }
            func OnEndElementNs(ctx: UnsafeMutablePointer<Void>, localname: UnsafePointer<xmlChar>, prefix: UnsafePointer<xmlChar>, uri: UnsafePointer<xmlChar>) {
                print("CustomXMlSAParser called OnEndElementNs: [\(String.fromLIBXMLString(localname))]")
            }
            func OnCharacters(ctx: UnsafeMutablePointer<Void>, ch: UnsafePointer<xmlChar>, len: CInt){
                let str = String.fromLIBXMLString(ch)
                let endIndex = str.startIndex.advancedBy(Int(len))
                print("CustomXMlSAParser called OnCharacters: [\(str.substringToIndex(endIndex))] len:\(len)")
            }
        }
        let customParser: XmlSAXParser = XmlSAXParser(handled: CustomXmlSAXHandler())
        customParser.parse(kmlPath!)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
