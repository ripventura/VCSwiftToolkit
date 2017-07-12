//
//  Teste.swift
//  TimeClockBadge
//
//  Created by Vitor Cesco on 11/16/15.
//  Copyright © 2015 Rolfson Oil. All rights reserved.
//

import Foundation

public let sharedLocaleHelper : VCLocaleHelper = VCLocaleHelper()

open class VCLocaleHelper {
    /** Timezone used on all Date operations by this Framework.
     Change this if your application needs to operate in a custom Timezone. */
    private var applicationTimezone : TimeZone
    
    public init() {
        // Starts with the Device's current timezone
        self.applicationTimezone = TimeZone.current
    }
    
    /**
     * Sets the Application Default Timezone
     */
    open func setCurrentTimezone(timezone : TimeZone) {
        //print("Application Timezone: " + timezone.identifier)
        self.applicationTimezone = timezone
    }
    /**
     * Returns the Application Default Timezone
     */
    open func currentTimezone() -> TimeZone {
        return applicationTimezone
    }
    /**
     * Returns the Device Default Timezone
     */
    open func deviceTimezone() -> TimeZone {
        return TimeZone.current
    }
    /**
     * Returns the UTC Timezone
     */
    open func utcTimezone() -> TimeZone {
        return TimeZone(abbreviation: "UTC")!
    }
    
    /** Returns a DateFormatter object, formatted to the device preferred language, rather than the standard Region Format. */
    open func localizedDateFormatter() -> DateFormatter {
        
        let deviceLanguageArray : NSArray = NSLocale.preferredLanguages as NSArray
        
        let deviceLanguage : String = deviceLanguageArray.object(at: 0) as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: deviceLanguage) as Locale!
        
        return dateFormatter
        
    }
}
