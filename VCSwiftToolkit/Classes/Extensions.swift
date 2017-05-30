//
//  Extensions.swift
//  TimeClockBadge
//
//  Created by Vitor Cesco on 9/23/16.
//  Copyright © 2016 Rolfson Oil. All rights reserved.
//

import UIKit

extension Dictionary {
    /** Appends another dictionary into this one **/
    public mutating func vcAppendDictionary(otherDict : Dictionary) {
        for (key,value) in otherDict {
            self.updateValue(value, forKey:key)
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

extension String {
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
     *  Returns a UIImage of a drawn String, with the given size
     */
    public func vcDrawImage(font : UIFont, color : UIColor, contextSize : CGSize) -> UIImage {
        //Setup the image context using the passed size
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(contextSize, false, scale)
        
        //Sets up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
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
    
    /**
     * Returns the String length
     */
    public var vcLength : Int {
        return self.characters.count
    }
    
}
