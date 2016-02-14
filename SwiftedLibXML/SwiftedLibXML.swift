//
//  SwiftedLibXML.swift
//  SwiftedLibXML
//
//  Created by 佐々木 均 on 2016/01/25.
//  Copyright © 2016年 S-Parts. All rights reserved.
//

import Foundation

// TODO:impliment
func xmlSchemaValidityError(ctx: UnsafeMutablePointer<Void>, msg: UnsafePointer<Int8> , arguments: CVaListPointer) -> Void {
    
}
// TODO:Impliment
func xmlSchemaValidityWarning(context: UnsafeMutablePointer<Void>, msg: UnsafePointer<Int8>, arguments: CVaListPointer) -> Void {
    
}

public class XmlSchema {
    private var schema:xmlSchemaPtr = nil
    public init(){}
    public init(path: String){
        let parser = XmlSchemaParser(path:path)
//        let errfunc:COpaquePointer = COpaquePointer(xmlSchemaValidityError)
//        let p = UnsafeMutablePointer<(UnsafeMutablePointer<Void>,UnsafePointer<Int8>,CVaListPointer) -> Void>.alloc(1)
//        p.initialize(xmlSchemaValidityError)
//        xmlSchemaSetParserErrors(nil, COpaquePointer(p), nil, nil)
        self.schema = parser.parse()
    }
    deinit{
        if schema != nil {
            xmlSchemaFree(self.schema)
        }
    }
    
    public func parse(path: String){
        let parser = XmlSchemaParser(path:path)
        if self.schema != nil {
            xmlSchemaFree(self.schema)
        }
        self.schema = parser.parse()
    }
    
    public class XmlSchemaParser {
        private var context:xmlSchemaParserCtxtPtr = nil
        public init(path: String) {
            self.context = xmlSchemaNewParserCtxt(path)
        }
        deinit {
            xmlSchemaFreeParserCtxt(self.context)
        }
        public func parse()-> xmlSchemaPtr {
            return xmlSchemaParse(self.context)
        }
    }
    
    public class XmlSchemaValidater {
        private var context:xmlSchemaValidCtxtPtr = nil
        init(schema:XmlSchema){
            self.context = xmlSchemaNewValidCtxt(schema.schema)
        }
        deinit{
            xmlSchemaFreeValidCtxt(self.context)
        }
        public func validate(doc:XmlDoc) -> Bool {
            return xmlSchemaValidateDoc(self.context, doc.doc) == 0
        }
    }
    
    public func validate(doc:XmlDoc) -> Bool {
        let validater = XmlSchemaValidater(schema: self)
        return validater.validate(doc)
    }
    
}

extension String {
    static func fromLIBXMLString( usp:UnsafePointer<xmlChar> ) -> String {
        return String.fromCString(UnsafePointer<CChar>(usp))!
    }
}

// TODO: impliment
public class XmlNameSpace {
    private var namesapce: xmlNsPtr = nil
}

public class XmlAttribute {
    private var attribute: xmlAttrPtr = nil
    public init ( attribute: xmlAttrPtr) {
        self.attribute = attribute
    }
    deinit{
        //        xmlFreeProp(self.attribute)
    }
    public var IsNil:Bool {
        get {
            return self.attribute == nil
        }
    }
    public var name : String {
        get {
            return String.fromLIBXMLString(attribute.memory.name)
        }
    }
    public var value : String {
        get {
            return String.fromLIBXMLString(attribute.memory.children.memory.content)
        }
    }
    public var type : xmlAttributeType {
        get {
            return attribute.memory.atype
        }
    }
    public func next() -> XmlAttribute {
        return XmlAttribute(attribute: self.attribute.memory.next)
    }
    public func prev() -> XmlAttribute {
        return XmlAttribute(attribute: self.attribute.memory.prev)
    }
}

extension XmlAttribute : CustomStringConvertible {
    public var description : String {
        get {
            return "type=" + self.type.description + ",name=" + self.name + ",value=" + self.value
        }
    }
}

extension xmlAttributeType : CustomStringConvertible
{
    public var description : String {
        get {
            let retValue: String
            switch self {
            case XML_ATTRIBUTE_CDATA:
                retValue = "XML_ATTRIBUTE_CDATA"
            case XML_ATTRIBUTE_ID:
                retValue = "XML_ATTRIBUTE_ID"
            case XML_ATTRIBUTE_IDREF:
                retValue = "XML_ATTRIBUTE_IDREF"
            case XML_ATTRIBUTE_ENTITY:
                retValue = "XML_ATTRIBUTE_ENTITY"
            case XML_ATTRIBUTE_ENTITIES:
                retValue = "XML_ATTRIBUTE_ENTITIES"
            case XML_ATTRIBUTE_NMTOKEN:
                retValue = "XML_ATTRIBUTE_NMTOKEN"
            case XML_ATTRIBUTE_NMTOKENS:
                retValue = "XML_ATTRIBUTE_NMTOKENS"
            case XML_ATTRIBUTE_ENUMERATION:
                retValue = "XML_ATTRIBUTE_ENUMERATION"
            case XML_ATTRIBUTE_NOTATION:
                retValue = "XML_ATTRIBUTE_NOTATION"
            default:
                return "not specification"
            }
            return retValue + "=" + self.rawValue.description
        }
    }
}

extension xmlElementType : CustomStringConvertible
{
    public var description : String {
        get {
            let retValue: String
            switch self {
            case XML_ELEMENT_NODE:
                retValue = "XML_ELEMENT_NODE"
            case XML_ATTRIBUTE_NODE:
                retValue = "XML_ATTRIBUTE_NODE"
            case XML_TEXT_NODE :
                retValue = "XML_TEXT_NODE"
            case XML_CDATA_SECTION_NODE:
                retValue = "XML_CDATA_SECTION_NODE"
            case XML_ENTITY_REF_NODE :
                retValue = "XML_ENTITY_REF_NODE"
            case XML_ENTITY_NODE:
                retValue = "XML_ENTITY_NODE"
            case XML_PI_NODE:
                retValue = "XML_PI_NODE"
            case XML_COMMENT_NODE:
                retValue = "XML_COMMENT_NODE"
            case XML_DOCUMENT_NODE:
                retValue = "XML_DOCUMENT_NODE"
            case XML_DOCUMENT_TYPE_NODE:
                retValue = "XML_DOCUMENT_TYPE_NODE"
            case XML_DOCUMENT_FRAG_NODE:
                retValue = "XML_DOCUMENT_FRAG_NODE"
            case XML_NOTATION_NODE:
                retValue = "XML_NOTATION_NODE"
            case XML_HTML_DOCUMENT_NODE:
                retValue = "XML_DOCUMENT_NODE"
            case XML_DTD_NODE:
                retValue = "XML_DTD_NODE"
            case XML_ELEMENT_DECL:
                retValue = "XML_ELEMENT_DECL"
            case XML_ATTRIBUTE_DECL:
                retValue = "XML_ATTRIBUTE_DECL"
            case XML_ENTITY_DECL:
                retValue = "XML_ENTITY_DECL"
            case XML_NAMESPACE_DECL:
                retValue = "XML_NAMESPACE_DECL"
            case XML_XINCLUDE_START:
                retValue = "XML_XINCLUDE_START"
            case XML_XINCLUDE_END:
                retValue = "XML_XINCLUDE_END"
            case XML_DOCB_DOCUMENT_NODE:
                retValue = "XML_DOCB_DOCUMENT_NODE"
            default:
                return "not specifiation"
            }
            return retValue + "=" + self.rawValue.description
        }
    }
}

public class XmlNode {
    private var node : xmlNodePtr = nil
    
    public init( node: xmlNodePtr){
        self.node = node
    }
    // TODO:impliment
    public var namespace : XmlNameSpace {
        get {
            return XmlNameSpace()
        }
    }
    public var attribute : XmlAttribute {
        get {
            let attr = XmlAttribute(attribute: self.node.memory.properties)
            return attr
        }
    }
    public var attributes : [String: String] {
        get {
            var dictonary = [String: String]()
            var attr = attribute
            while attr.attribute != nil {
                dictonary[attr.name] = attr.value
                attr = attr.next()
            }
            return dictonary
        }
    }
    public var name : String {
        get {
            return String.fromLIBXMLString(self.node.memory.name)
        }
    }
    public var parent : XmlNode {
        get {
            return XmlNode(node: self.node.memory.parent)
        }
    }
    public var children : XmlNode {
        get {
            return XmlNode(node: self.node.memory.children)
        }
    }
    
    public var elementType:xmlElementType {
        get {
            return self.node.memory.type
        }
    }
    
    public var IsNil:Bool {
        get {
            return self.node == nil
        }
    }
    
    public var IsBlankNode:Bool {
        get{
            return xmlIsBlankNode(self.node) == 1
        }
    }
    public var IsText: Bool {
        get {
            return xmlNodeIsText(self.node) == 1
        }
    }
    public var content:String {
        get {
            return String.fromLIBXMLString(xmlNodeGetContent(self.node) )
        }
        set {
            xmlNodeSetContent(self.node, newValue)
        }
    }
    public var lang:String {
        get {
            return String.fromLIBXMLString(xmlNodeGetLang(self.node) )
        }
        set {
            xmlNodeSetLang(self.node, newValue)
        }
    }
    
    public func next() ->XmlNode {
        return XmlNode(node: self.node.memory.next)
    }
    public func prev() -> XmlNode {
        return XmlNode(node: self.node.memory.prev)
    }
    public func last() -> XmlNode {
        return XmlNode(node: self.node.memory.last)
    }
    
    public func childElementCount() -> UInt {
        return xmlChildElementCount(self.node)
    }
    public func firstElementChild() -> XmlNode {
        return XmlNode(node: xmlFirstElementChild(self.node))
    }
    public func lastElementChild() -> XmlNode {
        return XmlNode(node: xmlLastElementChild(self.node))
    }
    public func lastChlid() ->XmlNode {
        return XmlNode(node: xmlGetLastChild(self.node))
    }
    public func nextElementSibling( node : XmlNode ) -> XmlNode {
        return XmlNode(node: xmlNextElementSibling(node.node))
    }
    public func previousElementSibling( node : XmlNode ) -> XmlNode {
        return XmlNode(node: xmlPreviousElementSibling(node.node))
    }
    
    public func addChild( child : XmlNode ){
        xmlAddChild(self.node,child.node)
    }
}

extension XmlNode : CustomStringConvertible {
    public var description : String {
        get {
            return "name=" + self.name + " elementType=" + self.elementType.description
        }
    }
}

public class XmlDoc {
    private var doc:xmlDocPtr = nil
    public init(doc:xmlDocPtr){
        self.doc = doc
    }
    deinit{
        xmlFree(self.doc)
    }
    public var root: XmlNode {
        get {
            return XmlNode(node: xmlDocGetRootElement(self.doc))
        }
        set {
            xmlDocSetRootElement(self.doc, newValue.node)
        }
    }
}

public class XmlReader {
    class public func read(filepath:String) -> XmlDoc
    {
        return XmlDoc(doc:xmlReadFile(filepath,nil,0))
    }
}

public protocol HasSAX2Handler {
    func OnStartElementNs(context: Any?,
        localname:String,
        prefix: String?,
        uri: String?,
        namespaces:[String],
        attributes:[String:String] )
    func OnEndElementNs(context: Any?, localname: String, prefix: String?, uri: String?)
    func OnCharacters(context: Any?, contents: String)
}

struct XmlSAX2DefaultHandler : HasSAX2Handler {
    func OnStartElementNs(context: Any?,
        localname:String,
        prefix: String?,
        uri: String?,
        namespaces:[String],
        attributes:[String:String] ){
        print("default func called OnStartElementNs: [\(localname)]")
    }
    func OnEndElementNs(context: Any?, localname: String, prefix: String?, uri: String?) {
        print("default func called OnEndElementNs: [\(localname)]")
    }
    func OnCharacters(context: Any?, contents: String){
        print("default func called OnCharacters: [\(contents)]")
    }
}

// global scope...
// !!!要注意!!! thread safe ではないです
private var handler: HasSAX2Handler = XmlSAX2DefaultHandler()

public class XmlSAXParser {
    private var context:xmlParserCtxtPtr = nil
    private var saxHandler:xmlSAXHandler = xmlSAXHandler()
    private var chars   = Array<CChar>(count: Int(BUFSIZ), repeatedValue: 0)
    private var res:Int = 0
    public init(){
        saxHandler.initialized = XML_SAX2_MAGIC
        /*
        void xmlSAX2StartElementNs		(void * ctx,
        const xmlChar * localname,
        const xmlChar * prefix,
        const xmlChar * URI,
        int nb_namespaces,
        const xmlChar ** namespaces,
        int nb_attributes,
        int nb_defaulted,
        const xmlChar ** attributes)
        */
        // closureかクラス外のfuncでしかできないとのエラーのためclosureから呼ぶようにしている
        saxHandler.startElementNs = {(ctx: UnsafeMutablePointer<Void>,
                                      localname:UnsafePointer<xmlChar>,
                                      prefix: UnsafePointer<xmlChar>,
                                      uri: UnsafePointer<xmlChar>,
                                      nb_namespaces:CInt,
                                      namespaces:UnsafeMutablePointer<UnsafePointer<xmlChar>>,
                                      nb_attributes:CInt,
                                      nb_defaulted:CInt,
                                      attributes:UnsafeMutablePointer<UnsafePointer<xmlChar>>) in
            let context:Any? = ctx
            print("closure called OnStartElementNs: [\(String.fromLIBXMLString(localname))]")
            var convertedPrefix:String?
            if prefix != nil {
                print("prefix[\(String.fromLIBXMLString(prefix))]")
                convertedPrefix = String.fromLIBXMLString(prefix)
            }
            var convertedUri:String?
            if uri != nil {
                print("uri[\(String.fromLIBXMLString(uri))]")
                convertedUri = String.fromLIBXMLString(uri)
            }
            var convertedNamespaces:[String] = []
            // これでいいのか不明...
            for namespaceIndex:Int in 0..<Int(nb_namespaces) {
                let namespaceFirstArgIndex:Int = namespaceIndex * 2
                if namespaces[namespaceFirstArgIndex] != nil {
                    print("namespaces[\(namespaceIndex)][0]=[\(String.fromLIBXMLString(namespaces[namespaceFirstArgIndex]))]")
                }
                if namespaces[namespaceFirstArgIndex+1] != nil {
                    print("namespaces[\(namespaceIndex)][1]=[\(String.fromLIBXMLString(namespaces[namespaceFirstArgIndex+1]))]")
                    convertedNamespaces.append(String.fromLIBXMLString(namespaces[namespaceFirstArgIndex+1]))
                }
            }
            var convertedAttributes:[String:String] = [:]
            for attributeIndex:Int in 0..<Int(nb_attributes) {
                // [0]name,[1]?,[2]?,[3]value開始位置,[4]value終了位置
                let attributeNameIndex:Int = attributeIndex * 5
                let attributeValueIndex:Int = attributeNameIndex + 3
                let str = String.fromLIBXMLString(attributes[attributeValueIndex])
                let len = str.characters.count - String.fromLIBXMLString(attributes[attributeValueIndex+1]).characters.count
                let endIndex = str.startIndex.advancedBy(len)
                let attributeValue = str.substringToIndex(endIndex)
                print("attributes[\(attributeIndex)] [\(String.fromLIBXMLString(attributes[attributeNameIndex]))]=[\(attributeValue))]")
                convertedAttributes[String.fromLIBXMLString(attributes[attributeNameIndex])] = attributeValue
            }
            
            handler.OnStartElementNs(context, localname: String.fromLIBXMLString(localname), prefix: convertedPrefix, uri: convertedUri, namespaces: convertedNamespaces, attributes: convertedAttributes)

        }
        /*
        void xmlSAX2EndElementNs		(void * ctx,
        const xmlChar * localname,
        const xmlChar * prefix,
        const xmlChar * URI)
        */
        // closureかクラス外のfuncでしかできないとのエラーのためclosureから呼ぶようにしている
        saxHandler.endElementNs = {(ctx: UnsafeMutablePointer<Void>, localname: UnsafePointer<xmlChar>, prefix: UnsafePointer<xmlChar>, uri: UnsafePointer<xmlChar>) in
            print("closure called OnEndElementNs: [\(String.fromLIBXMLString(localname))]")
            let context:Any? = ctx
            var convertedPrefix:String?
            if prefix != nil {
                print("prefix[\(String.fromLIBXMLString(prefix))]")
                convertedPrefix = String.fromLIBXMLString(prefix)
            }
            var convertedUri:String?
            if uri != nil {
                print("uri[\(String.fromLIBXMLString(uri))]")
                convertedUri = String.fromLIBXMLString(uri)
            }
            handler.OnEndElementNs(context, localname: String.fromLIBXMLString(localname), prefix: convertedPrefix, uri: convertedUri)
        }
        /*
        void xmlSAX2Characters		(void * ctx,
        const xmlChar * ch,
        int len)
        */
        // closureかクラス外のfuncでしかできないとのエラーのためclosureから呼ぶようにしている
        saxHandler.characters = {(ctx: UnsafeMutablePointer<Void>, ch: UnsafePointer<xmlChar>, len: CInt) in
            let context:Any? = ctx
            let str = String.fromLIBXMLString(ch)
            let endIndex = str.startIndex.advancedBy(Int(len))
            print("closure called OnCharacters: [\(str.substringToIndex(endIndex))] len:\(len)")
            handler.OnCharacters(context, contents:str.substringToIndex(endIndex))
        }
    }
    public init(handled : HasSAX2Handler){
        handler = handled
        saxHandler.initialized = XML_SAX2_MAGIC
        /*
        void xmlSAX2StartElementNs		(void * ctx,
        const xmlChar * localname,
        const xmlChar * prefix,
        const xmlChar * URI,
        int nb_namespaces,
        const xmlChar ** namespaces,
        int nb_attributes,
        int nb_defaulted,
        const xmlChar ** attributes)
        */
        // closureかクラス外のfuncでしかできないとのエラーのためclosureから呼ぶようにしている
        saxHandler.startElementNs = {(ctx: UnsafeMutablePointer<Void>,
            localname:UnsafePointer<xmlChar>,
            prefix: UnsafePointer<xmlChar>,
            uri: UnsafePointer<xmlChar>,
            nb_namespaces:CInt,
            namespaces:UnsafeMutablePointer<UnsafePointer<xmlChar>>,
            nb_attributes:CInt,
            nb_defaulted:CInt,
            attributes:UnsafeMutablePointer<UnsafePointer<xmlChar>>) in
            let context:Any? = ctx
            var convertedPrefix:String?
            if prefix != nil {
                convertedPrefix = String.fromLIBXMLString(prefix)
            }
            var convertedUri:String?
            if uri != nil {
                convertedUri = String.fromLIBXMLString(uri)
            }
            var convertedNamespaces:[String] = []
            // これでいいのか不明...
            for namespaceIndex:Int in 0..<Int(nb_namespaces) {
                let namespaceFirstArgIndex:Int = namespaceIndex * 2
//                if namespaces[namespaceFirstArgIndex] != nil {
//                }
                if namespaces[namespaceFirstArgIndex+1] != nil {
                    convertedNamespaces.append(String.fromLIBXMLString(namespaces[namespaceFirstArgIndex+1]))
                }
            }
            var convertedAttributes:[String:String] = [:]
            for attributeIndex:Int in 0..<Int(nb_attributes) {
                // [0]name,[1]?,[2]?,[3]value開始位置,[4]value終了位置
                let attributeNameIndex:Int = attributeIndex * 5
                let attributeValueIndex:Int = attributeNameIndex + 3
                let str = String.fromLIBXMLString(attributes[attributeValueIndex])
                let len = str.characters.count - String.fromLIBXMLString(attributes[attributeValueIndex+1]).characters.count
                let endIndex = str.startIndex.advancedBy(len)
                let attributeValue = str.substringToIndex(endIndex)
                convertedAttributes[String.fromLIBXMLString(attributes[attributeNameIndex])] = attributeValue
            }
            
            handler.OnStartElementNs(context, localname: String.fromLIBXMLString(localname), prefix: convertedPrefix, uri: convertedUri, namespaces: convertedNamespaces, attributes: convertedAttributes)
            
        }
        /*
        void xmlSAX2EndElementNs		(void * ctx,
        const xmlChar * localname,
        const xmlChar * prefix,
        const xmlChar * URI)
        */
        // closureかクラス外のfuncでしかできないとのエラーのためclosureから呼ぶようにしている
        saxHandler.endElementNs = {(ctx: UnsafeMutablePointer<Void>, localname: UnsafePointer<xmlChar>, prefix: UnsafePointer<xmlChar>, uri: UnsafePointer<xmlChar>) in
            let context:Any? = ctx
            var convertedPrefix:String?
            if prefix != nil {
                convertedPrefix = String.fromLIBXMLString(prefix)
            }
            var convertedUri:String?
            if uri != nil {
                convertedUri = String.fromLIBXMLString(uri)
            }
            handler.OnEndElementNs(context, localname: String.fromLIBXMLString(localname), prefix: convertedPrefix, uri: convertedUri)
        }
        /*
        void xmlSAX2Characters		(void * ctx,
        const xmlChar * ch,
        int len)
        */
        // closureかクラス外のfuncでしかできないとのエラーのためclosureから呼ぶようにしている
        saxHandler.characters = {(ctx: UnsafeMutablePointer<Void>, ch: UnsafePointer<xmlChar>, len: CInt) in
            let context:Any? = ctx
            let str = String.fromLIBXMLString(ch)
            let endIndex = str.startIndex.advancedBy(Int(len))
            handler.OnCharacters(context, contents: str.substringToIndex(endIndex))
        }
    }
    deinit{
        if context != nil {
            xmlFreeParserCtxt(context)
            xmlCleanupParser()
        }
    }
    // 参考 : http://www.xmlsoft.org/examples/parse4.c
    public func parse(filepath:String)
    {
        // 参考 : https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html
        guard let desc : UnsafeMutablePointer<FILE> = fopen(filepath, "r") else {
            return
        }
        // 遅延実行 swift 2 から使用できる。スコープを抜けると実行される。
        defer {
            fclose(desc)
        }
        res = fread(&chars, 1, 4, desc)
        if res >= 0 {
            context = xmlCreatePushParserCtxt(&saxHandler, nil, &chars, CInt(res), filepath)
            while feof(desc) == 0 {
                res = fread(&chars, Int(sizeof(CChar)), Int(chars.count), desc)
                if xmlParseChunk(context, chars, CInt(res), CInt(0)) != 0 {
                    break
                }
            }
        }
    }
}

