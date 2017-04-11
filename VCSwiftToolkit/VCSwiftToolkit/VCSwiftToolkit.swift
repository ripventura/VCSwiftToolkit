//
//  VCSwiftToolkit.swift
//  VCLibrary
//
//  Created by Vitor Cesco on 11/5/15.
//  Copyright © 2015 Vitor Cesco. All rights reserved.
//

import UIKit

let defaultObjectToolkit : VCObjectsToolkit = VCObjectsToolkit()
let defaultFileManager : VCFileManager = VCFileManager()

let radiansToDegrees: (CGFloat) -> CGFloat = {
    return $0 * (180.0 / CGFloat(Double.pi))
}

let degreesToRadians: (CGFloat) -> CGFloat = {
    return $0 / 180.0 * CGFloat(Double.pi)
}

class VCObjectsToolkit {
    /* Another way of creating the Singleton
     static let sharedInstance = VCObjectsToolkit()
     private init() {}
     */
    
    /**
     * Returns all the Font Families and Names available in this project
     */
    func getAvailableFonts() -> [String : [String]] {
        var resultArray : [String : [String]] = [:]
        
        for family: String in UIFont.familyNames
        {
            var currentFamilyFonts : [String] = []
            //print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                //print("== \(names)")
                currentFamilyFonts.append(names)
            }
            resultArray[family] = currentFamilyFonts
        }
        return resultArray
    }
    
    /**
     * Returns all the Locales available
     */
    func getAvailabelLocales() -> [(identifier : String, name : String)] {
        let identifiers : [String] = NSLocale.availableLocaleIdentifiers
        let locale = NSLocale(localeIdentifier: "en_US")
        var list : [(identifier : String, name : String)] = []
        
        for identifier in identifiers {
            let name = locale.displayName(forKey: NSLocale.Key.identifier, value: identifier)!
            list.append((identifier, name))
        }
        
        //print(list)
        
        return list
    }
    
    /**
     * Returns the view of the root NavigationController from a specified ViewController
     */
    func getRootNavigationViewFromViewController(viewController: UIViewController) -> UIView? {
        
        return viewController.navigationController?.view
    }
    
    /**
     * Performs a block of code on the main thread after a given delay
     */
    func performBlockAfterDelay(delay: TimeInterval, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
            block()
        })
    }
    
    /**
     * Converts AnyObject to JSON Data
     */
    func convertAnyObjectToJSONData(object : AnyObject) -> Data? {
        
        do {
            let jsonObject = try JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            return jsonObject
        }
        catch {
            return nil
        }
    }
}
