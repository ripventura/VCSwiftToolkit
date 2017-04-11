//
//  VCDateHandlerTests.swift
//  VCSwiftToolkit
//
//  Created by Vitor Cesco on 11/04/17.
//  Copyright © 2017 Vitor Cesco. All rights reserved.
//

import XCTest
@testable import VCSwiftToolkit

class VCDateHandlerTests: XCTestCase {
    let currentTimezone : String = "America/Sao_Paulo"
    let testTimezone : String = "America/New_York"
    let testString : String = "2015-09-06 07:59:59"
    var testDate : Date = defaultDateHandler.dateFromStringForUTCTimezone(string: "2015-09-06 07:59:59", dateFormat: .DateTimeISO)!
    
    override func setUp() {
        super.setUp()

        // Sets the application current timezone to America/Sao_Paulo
        defaultLocaleHelper.setCurrentTimezone(timezone: TimeZone(identifier: currentTimezone)!)
    }
    
    /** VCLocaleTests **/
    func testDeviceTimezone() {
        XCTAssertNotNil(defaultLocaleHelper.deviceTimezone())
    }
    
    func testUTCTimezone() {
        XCTAssertNotNil(defaultLocaleHelper.utcTimezone())
    }
    
    func testLocalizedDateFormatter() {
        XCTAssertNotNil(defaultLocaleHelper.localizedDateFormatter())
    }
    /** VCLocaleTests **/
    
    
    /** VCDateHandlerTests **/
    func testStringFromDate() {
        XCTAssertEqual(defaultDateHandler.stringFromDateForCurrentTimezone(date: testDate, dateFormat: .DateTimeISO), "2015-09-06 04:59:59")
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: testDate, dateFormat: .DateTimeISO), "2015-09-06 07:59:59")
        XCTAssertEqual(defaultDateHandler.stringFromDate(date: testDate, dateFormat: .DateTimeISO, timezoneName: testTimezone), "2015-09-06 03:59:59")
    }
    
    func testDateFromString() {
        let currentTimezoneDate = defaultDateHandler.dateFromStringForCurrentTimezone(string: testString, dateFormat: .DateTimeISO)
        let testTimezoneDate = defaultDateHandler.dateFromString(string: testString, dateFormat: .DateTimeISO, timezoneName: testTimezone)
        let utcTimezoneDate = defaultDateHandler.dateFromStringForUTCTimezone(string: testString, dateFormat: .DateTimeISO)
        
        XCTAssertNotNil(currentTimezoneDate)
        XCTAssertNotNil(testTimezoneDate)
        XCTAssertNotNil(utcTimezoneDate)
        
        XCTAssertEqual(utcTimezoneDate?.timeIntervalSince(currentTimezoneDate!), -10800)
        XCTAssertEqual(currentTimezoneDate?.timeIntervalSince(testTimezoneDate!), -3600)
    }
    
    func testSetYearForDate() {
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        let newDate = defaultDateHandler.setYearForDate(date: testDate, year: 2017, referenceTimezone: defaultLocaleHelper.utcTimezone())
        
        XCTAssertNotNil(newDate)
        
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newDate, dateFormat: .DateTimeISO), "2017-09-06 07:59:59")
    }
    
    func testSetMonthForDate() {
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        let newDate = defaultDateHandler.setMonthForDate(date: testDate, month: 04, referenceTimezone: defaultLocaleHelper.utcTimezone())
        
        XCTAssertNotNil(newDate)
        
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newDate, dateFormat: .DateTimeISO), "2015-04-06 07:59:59")
    }
    
    func testSetDayForDate() {
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        let newDate = defaultDateHandler.setDayForDate(date: testDate, day: 22, referenceTimezone: defaultLocaleHelper.utcTimezone())
        
        XCTAssertNotNil(newDate)
        
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newDate, dateFormat: .DateTimeISO), "2015-09-22 07:59:59")
        
        
        let tempDate = defaultDateHandler.dateFromStringForUTCTimezone(string: "2015-01-10 00:00:00", dateFormat: .DateTimeISO)!
        
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        let newTempDate = defaultDateHandler.setDayForDate(date: tempDate, day: 01, referenceTimezone: defaultLocaleHelper.utcTimezone())
        
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newTempDate, dateFormat: .DateTimeISO), "2015-01-01 00:00:00")
    }
    
    func testSetTimeForDate() {
        // We pass the referenceTimezone to calculate the time using UTC Timezone (which is the Timezone used on our TestDate). If nil, the application currentTimezone will be used instead.
        let newDate = defaultDateHandler.setTimeForDate(date: testDate, hour: 00, minute: 11, second: 22, referenceTimezone: defaultLocaleHelper.utcTimezone())
        
        XCTAssertNotNil(newDate)
        
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newDate, dateFormat: .DateTimeISO), "2015-09-06 00:11:22")
    }
    
    func testOperateTimeToDate() {
        let newDate = defaultDateHandler.operateTimeToDate(date: testDate, hour: -2, minute: -5, second: 10)
        
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newDate, dateFormat: .DateTimeISO), "2015-09-06 05:55:09")
    }
    
    func testOperateDaysToDate() {
        let newDate = defaultDateHandler.operateDaysToDate(date: testDate, days: 12)
        
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newDate, dateFormat: .DateTimeISO), "2015-09-18 07:59:59")
    }
    
    func testOperateMonthsToDate() {
        let newDate = defaultDateHandler.operateMonthsToDate(date: testDate, months: -1)
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newDate, dateFormat: .DateTimeISO), "2015-08-06 07:59:59")
    }

    func testOperateYearsToDate() {
        let newDate = defaultDateHandler.operateYearsToDate(date: testDate, years: 10)
        XCTAssertEqual(defaultDateHandler.stringFromDateForUTCTimezone(date: newDate, dateFormat: .DateTimeISO), "2025-09-06 07:59:59")
    }
    
    func testIsDateInBetween() {
        var pastDate = testDate
        var futureDate = testDate
        
        XCTAssertTrue(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = pastDate.addingTimeInterval(-10)
        
        XCTAssertTrue(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = testDate
        futureDate = futureDate.addingTimeInterval(10)
        
        XCTAssertTrue(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = pastDate.addingTimeInterval(-10)
        
        XCTAssertTrue(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertTrue(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = testDate.addingTimeInterval(10)
        futureDate = testDate.addingTimeInterval(20)
        
        XCTAssertFalse(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: false))
        
        pastDate = testDate.addingTimeInterval(-20)
        futureDate = testDate.addingTimeInterval(-10)
        
        XCTAssertFalse(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: true))
        XCTAssertFalse(defaultDateHandler.isDateInBetween(date: testDate, startDate: pastDate, endDate: futureDate, includeEquals: false))
    }
    /** VCDateHandlerTests **/
}
