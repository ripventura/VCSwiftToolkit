//
//  VCSwiftToolkitTests.swift
//  VCSwiftToolkitTests
//
//  Created by Vitor Cesco on 11/04/17.
//  Copyright © 2017 Vitor Cesco. All rights reserved.
//

import XCTest
@testable import VCSwiftToolkit

class VCSwiftToolkitTests: XCTestCase {
    
    func testDegToRad() {
        XCTAssertEqual(String(format: "%.4f", degreesToRadians(1)), "0.0175", "Failed converting Degrees to Radians")
        XCTAssertEqual(String(format: "%.4f", degreesToRadians(90)), "1.5708", "Failed converting Degrees to Radians")
        XCTAssertEqual(String(format: "%.4f", degreesToRadians(180)), "3.1416", "Failed converting Degrees to Radians")
        XCTAssertEqual(String(format: "%.4f", degreesToRadians(270)), "4.7124", "Failed converting Degrees to Radians")
        XCTAssertEqual(String(format: "%.4f", degreesToRadians(360)), "6.2832", "Failed converting Degrees to Radians")
    }
    
    func testRadToDeg() {
        XCTAssertEqual(String(format: "%.4f", radiansToDegrees(1)), "57.2958", "Failed converting Radians to Degrees")
        XCTAssertEqual(String(format: "%.4f", radiansToDegrees(3)), "171.8873", "Failed converting Radians to Degrees")
        XCTAssertEqual(String(format: "%.4f", radiansToDegrees(5)), "286.4789", "Failed converting Radians to Degrees")
        XCTAssertEqual(String(format: "%.4f", radiansToDegrees(7)), "401.0705", "Failed converting Radians to Degrees")
        
    }
    
    func testGetAllAvailableFonts() {
        XCTAssertNotNil(VCToolkit.getAvailableFonts(), "Failed getting all available Fonts")
    }
    
    func testGetAvailableLocales() {
        XCTAssertNotNil(VCToolkit.getAvailabelLocales(), "Failed getting available Locales")
    }
    
    func testanyObjectToJSONData() {
        let nsMutableDict = NSMutableDictionary()
        
        XCTAssertNotNil(VCToolkit.anyObjectToJSONData(object: nsMutableDict as AnyObject), "Failed converting empty NSMutableDictionary to JSON Data")
        
        nsMutableDict.setObject("Test", forKey: "String" as NSCopying)
        nsMutableDict.setObject(Int(123), forKey: "Int" as NSCopying)
        nsMutableDict.setObject(Double(123.45), forKey: "Double" as NSCopying)
        
        XCTAssertNotNil(VCToolkit.anyObjectToJSONData(object: nsMutableDict), "Failed converting NSMutableDictionary to JSON Data")
        
        
        var dict : [String : Any] = [:]
        
        XCTAssertNotNil(VCToolkit.anyObjectToJSONData(object: dict as AnyObject), "Failed converting empty Dictionary to JSON Data")
        
        dict["String"] = "Test"
        dict["Int"] = Int(123)
        dict["Double"] = Double(123.45)
        dict["Dict"] = ["Dict" : ["Array" : ["Test", 123]]]
        
        XCTAssertNotNil(VCToolkit.anyObjectToJSONData(object: dict as AnyObject), "Failed converting Dictionary to JSON Data")
        
        
        var array : [Any] = []
        
        XCTAssertNotNil(VCToolkit.anyObjectToJSONData(object: array as AnyObject), "Failed converting empty Array to JSON Data")
        
        array.append("Test")
        array.append(Int(123))
        array.append(Double(123.45))
        array.append(["Dict" : ["Array" : ["Test", 123]]])
        
        XCTAssertNotNil(VCToolkit.anyObjectToJSONData(object: array as AnyObject), "Failed converting Array to JSON Data")
        
    }
}
