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

class XmlSchema {
    private var schema:xmlSchemaPtr = nil
    init(){}
    init(path: String){
        let parser = XmlSchemaParser(path:path)
        self.schema = parser.parse()
    }
    deinit{
        if schema != nil {
            xmlSchemaFree(self.schema)
        }
    }
    
    func parse(path: String){
        let parser = XmlSchemaParser(path:path)
        if self.schema != nil {
            xmlSchemaFree(self.schema)
        }
        self.schema = parser.parse()
    }
    
    class XmlSchemaParser {
        private var context:xmlSchemaParserCtxtPtr = nil
        init(path: String) {
            self.context = xmlSchemaNewParserCtxt(path)
        }
        deinit {
            xmlSchemaFreeParserCtxt(self.context)
        }
        func parse()-> xmlSchemaPtr {
            return xmlSchemaParse(self.context)
        }
    }
    
    class XmlSchemaValidater {
        private var context:xmlSchemaValidCtxtPtr = nil
        init(schema:XmlSchema){
            self.context = xmlSchemaNewValidCtxt(schema.schema)
        }
        deinit{
            xmlSchemaFreeValidCtxt(self.context)
        }
        func validate(doc:XmlDoc) -> Bool {
            return xmlSchemaValidateDoc(self.context, doc.doc) == 0
        }
    }
    
    func validate(doc:XmlDoc) -> Bool {
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
class XmlNameSpace {
    private var namesapce: xmlNsPtr = nil
}

class XmlAttribute {
    private var attribute: xmlAttrPtr = nil
    init ( attribute: xmlAttrPtr) {
        self.attribute = attribute
    }
    deinit{
        //        xmlFreeProp(self.attribute)
    }
    var IsNil:Bool {
        get {
            return self.attribute == nil
        }
    }
    var name : String {
        get {
            return String.fromLIBXMLString(attribute.memory.name)
        }
    }
    var value : String {
        get {
            return String.fromLIBXMLString(attribute.memory.children.memory.content)
        }
    }
    var type : xmlAttributeType {
        get {
            return attribute.memory.atype
        }
    }
    func next() -> XmlAttribute {
        return XmlAttribute(attribute: self.attribute.memory.next)
    }
    func prev() -> XmlAttribute {
        return XmlAttribute(attribute: self.attribute.memory.prev)
    }
}

extension XmlAttribute : CustomStringConvertible {
    var description : String {
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

class XmlNode {
    private var node : xmlNodePtr = nil
    
    init( node: xmlNodePtr){
        self.node = node
    }
    // TODO:impliment
    var namespace : XmlNameSpace {
        get {
            return XmlNameSpace()
        }
    }
    var attribute : XmlAttribute {
        get {
            let attr = XmlAttribute(attribute: self.node.memory.properties)
            return attr
        }
    }
    var attributes : [String: String] {
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
    var name : String {
        get {
            return String.fromLIBXMLString(self.node.memory.name)
        }
    }
    var parent : XmlNode {
        get {
            return XmlNode(node: self.node.memory.parent)
        }
    }
    var children : XmlNode {
        get {
            return XmlNode(node: self.node.memory.children)
        }
    }
    
    var elementType:xmlElementType {
        get {
            return self.node.memory.type
        }
    }
    
    var IsNil:Bool {
        get {
            return self.node == nil
        }
    }
    
    var IsBlankNode:Bool {
        get{
            return xmlIsBlankNode(self.node) == 1
        }
    }
    var IsText: Bool {
        get {
            return xmlNodeIsText(self.node) == 1
        }
    }
    var content:String {
        get {
            return String.fromLIBXMLString(xmlNodeGetContent(self.node) )
        }
        set {
            xmlNodeSetContent(self.node, newValue)
        }
    }
    var lang:String {
        get {
            return String.fromLIBXMLString(xmlNodeGetLang(self.node) )
        }
        set {
            xmlNodeSetLang(self.node, newValue)
        }
    }
    
    func next() ->XmlNode {
        return XmlNode(node: self.node.memory.next)
    }
    func prev() -> XmlNode {
        return XmlNode(node: self.node.memory.prev)
    }
    func last() -> XmlNode {
        return XmlNode(node: self.node.memory.last)
    }
    
    func childElementCount() -> UInt {
        return xmlChildElementCount(self.node)
    }
    func firstElementChild() -> XmlNode {
        return XmlNode(node: xmlFirstElementChild(self.node))
    }
    func lastElementChild() -> XmlNode {
        return XmlNode(node: xmlLastElementChild(self.node))
    }
    func lastChlid() ->XmlNode {
        return XmlNode(node: xmlGetLastChild(self.node))
    }
    func nextElementSibling( node : XmlNode ) -> XmlNode {
        return XmlNode(node: xmlNextElementSibling(node.node))
    }
    func previousElementSibling( node : XmlNode ) -> XmlNode {
        return XmlNode(node: xmlPreviousElementSibling(node.node))
    }
    
    func addChild( child : XmlNode ){
        xmlAddChild(self.node,child.node)
    }
}

extension XmlNode : CustomStringConvertible {
    var description : String {
        get {
            return "name=" + self.name + " elementType=" + self.elementType.description
        }
    }
}

class XmlDoc {
    private var doc:xmlDocPtr = nil
    init(doc:xmlDocPtr){
        self.doc = doc
    }
    deinit{
        xmlFree(self.doc)
    }
    var root: XmlNode {
        get {
            return XmlNode(node: xmlDocGetRootElement(self.doc))
        }
        set {
            xmlDocSetRootElement(self.doc, newValue.node)
        }
    }
}

class XmlReader {
    class func read(filepath:String) -> XmlDoc
    {
        return XmlDoc(doc:xmlReadFile(filepath,nil,0))
    }
}

class XmlSAXParser {
    private var context:xmlParserCtxtPtr = nil
    private var saxHandler:xmlSAXHandler = xmlSAXHandler()
    private var chars   = Array<CChar>(count: Int(BUFSIZ), repeatedValue: 0)
    private var res:Int = 0
    init(){
        saxHandler.initialized = XML_SAX2_MAGIC
        // closureかクラス外のfuncでしかできないとのエラーのためclosureからクラス関数を呼ぶようにしている
        saxHandler.startElementNs = {(ctx: UnsafeMutablePointer<Void>,
                                      localname:UnsafePointer<xmlChar>,
                                      prefix: UnsafePointer<xmlChar>,
                                      uri: UnsafePointer<xmlChar>,
                                      nb_namespaces:CInt,
                                      namespaces:UnsafeMutablePointer<UnsafePointer<xmlChar>>,
                                      nb_attributes:CInt,
                                      nb_defaulted:CInt,
                                      attributes:UnsafeMutablePointer<UnsafePointer<xmlChar>>) in
            XmlSAXParser.OnStartElementNs(ctx, localname: localname, prefix: prefix, uri: uri, nb_namespaces: nb_namespaces, namespaces: namespaces, nb_attributes: nb_attributes, nb_defaulted: nb_defaulted, attributes: attributes)
        }
        // closureかクラス外のfuncでしかできないとのエラーのためclosureからクラス関数を呼ぶようにしている
        saxHandler.endElementNs = {(ctx: UnsafeMutablePointer<Void>, localname: UnsafePointer<xmlChar>, prefix: UnsafePointer<xmlChar>, uri: UnsafePointer<xmlChar>) in
            XmlSAXParser.OnEndElementNs(ctx, localname: localname, prefix: prefix, uri: uri)
        }
    }
    deinit{
        if context != nil {
            xmlFreeParserCtxt(context)
        }
    }
    // 参考 : http://www.xmlsoft.org/examples/parse4.c
    func parse(filepath:String)
    {
        let desc : UnsafeMutablePointer<FILE> = fopen(filepath, "r")
        if desc == nil {
            return
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
        fclose(desc)
    }
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
    class func OnStartElementNs(ctx: UnsafeMutablePointer<Void>,
                            localname:UnsafePointer<xmlChar>,
                            prefix: UnsafePointer<xmlChar>,
                            uri: UnsafePointer<xmlChar>,
                            nb_namespaces:CInt,
                            namespaces:UnsafeMutablePointer<UnsafePointer<xmlChar>>,
                            nb_attributes:CInt,
                            nb_defaulted:CInt,
                            attributes:UnsafeMutablePointer<UnsafePointer<xmlChar>> ) {
        print("called OnStartElementNs: [\(String.fromLIBXMLString(localname))]")
        
    }
    /*
    void xmlSAX2EndElementNs		(void * ctx,
                            const xmlChar * localname,
                            const xmlChar * prefix,
                            const xmlChar * URI)
    */
    class func OnEndElementNs(ctx: UnsafeMutablePointer<Void>, localname: UnsafePointer<xmlChar>, prefix: UnsafePointer<xmlChar>, uri: UnsafePointer<xmlChar>) {
        print("called OnEndElementNs: [\(String.fromLIBXMLString(localname))]")
    }
    /*
    void xmlSAX2Characters		(void * ctx,
                            const xmlChar * ch,
                            int len)
    */
    class func OnCharacters(){
        
    }
}

