//
//  ExtensionsTest.swift
//  VCSwiftToolkit
//
//  Created by Vitor Cesco on 11/04/17.
//  Copyright © 2017 Vitor Cesco. All rights reserved.
//

import XCTest
@testable import VCSwiftToolkit

class ExtensionsTest: XCTestCase {
    
    /** Dictionary Tests **/
    func testAppendDictionary() {
        var dict : [String : Any] = ["String":"Test", "Int":Int(123)]
        
        XCTAssertEqual(dict as NSDictionary, ["String":"Test", "Int":Int(123)] as NSDictionary)
        
        dict.vcAppendDictionary(otherDict: ["Double":Double(123.45)])
        
        XCTAssertEqual(dict as NSDictionary, ["String":"Test", "Int":Int(123), "Double":Double(123.45)] as NSDictionary)
    }
    /** Dictionary Tests **/
    
    /** Data Tests **/
    func testAnyFromJSON() {
        
        let fileName = "TestJSON"
        let fileExtension = "json"
        
        XCTAssertNotNil(defaultFileManager.readJSON(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryBundle!, customFolder: nil))
    }
    /** Data Tests **/
    
    /** UIImage Tests **/
    func testBase64StringFromImage() {
        XCTAssertNotNil(UIImage(named: "TestPNGImage"))
        XCTAssertNotNil(UIImage(named: "TestPNGImage")?.vcBase64String())
    }
    func testImageBasedOnImage() {
        XCTAssertNotNil(UIImage(named: "TestPNGImage"))
        XCTAssertNotNil(UIImage(named: "TestPNGImage")?.vcImageBasedOnImage())
    }
    func testScaleToNewSize() {
        var image = UIImage(named: "TestPNGImage")
        XCTAssertNotNil(image)
        
        image = image?.vcScaleToNewSize(newSize: CGSize(width: 33, height: 33))
        
        XCTAssertNotNil(image)
        XCTAssertEqual(image?.size, CGSize(width: 33, height: 33))
    }
    func testRotateFlip() {
        let image = UIImage(named: "TestPNGImage")
        XCTAssertNotNil(image)
        
        let rotatedImage = image?.vcRotateFlipByAngle(degrees: 90, flip: true)
        XCTAssertNotNil(rotatedImage)
        
        XCTAssertNotEqual(rotatedImage?.size, image?.size)
    }
    func testRoundedCorners() {
        XCTAssertNotNil(UIImage(named: "TestPNGImage"))
        XCTAssertNotNil(UIImage(named: "TestPNGImage")?.vcRoundCorners(cornerRadius: 8))
    }
    /** UIImage Tests **/
    
    /** String Tests **/
    func testBase64String() {
        let testString = "Test"
        XCTAssertNotNil(testString)
        XCTAssertNotNil(testString.vcBase64String())
    }
    func testStringFromBase64String() {
        let testString = "Test"
        XCTAssertNotNil(testString)
        
        let base64String = testString.vcBase64String()
        XCTAssertNotNil(base64String)
        
        XCTAssertEqual(base64String?.vcStringFromBase64String(), testString)
    }
    func testImageFromBase64String() {
        let image = UIImage(named: "TestPNGImage")!
        
        XCTAssertNotNil(image)
        
        let base64String = image.vcBase64String()
        
        XCTAssertNotNil(base64String)
        
        XCTAssertEqual(base64String?.vcImageFromBase64String()?.size, image.size)
    }
    func testDrawImage() {
        let testString = "Test"
        
        XCTAssertNotNil(testString)
        
        XCTAssertNotNil(testString.vcDrawImage(font: UIFont.systemFont(ofSize: 10), color: .black, contextSize: CGSize(width: 100, height: 100)))
    }
    func testLenght() {
        XCTAssertNotNil("Test".vcLenght)
        XCTAssertEqual("Test".vcLenght, 4)
    }
    /** String Tests **/
}
