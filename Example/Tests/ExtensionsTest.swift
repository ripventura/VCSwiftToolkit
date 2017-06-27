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
    
    func testJSONStringFromDictionary() {
        let dict : [String : Any] = ["String":"Test", "Int":Int(123), "dict":["foo":"bar"]]
        
        XCTAssertNotNil(dict.vcJSONString())
    }
    /** Dictionary Tests **/
    
    /** Data Tests **/
    func testAnyFromJSON() {
        
        let fileName = "TestJSON"
        let fileExtension = "json"
        
        XCTAssertNotNil(sharedFileManager.readJSON(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryBundle!, customFolder: nil))
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
    let testString : String = "2015-09-06 07:59:59"
    
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
    func testStringFromDate() {
        XCTAssertEqual(testDate.vcStringWithFormatForCurrentTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2015-09-06 04:59:59")
        XCTAssertEqual(testDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), testString)
        XCTAssertEqual(testDate.vcStringWithFormat(dateFormat: Date.DateFormat.DateTimeISO.rawValue, timezoneName: testTimezone), "2015-09-06 03:59:59")
    }
    /** String Tests **/
    
    /** Date Tests **/
    let currentTimezone : String = "America/Sao_Paulo"
    let testTimezone : String = "America/New_York"
    var testDate : Date = "2015-09-06 07:59:59".vcDateWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue)!
    
    func testDateFromString() {
        let currentTimezoneDate = testString.vcDateWithFormatForCurrentTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue)
        let testTimezoneDate = testString.vcDateWithFormat(dateFormat: Date.DateFormat.DateTimeISO.rawValue, timezoneName: testTimezone)
        let utcTimezoneDate = testString.vcDateWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue)
        
        XCTAssertNotNil(currentTimezoneDate)
        XCTAssertNotNil(testTimezoneDate)
        XCTAssertNotNil(utcTimezoneDate)
        
        XCTAssertEqual(utcTimezoneDate?.timeIntervalSince(currentTimezoneDate!), -10800)
        XCTAssertEqual(currentTimezoneDate?.timeIntervalSince(testTimezoneDate!), -3600)
    }
    
    func testSetYearForDate() {
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        var newDate = testDate
        newDate.vcSetYear(year: 2017, referenceTimezone: sharedLocaleHelper.utcTimezone())
        
        XCTAssertNotNil(newDate)
        
        XCTAssertEqual(newDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2017-09-06 07:59:59")
    }
    
    func testSetMonthForDate() {
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        var newDate = testDate
        newDate.vcSetMonth(month: 04, referenceTimezone: sharedLocaleHelper.utcTimezone())
        
        XCTAssertNotNil(newDate)
        
        XCTAssertEqual(newDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2015-04-06 07:59:59")
    }
    
    func testSetDayForDate() {
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        var newDate = testDate
        newDate.vcSetDay(day: 22, referenceTimezone: sharedLocaleHelper.utcTimezone())
        
        XCTAssertNotNil(newDate)
        
        XCTAssertEqual(newDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2015-09-22 07:59:59")
        
        
        let tempDate = "2015-01-10 00:00:00".vcDateWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue)
        
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        var newTempDate = tempDate
        newTempDate?.vcSetDay(day: 01, referenceTimezone: sharedLocaleHelper.utcTimezone())
        
        XCTAssertEqual(newTempDate?.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2015-01-01 00:00:00")
    }
    
    func testSetTimeForDate() {
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        var newDate = testDate
        newDate.vcSetTime(hour: 00, minute: 11, second: 22, referenceTimezone: sharedLocaleHelper.utcTimezone())
        
        XCTAssertNotNil(newDate)
        
        XCTAssertEqual(newDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2015-09-06 00:11:22")
    }
    
    func testOperateTimeToDate() {
        var newDate = testDate
        newDate.vcOperateTime(hour: -2, minute: -5, second: 10)
        
        XCTAssertEqual(newDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2015-09-06 05:55:09")
    }
    
    func testOperateDaysToDate() {
        var newDate = testDate
        newDate.vcOperateDays(days: 12)
        
        XCTAssertEqual(newDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2015-09-18 07:59:59")
    }
    
    func testOperateMonthsToDate() {
        var newDate = testDate
        newDate.vcOperateMonths(months: -1)
        
        XCTAssertEqual(newDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2015-08-06 07:59:59")
    }
    
    func testOperateYearsToDate() {
        var newDate = testDate
        newDate.vcOperateYears(years: 10)
        
        XCTAssertEqual(newDate.vcStringWithFormatForUTCTimezone(dateFormat: Date.DateFormat.DateTimeISO.rawValue), "2025-09-06 07:59:59")
    }
    
    func testIsDateInBetween() {
        var pastDate = testDate
        var futureDate = testDate
        
        // pastDate = testDate = futureDate
        XCTAssertTrue(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = pastDate.addingTimeInterval(-10)
        
        // pastDate < testDate = futureDate
        XCTAssertTrue(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = testDate
        futureDate = futureDate.addingTimeInterval(10)
        
        // pastDate = testDate < futureDate
        XCTAssertTrue(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = pastDate.addingTimeInterval(-10)
        
        // pastDate < testDate < futureDate
        XCTAssertTrue(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertTrue(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = testDate.addingTimeInterval(10)
        futureDate = testDate.addingTimeInterval(20)
        
        // testDate < pastDate < futureDate
        XCTAssertFalse(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = testDate.addingTimeInterval(-20)
        futureDate = testDate.addingTimeInterval(-10)
        
        // pastDate < futureDate < testDate
        XCTAssertFalse(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(testDate.vcIsInBetween(startDate: pastDate, endDate: futureDate, includeEquals: false))
    }
    /** Date Tests **/
}
