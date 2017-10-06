//
//  Extensions.swift
//  TimeClockBadge
//
//  Created by Vitor Cesco on 9/23/16.
//  Copyright © 2016 Rolfson Oil. All rights reserved.
//

import UIKit
import QRCode

extension Dictionary {
    /** Appends another dictionary into this one */
    public mutating func vcAppendDictionary(otherDict : Dictionary) {
        for (key,value) in otherDict {
            self.updateValue(value, forKey:key)
        }
    }
    
    /** Returns a JSON String (pretty printed) from this Dictionary */
    public func vcJSONString(encoding: String.Encoding = String.Encoding.utf8) -> String? {
        if let data = VCToolkit.anyObjectToJSONData(object: self as AnyObject) {
            return String(data: data, encoding: encoding)
        } else {
            return nil
        }
    }
}

extension Data {
    /**
     * Converts JSON Data to an appropriated object based on the content (Dctionary, Array etc)
     */
    public func vcAnyFromJSON() -> Any? {
        
        do {
            let jsonObject : Any = try JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.allowFragments)
            
            return jsonObject
        }
        catch {
            return nil
        }
    }
}

extension NSMutableData {
    /**
     * Converts JSON Data to an appropriated object based on the content (Dctionary, Array etc)
     */
    public func vcAnyFromJSON() -> Any? {
        
        do {
            let jsonObject : Any = try JSONSerialization.jsonObject(with: self as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            
            return jsonObject
        }
        catch {
            return nil
        }
    }
}

extension UIImage {
    /**
     *  Converts a UIImage to base64 String
     */
    public func vcBase64String() -> String? {
        var imageRep = UIImagePNGRepresentation(self)
        
        if imageRep == nil {
            imageRep = UIImagePNGRepresentation(self.vcImageBasedOnImage())
        }
        
        if let string = imageRep?.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithCarriageReturn) {
            return string
        }
        
        return nil
    }
    
    /**
     *  Draws a UIImage based on the given UIImage (used on cases where the original UIImage cannot be converted to Data)
     */
    public func vcImageBasedOnImage() -> UIImage {
        let destinationSize = self.size
        UIGraphicsBeginImageContext(destinationSize)
        self.draw(in: CGRect(x: 0, y: 0, width: destinationSize.width, height: destinationSize.height))
        let finalImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    /**
     *  Scales a UIImage to the desired CGSize
     */
    public func vcScaleToNewSize(newSize : CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return scaledImage!
        
    }
    
    /**
     *  Rotates and/or Flips a UIImage to the desired degrees
     */
    public func vcRotateFlipByAngle(degrees : CGFloat, flip : Bool = false) -> UIImage {
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: self.size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        bitmap!.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /**
     *  Clips rounded corners on a UIImage (might experience performance drawbacks)
     */
    public func vcRoundCorners(cornerRadius : CGFloat) -> UIImage {
        
        let originalImage = self
        
        UIGraphicsBeginImageContextWithOptions(originalImage.size, false, 0.0)
        
        UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: 0), size: originalImage.size), cornerRadius: cornerRadius).addClip()
        
        originalImage.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: originalImage.size))
        
        let clippedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return clippedImage!
        
    }
}

extension UIColor {
    /** Returns the CIColor equivalent of this UIColor */
    var vcCIColor: CIColor {
        return CIColor(color: self)
    }
    
    /** Returns the RGB Components of this UIColor */
    var vcRGBComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = self.vcCIColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}

extension String {
    /** Returns whether this String contains antoher String, with options CaseInsensitve and DiacriticOption */
    public func vcContains(otherString: String) -> Bool {
        return self.lowercased().range(of: otherString.lowercased(), options: String.CompareOptions.diacriticInsensitive) != nil
    }
    
    /**
     *  Converts a String to base64 String
     */
    public func vcBase64String() -> String? {
        
        return self.data(using: String.Encoding.unicode)!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    /**
     *  Converts a base64 String to String
     */
    public func vcStringFromBase64String() -> String? {
        let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0))
        
        return data != nil ? String(data: data! as Data, encoding: String.Encoding.unicode) : nil
    }
    
    /**
     *  Converts a base64 String to UIImage
     */
    public func vcImageFromBase64String() -> UIImage? {
        
        let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        
        return UIImage(data: data! as Data)
    }
    
    /**
     * Returns a QRCode image from a String, with the given Size and Color
     */
    public func vcQRCode(size: CGSize, color: UIColor = .black, backgroundColor: UIColor = .white) -> UIImage? {
        var qrCode = QRCode(self)
        qrCode?.size = size
        qrCode?.color = color.vcCIColor
        qrCode?.backgroundColor = backgroundColor.vcCIColor
        
        return qrCode?.image
    }
    
    /**
     *  Returns a UIImage of a drawn String, with the given size
     */
    public func vcDrawImage(font : UIFont, color : UIColor, contextSize : CGSize) -> UIImage {
        //Setup the image context using the passed size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(contextSize, false, scale)
        
        //Sets up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: color,
            ]
        
        //Now Draw the text into an image
        self.draw(in: CGRect(x: 0, y: 0, width: contextSize.width, height: contextSize.height), withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
    }
    
    /** Returns a Date from a formatted String for the specified Timezone */
    public func vcDateWithFormat(dateFormat : String, timezoneName : String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: timezoneName)
        
        return dateFormatter.date(from: self)
    }
    
    /** Returns a Date from a formatted String for the current Timezone */
    public func vcDateWithFormatForCurrentTimezone(dateFormat : String) -> Date? {
        return self.vcDateWithFormat(dateFormat: dateFormat, timezoneName: sharedLocaleHelper.currentTimezone().identifier)
    }
    
    /** Returns a Date from a String for the UTC Timezone and specified Format */
    public func vcDateWithFormatForUTCTimezone(dateFormat : String) -> Date? {
        return self.vcDateWithFormat(dateFormat: dateFormat, timezoneName: sharedLocaleHelper.utcTimezone().identifier)
    }
}

extension Date {
    public enum DateFormat: String {
        
        /** 2015-09-06T07:59:59.000Z */
        case DateTimeISO8601IN = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        /** 2015-09-06T07:59:59Z */
        case DateTimeISO8601OUT = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        /** 2015-09-06 07:59:59 */
        case DateTimeISO = "yyyy-MM-dd HH:mm:ss"
        /** 2015-09-06 07-59-59 */
        case DateTimeISODashed = "yyyy-MM-dd HH-mm-ss"
        /** 09-06-2015 07:59:59 */
        case DateTimeISOMonthDayYear = "MM-dd-yyyy HH:mm:ss"
        /** 06-09-2015 07:59:59 */
        case DateTimeISODayMonthYear = "dd-MM-yyyy HH:mm:ss"
        
        /** 09/06 07:59 AM */
        case DateLongTime12LongAMPMFormat = "MM/dd hh:mm a"
        /** 9/6 07:59 AM */
        case DateShortTime12LongAMPMFormat = "M/d hh:mm a"
        /** 09/06 7:59 AM */
        case DateLongTime12ShortAMPMFormat = "MM/dd h:mm a"
        /** 9/6 7:59 AM */
        case DateShortTime12ShortAMPMFormat = "M/d h:mm a"
        
        /** Wed 06, 09:00 AM */
        case WeekdayShortDayLongTime12LongAMPMFormat = "EEE dd, hh:mm a"
        /** Wed 06, 9:00 AM */
        case WeekdayShortDayLongTime12ShortAMPMFormat = "EEE dd, h:mm a"
        /** Wed 6, 09:00 AM */
        case WeekdayShortDayShortTime12LongAMPMFormat = "EEE d, hh:mm a"
        /** Wed 6, 9:00 AM */
        case WeekdayShortDayShortTime12ShortAMPMFormat = "EEE d, h:mm a"
        /** Wednesday 06 */
        case WeekdayLongDayLongFormat = "EEEE dd"
        /** Wednesday 6 */
        case WeekdayLongDayShortFormat = "EEEE d"
        /** Wednesday, 4/6 */
        case WeekdayLongDateShortFormat = "EEEE, M/d"
        /** Wed, 4/6 */
        case WeekdayShortDateShortFormat = "EEE, M/d"
        /** Wed, 06 Apr 2015 */
        case WeekdayShortDayShortMonthNameShortYearLongFormat = "EEE, dd MMM yyyy"
        
        /** 2015-09-06 */
        case DateISO = "yyyy-MM-dd"
        
        /** 09/06 */
        case DateLongFormat = "MM/dd"
        /** 9/6 */
        case DateShortFormat = "M/d"
        
        /** 09/06/2015 */
        case DateYearLongFormat = "MM/dd/yyyy"
        /** 9/6/15 */
        case DateYearShortFormat = "M/d/yy"
        
        /** 09 */
        case MonthLongFormat = "MM"
        /** 9 */
        case MonthShortFormat = "M"
        /** September */
        case MonthNameLongFormat = "MMMM"
        /** Sep */
        case MonthNameShortFormat = "MMM"
        
        /** 2015 */
        case YearLongFormat = "yyyy"
        /** 15 */
        case YearShortFormat = "yy"
        
        /** 09 */
        case DayLongFormat = "dd"
        /** 9 */
        case DayShortFormat = "d"
        
        /** Sep 06 */
        case MonthNameShortDayLongFormat = "MMM dd"
        /** Sep 6 */
        case MonthNameShortDayShortFormat = "MMM d"
        
        /** Sep 6, 2016 */
        case MonthNameShortDayShortYearLongFormat = "MMM d, yyyy"
        
        /** Sep, 2016 */
        case MonthNameShortYearLongFormat = "MMM, yyyy"
        /** September, 2016 */
        case MonthNameLongYearLongFormat = "MMMM, yyyy"
        
        /** 07:59:59 */
        case TimeISO = "HH:mm:ss"
        
        /** 07:59 AM */
        case Time12LongAMPMFormat = "hh:mm a"
        /** 7:59 AM */
        case Time12ShortAMPMFormat = "h:mm a"
        
        /** 07:59 */
        case Time24LongFormat = "HH:mm"
        /** 7:59 */
        case Time24ShortFormat = "H:m"
        
        /** 07 */
        case TimeHour12LongFormat = "hh"
        /** 7 */
        case TimeHour12ShortFormat = "h"
        
        /** 07 */
        case TimeHour24LongFormat = "HH"
        /** 7 */
        case TimeHour24ShortFormat = "H"
        
        /** 08 */
        case TimeMinuteLongFormat = "mm"
        /** 8 */
        case TimeMinuteShortFormat = "m"
        
        /** 09 */
        case TimeSecondsLongFormat = "ss"
        /** 9 */
        case TimeSecondsShortFormat = "s"
    }
    
    /** Returns a formatted String with the specified Timezone and Format */
    public func vcStringWithFormat(dateFormat : String, timezoneName : String) -> String {
        
        let dateFormatter = sharedLocaleHelper.localizedDateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: timezoneName)
        
        return dateFormatter.string(from: self)
    }
    
    /** Returns a formatted String for the Current Timezone and specified Format */
    public func vcStringWithFormatForCurrentTimezone(dateFormat : String) -> String {
        
        return self.vcStringWithFormat(dateFormat: dateFormat, timezoneName: sharedLocaleHelper.currentTimezone().identifier)
    }
    
    /** Returns a String from a Date for the UTC Timezone and specified Format */
    public func vcStringWithFormatForUTCTimezone(dateFormat : String) -> String {
        
        return self.vcStringWithFormat(dateFormat: dateFormat, timezoneName: sharedLocaleHelper.utcTimezone().identifier)
    }
    
    /** Returns the readable interval between 2 dates */
    public func vcReadableIntervalBetweenDates(otherDate: Date,
                                               locale: ReadableIntervalLocaleProtocol = EnUSReadableIntervalLocale(),
                                               includeAddon: Bool = true) -> String {
        let interval = self.timeIntervalSince(otherDate)
        var diff : TimeInterval = interval
        if diff < 0 {
            diff *= -1
        }
        
        var string = ""
        
        // Less than 1 minute (still seconds)
        if diff < 59 {
            return locale.justNow
        }
        // Less than 1 hour (still minutes)
        else if diff <= 3599 {
            let minutes = String(format: "%.0f", diff/60)
            
            if Int(minutes)! > 1 {
                string = locale.about + " " + minutes + " " + locale.minutes
            }
            else {
                string = locale.about + " 1 " + locale.minute
            }
            
        }
        // Less than 1 day (still hours)
        else if diff <= 86399 {
            let hours = String(format: "%.0f", diff/60/60)
            
            if Int(hours)! > 1 {
                string = locale.about + " " + hours + " " + locale.hours
            }
            else {
                string = locale.about + " 1 " + locale.hour
            }
        }
        // Days
        else {
            let days = String(format: "%.0f", diff/60/60/24)
            
            if Int(days)! > 1 {
                string = locale.about + " " + days + " " + locale.days
            }
            else {
                string = locale.about + " 1 " + locale.day
            }
        }
        
        if includeAddon {
            if interval < 0 {
                string = string + " " + locale.pastAddon
            }
            else {
                string =  locale.futureAddon + " " + string
            }
        }
        
        return string
    }
    
    /** Sets this Date's Year */
    public mutating func vcSetYear(year : Int, referenceTimezone : TimeZone = sharedLocaleHelper.currentTimezone()) {
        
        var dateString = String(format: "%d", year)
        dateString = dateString + "-" + self.vcStringWithFormat(dateFormat: Date.DateFormat.MonthLongFormat.rawValue,
                                                                timezoneName: referenceTimezone.identifier)
        dateString = dateString + "-" + self.vcStringWithFormat(dateFormat: Date.DateFormat.DayLongFormat.rawValue,
                                                                timezoneName: referenceTimezone.identifier)
        dateString = dateString + " " + self.vcStringWithFormat(dateFormat: Date.DateFormat.TimeISO.rawValue,
                                                                timezoneName: referenceTimezone.identifier)
        
        self = dateString.vcDateWithFormat(dateFormat: Date.DateFormat.DateTimeISO.rawValue,
                                           timezoneName: referenceTimezone.identifier)!
    }
    
    /** Sets this Date's Month */
    public mutating func vcSetMonth(month : Int, referenceTimezone : TimeZone = sharedLocaleHelper.currentTimezone()) {
        
        var dateString = self.vcStringWithFormat(dateFormat: Date.DateFormat.YearLongFormat.rawValue,
                                                 timezoneName: referenceTimezone.identifier)
        dateString = dateString + "-" + String(format: "%d", month)
        dateString = dateString + "-" + self.vcStringWithFormat(dateFormat: Date.DateFormat.DayLongFormat.rawValue,
                                                                timezoneName: referenceTimezone.identifier)
        dateString = dateString + " " + self.vcStringWithFormat(dateFormat: Date.DateFormat.TimeISO.rawValue,
                                                                timezoneName: referenceTimezone.identifier)
        
        self = dateString.vcDateWithFormat(dateFormat: Date.DateFormat.DateTimeISO.rawValue,
                                           timezoneName: referenceTimezone.identifier)!
    }
    
    /** Sets this Date's Day */
    public mutating func vcSetDay(day : Int, referenceTimezone : TimeZone = sharedLocaleHelper.currentTimezone()) {
        
        var dateString = self.vcStringWithFormat(dateFormat: Date.DateFormat.YearLongFormat.rawValue,
                                                 timezoneName: referenceTimezone.identifier)
        dateString = dateString + "-" + self.vcStringWithFormat(dateFormat: Date.DateFormat.MonthLongFormat.rawValue,
                                                                timezoneName: referenceTimezone.identifier)
        dateString = dateString + "-" + String(format: "%d", day)
        dateString = dateString + " " + self.vcStringWithFormat(dateFormat: Date.DateFormat.TimeISO.rawValue,
                                                                timezoneName: referenceTimezone.identifier)
        
        self = dateString.vcDateWithFormat(dateFormat: Date.DateFormat.DateTimeISO.rawValue,
                                           timezoneName: referenceTimezone.identifier)!
    }
    
    /** Sets the Time of the given Date.
     As all Date objects are UTC when computed, the referenceTimezone is used to compensate the offset on the seconds field */
    public mutating func vcSetTime(hour : Int, minute : Int, second : Int, referenceTimezone : TimeZone = sharedLocaleHelper.currentTimezone()) {
        
        var dateString = self.vcStringWithFormat(dateFormat: Date.DateFormat.DateISO.rawValue, timezoneName: referenceTimezone.identifier)
        dateString = dateString + " " + String(format: "%d", hour)
        dateString = dateString + ":" + String(format: "%d", minute)
        dateString = dateString + ":" + String(format: "%d", second)
        
        self = dateString.vcDateWithFormat(dateFormat: Date.DateFormat.DateTimeISO.rawValue,
                                           timezoneName: referenceTimezone.identifier)!
    }
    
    /** Adds or Removes Hours / Minutes / Seconds */
    public mutating func vcOperateTime(hour : Int, minute : Int, second : Int) {
        
        self = Calendar.current.date(byAdding: Calendar.Component.hour, value: hour, to: self)!
        self = Calendar.current.date(byAdding: Calendar.Component.minute, value: minute, to: self)!
        self = Calendar.current.date(byAdding: Calendar.Component.second, value: second, to: self)!
    }
    
    /** Adds or Removes Days */
    public mutating func vcOperateDays(days : Int) {
        
        self = Calendar.current.date(byAdding: Calendar.Component.day, value: days, to: self)!
    }
    
    /** Adds or Removes Weeks */
    public mutating func vcOperateWeeks(weeks : Int) {
        
        self = Calendar.current.date(byAdding: Calendar.Component.weekOfYear, value: weeks, to: self)!
    }
    
    /** Adds or Removes Months */
    public mutating func vcOperateMonths(months : Int) {
        
        self = Calendar.current.date(byAdding: Calendar.Component.month, value: months, to: self)!
    }
    
    /** Adds or Removes Years */
    public mutating func vcOperateYears(years : Int) {
        
        self = Calendar.current.date(byAdding: Calendar.Component.year, value: years, to: self)!
    }
    
    /** True if the given Date is in between the other two Dates.
     Also lets you choos if equal dates ( >= || <= ) should be considered (default is true). */
    public func vcIsInBetween(startDate : Date, endDate : Date, includeEquals : Bool = true) -> Bool {
        
        if includeEquals {
            return self.timeIntervalSince(startDate as Date) >= 0 && self.timeIntervalSince(endDate as Date) <= 0
        }
        else {
            return self.timeIntervalSince(startDate as Date) > 0 && self.timeIntervalSince(endDate as Date) < 0
        }
    }
}

