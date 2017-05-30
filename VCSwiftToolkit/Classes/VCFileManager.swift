//
//  VCFileManager.swift
//  VCSwiftToolkit
//
//  Created by Vitor Cesco on 11/04/17.
//  Copyright © 2017 Vitor Cesco. All rights reserved.
//

import UIKit

public let sharedFileManager : VCFileManager = VCFileManager()

open class VCOperationResult {
    public let success : Bool
    public let error : NSError?
    
    public init(success : Bool, error : NSError?) {
        self.success = success
        self.error = error
    }
}

open class VCFileManager {
    
    public enum ImageFormat: String {
        case PNG = "PNG"
        case JPG = "JPG"
    }
    open let directoryLibrary = NSHomeDirectory().appending("/Library")
    open let directoryDocuments = NSHomeDirectory().appending("/Documents")
    open let directoryBundle = Bundle.main.resourcePath
    
    /**
     * Writes a NSDictionary to the specified directory
     */
    open func writeDictionary(dictionary : NSDictionary, fileName : String, fileExtension : String, directory : String, customFolder : String?, replaceExisting : Bool) {
        
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
    open func writeString(string : String, fileName : String, fileExtension : String, directory : String, customFolder : String?, replaceExisting : Bool) {
        
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
    open func writeArray(array : NSArray, fileName : String, fileExtension : String, directory : String, customFolder : String?, replaceExisting : Bool) {
        
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
    open func writeImage(image : UIImage, imageFormat : ImageFormat, fileName : String, fileExtension : String, directory : String, customFolder : String?, replaceExisting : Bool) {
        
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
    open func readDictionary(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> NSDictionary? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        return NSDictionary(contentsOfFile: filePath)
    }
    
    /**
     * Reads a NSArray from the specified directory
     */
    open func readArray(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> NSArray? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        return NSArray(contentsOfFile: filePath)
    }
    
    /**
     * Reads a String from the specified directory
     */
    open func readString(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> String? {
        
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
    open func readImage(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> UIImage? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        if (FileManager.default.fileExists(atPath: filePath)) {
            if let image = UIImage(contentsOfFile: filePath) {
                
                return image
            }
        }
        return nil
    }
    
    /**
     * Reads a JSON Any from the specified directory
     */
    open func readJSON(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> Any? {
        
        let filePath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: directory, customFolder: customFolder)
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: Data.ReadingOptions.mappedIfSafe)
            
            return data.vcAnyFromJSON()
        }
        catch {
            return nil
        }
    }
    
    
    
    /**
     * Deletes the specified File from the specified directory
     */
    open func deleteFile(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> VCOperationResult {
        
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
     * Deletes the specified directory
     */
    open func deleteDirectory(name : String, directoryPath : String) -> VCOperationResult {
        
        let filePath = directoryPath.appending("/"+name)

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
    open func deleteAllFilesInDirectory(directory : String, customFolder : String) -> VCOperationResult {
        
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
    open func createFolderInDirectory(directory : String, folderName : String) -> VCOperationResult {
        
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
    open func listFilesInDirectory(directory : String, customFolder : String?) -> NSArray {
        
        let fileManager = FileManager.default
        
        let folderPath = self.pathWithMainDirectory(directory: directory, customFolder: customFolder)
        print(folderPath)
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
    open func moveFileNamed(fileName : String, fileExtension : String, fromDirectory : String, fromCustomFolder : String?, toDirectory : String, toCustomFolder : String?) {
        
        let fromPath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: fromDirectory, customFolder: fromCustomFolder)
        
        let destinationPath = self.pathForFile(fileName: fileName, fileExtension: fileExtension, directory: toDirectory, customFolder: toCustomFolder)
        
        _ = self.createFolderInDirectory(directory: toDirectory, folderName: toCustomFolder!)
        
        do {
            try FileManager.default.moveItem(atPath: fromPath, toPath: destinationPath)
        }
        catch {
            print("Could not move file "+fileName)
        }
        
    }
    
    /**
     * Returns the Creation Date for the specified file
     */
    open func creationDateForFileNamed(fileName : String, fileExtension : String, directory : String, customFolder : String?) -> Date? {
        
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
