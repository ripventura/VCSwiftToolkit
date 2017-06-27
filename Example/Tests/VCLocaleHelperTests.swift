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
    
    override func setUp() {
        super.setUp()

        // Sets the application current timezone to America/Sao_Paulo
        sharedLocaleHelper.setCurrentTimezone(timezone: TimeZone(identifier: currentTimezone)!)
    }
    
    /** VCLocaleTests **/
    func testDeviceTimezone() {
        XCTAssertNotNil(sharedLocaleHelper.deviceTimezone())
    }
    
    func testUTCTimezone() {
        XCTAssertNotNil(sharedLocaleHelper.utcTimezone())
    }
    
    func testLocalizedDateFormatter() {
        XCTAssertNotNil(sharedLocaleHelper.localizedDateFormatter())
    }
    /** VCLocaleTests **/
}
