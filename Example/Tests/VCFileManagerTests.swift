//
//  VCFileManagerTests.swift
//  VCSwiftToolkit
//
//  Created by Vitor Cesco on 11/04/17.
//  Copyright © 2017 Vitor Cesco. All rights reserved.
//

import XCTest
@testable import VCSwiftToolkit

class VCFileManagerTests: XCTestCase {
    let testDirName = "TestDir"
    
    override func setUp() {
        super.setUp()
        
        // Creates the Test Directory
        _ = sharedFileManager.createFolderInDirectory(directory: sharedFileManager.directoryLibrary, folderName: testDirName)
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Removes the Test Directory
        _ = sharedFileManager.deleteDirectory(name: testDirName, directoryPath: sharedFileManager.directoryLibrary)
    }
    
    func testStringReadWrite() {
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        XCTAssertNil(sharedFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName), "Failed to read String from test directory")
        
        sharedFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(sharedFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName), fileContent, "Failed to read String from test directory")
    }
    
    func testDictionaryReadWrite() {
        let fileName = "TestDictionaryFile"
        let fileExtension = "plist"
        
        var fileContent : [String : Any] = [:]
        fileContent["String"] = "Test"
        fileContent["Int"] = Int(123)
        fileContent["Double"] = Double(123.45)
        fileContent["Dict"] = ["Dict" : ["Array" : ["Test", 123]]]
        
        XCTAssertNil(sharedFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName), "Failed to read Dictionary from test directory")
        
        sharedFileManager.writeDictionary(dictionary: fileContent as NSDictionary, fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(
            sharedFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName),
            fileContent as NSDictionary,
            "Failed to read Dictionary from test directory")
    }
    
    func testArrayReadWrite() {
        let fileName = "TestArrayFile"
        let fileExtension = "txt"
        
        var fileContent : [Any] = []
        fileContent.append("Test")
        fileContent.append(Int(123))
        fileContent.append(Double(123.45))
        fileContent.append(["Dict" : ["Array" : ["Test", 123]]])
        
        XCTAssertNil(sharedFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName), "Failed to read Array from test directory")
        
        sharedFileManager.writeArray(array: fileContent as NSArray, fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(
            sharedFileManager.readArray(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName),
            fileContent as NSArray,
            "Failed to read Array from test directory")
    }
    
    func testImageReadWrite() {
        let fileName = "TestImageFile"
        var fileExtension = "JPG"
        
        var fileContent : UIImage = UIImage(named: "TestJPGImage")!
        
        XCTAssertNil(sharedFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName), "Failed to read Image from test directory")
        
        sharedFileManager.writeImage(image: fileContent, imageFormat: VCFileManager.ImageFormat(rawValue: fileExtension)!, fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(
            sharedFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName),
            "Failed to read Image from test directory")
        
        
        fileExtension = "PNG"
        
        fileContent = UIImage(named: "TestPNGImage")!
        
        XCTAssertNil(sharedFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName), "Failed to read Image from test directory")
        
        sharedFileManager.writeImage(image: fileContent, imageFormat: VCFileManager.ImageFormat(rawValue: fileExtension)!, fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(
            sharedFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName),
            "Failed to read Image from test directory")
    }
    
    func testJSONRead() {
        let fileName = "TestJSON"
        let fileExtension = "json"
        
        XCTAssertNotNil(sharedFileManager.readJSON(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryBundle!, customFolder: nil))
    }
    
    func testDirectoryCreationAndDeletion() {
        let tempFolderName = "TempDir"
        
        // Confirms the Directory doesn't exists
        XCTAssertFalse(sharedFileManager.deleteDirectory(name: tempFolderName, directoryPath: sharedFileManager.directoryLibrary).success)
        
        // Creates the Directory
        XCTAssertTrue(sharedFileManager.createFolderInDirectory(directory: sharedFileManager.directoryLibrary, folderName: tempFolderName).success)
        
        // Confirms the Directory exists
        XCTAssertFalse(sharedFileManager.createFolderInDirectory(directory: sharedFileManager.directoryLibrary, folderName: tempFolderName).success)
        
        // Removes the Directory
        XCTAssertTrue(sharedFileManager.deleteDirectory(name: tempFolderName, directoryPath: sharedFileManager.directoryLibrary).success)
        
        // Confirms the Directory doesn't exists
        XCTAssertFalse(sharedFileManager.deleteDirectory(name: tempFolderName, directoryPath: sharedFileManager.directoryLibrary).success)
        
    }
    
    func testCreationDate() {
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        sharedFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(sharedFileManager.creationDateForFileNamed(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: testDirName))
    }
    
    func testMoveFile() {
        let tempFolderName1 = testDirName+"/TempDir1"
        let tempFolderName2 = testDirName+"/TempDir2"
        
        // Creates the First Directory
        XCTAssertTrue(sharedFileManager.createFolderInDirectory(directory: sharedFileManager.directoryLibrary, folderName: tempFolderName1).success)
        
        // Creates the Second Directory
        XCTAssertTrue(sharedFileManager.createFolderInDirectory(directory: sharedFileManager.directoryLibrary, folderName: tempFolderName2).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1).count, 0)
        
        // Verifies the Second Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName2).count, 0)
        
        
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        // Creates the file on the First Directory
        sharedFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1, replaceExisting: true)
        
        
        // Verifies the First Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1).count, 1)
        
        // Verifies the Second Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName2).count, 0)
        
        // Moves the file to the Second Directory
        sharedFileManager.moveFileNamed(fileName: fileName, fileExtension: fileExtension, fromDirectory: sharedFileManager.directoryLibrary, fromCustomFolder: tempFolderName1, toDirectory: sharedFileManager.directoryLibrary, toCustomFolder: tempFolderName2)
        
        // Verifies the First Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1).count, 0)
        
        // Verifies the Second Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName2).count, 1)
        
        // Reads the file content on the Second Directory
        XCTAssertEqual(sharedFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName2), fileContent)
    }
    
    func testDeleteAllFilesInDirectory() {
        let tempFolderName1 = testDirName+"/TempDir1"
        
        // Creates the First Directory
        XCTAssertTrue(sharedFileManager.createFolderInDirectory(directory: sharedFileManager.directoryLibrary, folderName: tempFolderName1).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1).count, 0)
        
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        // Creates the file on the First Directory
        sharedFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1, replaceExisting: true)
        
        // Verifies the First Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1).count, 1)
        
        // Delete all files on the First Directory
        XCTAssertTrue(sharedFileManager.deleteAllFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(sharedFileManager.listFilesInDirectory(directory: sharedFileManager.directoryLibrary, customFolder: tempFolderName1).count, 0)
        
        // Verifies the First Directory still exists
        XCTAssertFalse(sharedFileManager.createFolderInDirectory(directory: sharedFileManager.directoryLibrary, folderName: tempFolderName1).success)
        
    }
    
}
