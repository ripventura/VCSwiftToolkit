//
//  VCSwiftToolkit.swift
//  VCLibrary
//
//  Created by Vitor Cesco on 11/5/15.
//  Copyright © 2015 Vitor Cesco. All rights reserved.
//

import Foundation

let defaultObjectToolkit : VCObjectsToolkit = VCObjectsToolkit()
let defaultFileManager : VCFileManager = VCFileManager()

let radiansToDegrees: (CGFloat) -> CGFloat = {
    return $0 * (180.0 / CGFloat(M_PI))
}

let degreesToRadians: (CGFloat) -> CGFloat = {
    return $0 / 180.0 * CGFloat(M_PI)
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
        
        print(list)
        
        return list
    }
    
    /**
     * Returns the view of the root NavigationController from a specified ViewController
     */
    func getRootNavigationViewFromViewController(viewController: UIViewController) -> UIView {
        
        return viewController.navigationController!.view
    }
    
    /**
     * Allows a UIView sub-class to be loaded from Storyboard when instantiated
     */
    func loadViewFromStoryboard(hostView : UIView, storyBoardName : String) {
        let bundle = Bundle(for: type(of: hostView))
        let nib = UINib(nibName: storyBoardName, bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: hostView, options: nil)[0] as! UIView
        
        // use bounds not frame or it'll be offset
        view.frame = hostView.bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        hostView.addSubview(view)
    }
    
    /**
     * Performs a block of code after a given delay
     */
    func performBlockAfterDelay(delay: TimeInterval, block: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
            block()
        })
    }
    
    /**
     * Converts AnyObject to JSON Data
     * DOES NOT WORK WITH THE FOLLOWING INPUT TYPES:
     * - Dictionary [:]
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


class VCOperationResult {
    let success : Bool
    let error : NSError?
    
    init(success : Bool, error : NSError?) {
        self.success = success
        self.error = error
    }
}

class VCFileManager {
    
    enum ImageFormat: String {
        case PNG = "PNG"
        case JPG = "JPG"
    }
    let directoryLibrary = NSHomeDirectory().appending("/Library")
    let directoryDocuments = NSHomeDirectory().appending("/Documents")
    let directoryBundle = Bundle.main.resourcePath
    
    /**
     * Writes a NSDictionary to the specified directory
     */
    func writeDictionary(dictionary : NSDictionary, fileName : String, fileExtension : String, directory : String, customFolder : String?, replaceExisting : Bool) {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        if replaceExisting {
            dictionary.write(toFile: filePath, atomically: true)
        }
        else {
            if ( self.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)  != nil) {
                dictionary.write(toFile: filePath.replacingOccurrences(of: ".", with: " copy."), atomically: true)
            }
            else {
                dictionary.write(toFile: filePath, atomically: true)
            }
        }
    }
    
    /**
     * Writes a String to the specified directory
     */
    func writeString(string : String, fileName : String, fileExtension : String, directory : String, customFolder : String?, replaceExisting : Bool) {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        if replaceExisting {
            
            do {
                try string.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {
                
            }
            
        }
        else {
            if (self.readString(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder) != nil) {
                
                do {
                    try string.write(toFile: filePath.replacingOccurrences(of: ".", with: " copy."), atomically: true, encoding: String.Encoding.utf8)
                }
                catch {
                    
                }
            }
            else {
                do {
                    try string.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                }
                catch {
                    
                }
            }
        }
    }
    
    /**
     * Writes a NSArray to the specified directory
     */
    func writeArray(array : NSArray, fileName : String, fileExtension : String, directory : String, customFolder : String?, replaceExisting : Bool) {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        if replaceExisting {
            
            array.write(toFile: filePath, atomically: true)
        }
        else {
            if (self.readArray(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder) != nil) {
                
                array.write(toFile: filePath.replacingOccurrences(of: ".", with: " copy."), atomically: true)
            }
            else {
                array.write(toFile: filePath, atomically: true)
            }
        }
    }
    
    /**
     * Writes a UIImage to the specified directory. Supports only PNG and JPG files.
     */
    func writeImage(image : UIImage, imageFormat : ImageFormat, fileName : String, fileExtension : String, directory : String, customFolder : String?, replaceExisting : Bool) {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        var imageData = UIImagePNGRepresentation(image)
        if imageFormat == ImageFormat.JPG {
            imageData = UIImageJPEGRepresentation(image, 1)
        }
        
        if replaceExisting {
            
            do {
                try imageData?.write(to: URL(fileURLWithPath: filePath), options: .atomic)
            } catch {
                print(error)
            }
        }
        else {
            if (self.readImage(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder) != nil) {
                do {
                    try imageData?.write(to: URL(fileURLWithPath: filePath.replacingOccurrences(of: ".", with: " copy.")), options: .atomic)
                } catch {
                    print(error)
                }
            }
            else {
                do {
                    try imageData?.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
    /**
     * Reads a NSDictionary from the specified directory
     */
    func readDictionary(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> NSDictionary? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        return NSDictionary(contentsOfFile: filePath)
    }
    
    /**
     * Reads a NSArray from the specified directory
     */
    func readArray(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> NSArray? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        return NSArray(contentsOfFile: filePath)
    }
    
    /**
     * Reads a String from the specified directory
     */
    func readString(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> String? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        do {
            let string = try String(contentsOfFile: filePath, encoding: String.Encoding.ascii)
            
            return string
        }
        catch {
            return nil
        }
    }
    
    /**
     * Reads a UIImage from the specified directory
     */
    func readImage(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> UIImage? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        if (FileManager.default.fileExists(atPath: filePath)) {
            if let image = UIImage(contentsOfFile: filePath) {
                
                return image
            }
        }
        return nil
    }
    
    
    
    /**
     * Deletes the specified File from the specified directory
     */
    func deleteFile(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> VCOperationResult {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        do {
            try FileManager.default.removeItem(atPath: filePath)
            return VCOperationResult(success: true, error: nil)
        }
        catch let error as NSError {
            return VCOperationResult(success: false, error: error)
        }
    }
    
    /**
     * Deletes All Files from the specified directory
     */
    func deleteAllFilesInDirectory(directory : String, customFolder : String) -> VCOperationResult {
        
        let folderPath = self.pathWithMainDirectory(directory: directory, customFolder: customFolder)
        
        do {
            if FileManager.default.fileExists(atPath: folderPath) {
                
                try FileManager.default.removeItem(atPath: folderPath)
                
                return self.createFolderInDirectory(directory: directory, folderName: customFolder)
            }
        }
        catch let error as NSError {
            return VCOperationResult(success: false, error: error)
        }
        return VCOperationResult(success: true, error: nil)
    }
    
    
    /**
     * Creates a Folder in the specified directory (does not override an existing folder with the same name on the same path)
     */
    func createFolderInDirectory(directory : String, folderName : String) -> VCOperationResult {
        
        let folderPath = self.pathWithMainDirectory(directory: directory, customFolder: folderName)
        
        do {
            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: nil)
            
            return VCOperationResult(success: true, error: nil)
        }
        catch let error as NSError {
            return VCOperationResult(success: false, error: error)
        }
    }
    
    /**
     * Lists All Files within the specified directory
     */
    func listFilesInDirectory(directory : String, customFolder : String?) -> NSArray {
        
        let fileManager = FileManager.default
        
        let folderPath = self.pathWithMainDirectory(directory: directory, customFolder: customFolder)
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folderPath)
            
            return contents as NSArray
        }
        catch {
            return NSArray()
        }
    }
    
    /**
     * Moves the specified File from the original directory to a new directory
     */
    func moveFileNamed(fileName : String, fileExtension : String, fromDirectory : String, fromCustomFolder : String?, toDirectory : String, toCustomFolder : String?) {
        
        let fromPath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: fromDirectory, customFolder: fromCustomFolder)
        
        let destinationPath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: toDirectory, customFolder: toCustomFolder)
        
        self.createFolderInDirectory(directory: toDirectory, folderName: toCustomFolder!)
        
        do {
            try FileManager.default.copyItem(atPath: fromPath, toPath: destinationPath)
        }
        catch {
            print("Could not move file "+fileName)
        }
        
    }
    
    /**
     * Returns the Creation Date for the specified file
     */
    func creationDateForFileNamed(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> Date? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: filePath) as Dictionary
            
            if attributes.count > 0 {
                return attributes[FileAttributeKey.creationDate] as? Date
            }
            else {
                print("Could not load file "+filePath)
            }
        }
        catch {
            print("Could not load file "+filePath)
        }
        
        return nil
    }
    
    
    private func getDictionariesFromFiles(directory : String, customFolder : String?) -> NSArray {
        
        let fileList = self.listFilesInDirectory(directory: directory, customFolder: customFolder)
        
        let array = NSMutableArray()
        
        for fileName in fileList {
            
            array.add(self.readDictionary(fileName: fileName as! String, fileExtension: "", directory: directory, customFolder: customFolder)!)
        }
        
        return array
        
    }
    
    private func pathForFile(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> String {
        
        var filePath = directory
        
        if customFolder != nil {
            filePath = filePath.appending("/"+customFolder!)
        }
        
        filePath = filePath.appending("/"+fileName)
        
        if fileExtension.characters.count > 0 {
            filePath = filePath.appending("."+fileExtension)
        }
        
        return filePath
    }
    
    private func pathWithMainDirectory(directory : String, customFolder : String?) -> String {
        
        var filePath = directory
        
        if customFolder != nil {
            filePath = filePath.appending("/"+customFolder!)
        }
        
        return filePath
    }
}
