//
//  Teste.swift
//  TimeClockBadge
//
//  Created by Vitor Cesco on 11/16/15.
//  Copyright © 2015 Rolfson Oil. All rights reserved.
//

import Foundation

let defaultDateHandler : VCDateHandler = VCDateHandler()

let defaultLocaleHelper : VCLocaleHelper = VCLocaleHelper()


class VCLocaleHelper {
    /** Timezone used on all Date operations by VCDateHandler.
      * Change this if your application needs to operate in a custom Timezone.  **/
    private var applicationTimezone : TimeZone
    
    init() {
        // Starts with the Device's current timezone
        self.applicationTimezone = TimeZone.current
    }
    
    /**
     * Sets the Application Default Timezone
     */
    func setCurrentTimezone(timezone : TimeZone) {
        //print("Application Timezone: " + timezone.identifier)
        self.applicationTimezone = timezone
    }
    /**
     * Returns the Application Default Timezone
     */
    func currentTimezone() -> TimeZone {
        return applicationTimezone
    }
    /**
     * Returns the Device Default Timezone
     */
    func deviceTimezone() -> TimeZone {
        return TimeZone.current
    }
    /**
     * Returns the UTC Timezone
     */
    func utcTimezone() -> TimeZone {
        return TimeZone(abbreviation: "UTC")!
    }
    
    /**
     * Returns a DateFormatter object, formatted to the device preferred language, rather than the standard Region Format
     */
    func localizedDateFormatter() -> DateFormatter {
        
        let deviceLanguageArray : NSArray = NSLocale.preferredLanguages as NSArray
        
        let deviceLanguage : String = deviceLanguageArray.object(at: 0) as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: deviceLanguage) as Locale!
        
        return dateFormatter
        
    }
}

class VCDateHandler {
    
    enum DateFormat: String {
        
        /** 2015-09-06T07:59:59.000Z **/
        case DateTimeISO8601IN = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        /** 2015-09-06T07:59:59Z **/
        case DateTimeISO8601OUT = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        /** 2015-09-06 07:59:59 **/
        case DateTimeISO = "yyyy-MM-dd HH:mm:ss"
        /** 2015-09-06 07-59-59 **/
        case DateTimeISODashed = "yyyy-MM-dd HH-mm-ss"
        /** 09-06-2015 07:59:59 **/
        case DateTimeISOMonthDayYear = "MM-dd-yyyy HH:mm:ss"
        /** 06-09-2015 07:59:59 **/
        case DateTimeISODayMonthYear = "dd-MM-yyyy HH:mm:ss"
        
        /** 09/06 07:59 AM **/
        case DateLongTime12LongAMPMFormat = "MM/dd hh:mm a"
        /** 9/6 07:59 AM **/
        case DateShortTime12LongAMPMFormat = "M/d hh:mm a"
        /** 09/06 7:59 AM **/
        case DateLongTime12ShortAMPMFormat = "MM/dd h:mm a"
        /** 9/6 7:59 AM **/
        case DateShortTime12ShortAMPMFormat = "M/d h:mm a"
        
        /** Wed 06, 09:00 AM **/
        case WeekdayShortDayLongTime12LongAMPMFormat = "EEE dd, hh:mm a"
        /** Wed 06, 9:00 AM **/
        case WeekdayShortDayLongTime12ShortAMPMFormat = "EEE dd, h:mm a"
        /** Wed 6, 09:00 AM **/
        case WeekdayShortDayShortTime12LongAMPMFormat = "EEE d, hh:mm a"
        /** Wed 6, 9:00 AM **/
        case WeekdayShortDayShortTime12ShortAMPMFormat = "EEE d, h:mm a"
        /** Wednesday 06 **/
        case WeekdayLongDayLongFormat = "EEEE dd"
        /** Wednesday 6 **/
        case WeekdayLongDayShortFormat = "EEEE d"
        /** Wednesday, 4/6 **/
        case WeekdayLongDateShortFormat = "EEEE, M/d"
        /** Wed, 4/6 **/
        case WeekdayShortDateShortFormat = "EEE, M/d"
        
        /** 2015-09-06 **/
        case DateISO = "yyyy-MM-dd"
        
        /** 09/06 **/
        case DateLongFormat = "MM/dd"
        /** 9/6 **/
        case DateShortFormat = "M/d"
        
        /** 09 **/
        case MonthLongFormat = "MM"
        /** 9 **/
        case MonthShortFormat = "M"
        /** September **/
        case MonthNameLongFormat = "MMMM"
        /** Sep **/
        case MonthNameShortFormat = "MMM"
        
        /** 2015 **/
        case YearLongFormat = "yyyy"
        /** 15 **/
        case YearShortFormat = "yy"
        
        /** 09 **/
        case DayLongFormat = "dd"
        /** 9 **/
        case DayShortFormat = "d"
        
        /** Sep 06 **/
        case MonthNameShortDayLongFormat = "MMM dd"
        /** Sep 6 **/
        case MonthNameShortDayShortFormat = "MMM d"
        
        /** Sep 6, 2016 **/
        case MonthNameShortDayShortYearLongFormat = "MMM d, yyyy"
        
        /** Sep, 2016 **/
        case MonthNameShortYearLongFormat = "MMM, yyyy"
        /** September, 2016 **/
        case MonthNameLongYearLongFormat = "MMMM, yyyy"
        
        /** 07:59:59 **/
        case TimeISO = "HH:mm:ss"
        
        /** 07 **/
        case TimeHour12LongFormat = "hh"
        /** 7 **/
        case TimeHour12ShortFormat = "h"
        
        /** 07 **/
        case TimeHour24LongFormat = "HH"
        /** 7 **/
        case TimeHour24ShortFormat = "H"
        
        /** 08 **/
        case TimeMinuteLongFormat = "mm"
        /** 8 **/
        case TimeMinuteShortFormat = "m"
        
        /** 09 **/
        case TimeSecondsLongFormat = "ss"
        /** 9 **/
        case TimeSecondsShortFormat = "s"
        
        /** 07:59 AM **/
        case Time12LongAMPMFormat = "hh:mm a"
        /** 7:59 AM **/
        case Time12ShortAMPMFormat = "h:mm a"
    }
    
    
    
    /**
     * Returns a String from a Date with the specified Timezone and Format
     */
    func stringFromDate(date : Date, dateFormat : DateFormat, timezoneName : String) -> String {
        
        let dateFormatter = defaultLocaleHelper.localizedDateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.timeZone = TimeZone(identifier: timezoneName)
        
        return dateFormatter.string(from: date as Date)
    }
    /**
     * Returns a NSString from a Date for the Current Timezone and specified Format
     */
    func stringFromDateForCurrentTimezone(date : Date, dateFormat : DateFormat) -> String {
        
        return self.stringFromDate(date: date, dateFormat: dateFormat, timezoneName: defaultLocaleHelper.currentTimezone().identifier)
    }
    /**
     * Returns a NSString from a Date for the UTC Timezone and specified Format
     */
    func stringFromDateForUTCTimezone(date : Date, dateFormat : DateFormat) -> String {
        
        return self.stringFromDate(date: date, dateFormat: dateFormat, timezoneName: defaultLocaleHelper.utcTimezone().identifier)
    }
    
    
    /**
     * Returns a Date from a String with the specified Timezone and Format
     */
    func dateFromString(string : String, dateFormat : DateFormat, timezoneName : String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        dateFormatter.timeZone = TimeZone(identifier: timezoneName)
        
        return dateFormatter.date(from: string)
    }
    /**
     * Returns a Date from a String for the Current Timezone and specified Format
     */
    func dateFromStringForCurrentTimezone(string : String, dateFormat : DateFormat) -> Date? {
        
        return self.dateFromString(string: string, dateFormat: dateFormat, timezoneName: defaultLocaleHelper.currentTimezone().identifier)
    }
    /**
     * Returns a Date from a String for the UTC Timezone and specified Format
     */
    func dateFromStringForUTCTimezone(string : String, dateFormat : DateFormat) -> Date? {
        
        return self.dateFromString(string: string, dateFormat: dateFormat, timezoneName: defaultLocaleHelper.utcTimezone().identifier)
    }
    
    
    /**
     * Returns the readable interval between 2 dates
     */
    func readableIntervalBetweenDates (interval : TimeInterval) -> String {
        var diff : TimeInterval = interval
        if diff < 0 {
            diff *= -1
        }
        
        var string = ""
        
        if diff < 59 {
            string = "less than 1 minute"
        }
        else if diff <= 3599 {
            let minutes = String(format: "%.0f", diff/60)
            
            if Int(minutes)! > 1 {
                string = "about " + minutes + " minutes"
            }
            else {
                string = "about 1 minute"
            }
            
        }
        else {
            let hours = String(format: "%.0f", diff/60/60)
            
            if Int(hours)! > 1 {
                string = "about " + hours + " hours"
            }
            else {
                string = "about 1 hour"
            }
        }
        
        
        if interval < 0 {
            return string + " ago"
        }
        else {
            return "in " + string
        }
    }
    
    
    /**
     * Sets the Year of the given Date
     */
    func setYearForDate(date : Date, year : Int, referenceTimezone : TimeZone = defaultLocaleHelper.currentTimezone()) -> Date {
        
        var dateString = String(format: "%d", year)
        dateString = dateString + "-" + self.stringFromDate(date: date, dateFormat: .MonthLongFormat, timezoneName: referenceTimezone.identifier)
        dateString = dateString + "-" + self.stringFromDate(date: date, dateFormat: .DayLongFormat, timezoneName: referenceTimezone.identifier)
        dateString = dateString + " " + self.stringFromDate(date: date, dateFormat: .TimeISO, timezoneName: referenceTimezone.identifier)
        
        return defaultDateHandler.dateFromString(string: dateString, dateFormat: .DateTimeISO, timezoneName: referenceTimezone.identifier)!
    }
    /**
     * Sets the Month of the given Date
     */
    func setMonthForDate(date : Date, month : Int, referenceTimezone : TimeZone = defaultLocaleHelper.currentTimezone()) -> Date {
        
        var dateString = self.stringFromDate(date: date, dateFormat: .YearLongFormat, timezoneName: referenceTimezone.identifier)
        dateString = dateString + "-" + String(format: "%d", month)
        dateString = dateString + "-" + self.stringFromDate(date: date, dateFormat: .DayLongFormat, timezoneName: referenceTimezone.identifier)
        dateString = dateString + " " + self.stringFromDate(date: date, dateFormat: .TimeISO, timezoneName: referenceTimezone.identifier)
        
        return defaultDateHandler.dateFromString(string: dateString, dateFormat: .DateTimeISO, timezoneName: referenceTimezone.identifier)!
    }
    /**
     * Sets the Day of the given Date
     */
    func setDayForDate(date : Date, day : Int, referenceTimezone : TimeZone = defaultLocaleHelper.currentTimezone()) -> Date {
        
        var dateString = self.stringFromDate(date: date, dateFormat: .YearLongFormat, timezoneName: referenceTimezone.identifier)
        dateString = dateString + "-" + self.stringFromDate(date: date, dateFormat: .MonthLongFormat, timezoneName: referenceTimezone.identifier)
        dateString = dateString + "-" + String(format: "%d", day)
        dateString = dateString + " " + self.stringFromDate(date: date, dateFormat: .TimeISO, timezoneName: referenceTimezone.identifier)
        
        return defaultDateHandler.dateFromString(string: dateString, dateFormat: .DateTimeISO, timezoneName: referenceTimezone.identifier)!
    }
    /**
     * Sets the Time of the given Date.
     * As all Date objects are UTC when computed, the referenceTimezone is used to compensate the offset on the seconds field
     */
    func setTimeForDate(date : Date, hour : Int, minute : Int, second : Int, referenceTimezone : TimeZone = defaultLocaleHelper.currentTimezone()) -> Date {
        
        var dateString = self.stringFromDate(date: date, dateFormat: .DateISO, timezoneName: referenceTimezone.identifier)
        dateString = dateString + " " + String(format: "%d", hour)
        dateString = dateString + ":" + String(format: "%d", minute)
        dateString = dateString + ":" + String(format: "%d", second)
        
        return defaultDateHandler.dateFromString(string: dateString, dateFormat: .DateTimeISO, timezoneName: referenceTimezone.identifier)!
    }
    
    
    
    /**
     * Adds or Removes Hours / Minutes / Seconds to the given Date
     */
    func operateTimeToDate(date : Date, hour : Int, minute : Int, second : Int) -> Date {
        
        var finalDate = date
        finalDate = Calendar.current.date(byAdding: Calendar.Component.hour, value: hour, to: finalDate)!
        finalDate = Calendar.current.date(byAdding: Calendar.Component.minute, value: minute, to: finalDate)!
        finalDate = Calendar.current.date(byAdding: Calendar.Component.second, value: second, to: finalDate)!
        
        return finalDate
    }
    /**
     * Adds or Removes Days to the given Date
     */
    func operateDaysToDate(date : Date, days : Int) -> Date {
        
        return Calendar.current.date(byAdding: Calendar.Component.day, value: days, to: date)!
    }
    /**
     * Adds or Removes Weeks to the given Date
     */
    func operateWeeksToDate(date : Date, weeks : Int) -> Date {
        
        return Calendar.current.date(byAdding: Calendar.Component.weekOfYear, value: weeks, to: date)!
    }
    /**
     * Adds or Removes Months to the given Date
     */
    func operateMonthsToDate(date : Date, months : Int) -> Date {
        
        return Calendar.current.date(byAdding: Calendar.Component.month, value: months, to: date)!
    }
    /**
     * Adds or Removes Years to the given Date
     */
    func operateYearsToDate(date : Date, years : Int) -> Date {
        
        return Calendar.current.date(byAdding: Calendar.Component.year, value: years, to: date)!
    }
    
    
    /**
     * True if the given Date is in between the other two Dates. Also lets you choos if equal dates ( >= || <= ) should be considered (default is true).
     */
    func isDateInBetween(date : Date, startDate : Date, endDate : Date, includeEquals : Bool = true) -> Bool {
        
        if includeEquals {
            return date.timeIntervalSince(startDate as Date) >= 0 && date.timeIntervalSince(endDate as Date) <= 0
        }
        else {
            return date.timeIntervalSince(startDate as Date) > 0 && date.timeIntervalSince(endDate as Date) < 0
        }
    }
}
