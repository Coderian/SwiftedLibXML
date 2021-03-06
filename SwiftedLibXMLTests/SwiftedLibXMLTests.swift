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
        // テスト用カスタムSAX2Handler,parse結果を取得するため参照型のclassを使用
        class CustomXmlSAX2Handler : HasSAX2Handler {
            private var elementname:String = ""
            // parse結果取得用
            var elementNames:[String] = []
            func OnStartElementNs(context: Any?,
                localname:String,
                prefix: String?,
                uri: String?,
                namespaces:[String],
                attributes:[String:String]) {
                    print("CustomXMlSAParser called OnStartElementNs: [\(localname)]")
                    if prefix != nil {
                        print("prefix[\(prefix)]")
                    }
                    if uri != nil {
                        print("uri[\(uri)]")
                    }
                    print(namespaces)
                    print(attributes)
                    elementname = localname
                    elementNames.append(localname)
            }
            func OnEndElementNs(context: Any?, localname: String, prefix: String?, uri: String?) {
                print("CustomXMlSAParser called OnEndElementNs: [\(localname)]")
            }
            func OnCharacters(context: Any?, contents: String){
                // CAUTION: contentsが長い場合は複数回呼ばれる
                print("CustomXMlSAParser called OnCharacters")
                if(contents.characters.first != "\n"){
                    print("\(elementname)=" + contents)
                }
            }
        }
        let handle = CustomXmlSAX2Handler()
        let customParser: XmlSAXParser = XmlSAXParser(handled: handle)
        customParser.parse(kmlPath!)
        // parse結果取得
        print(handle.elementNames)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
