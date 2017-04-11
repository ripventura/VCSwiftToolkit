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
        _ = defaultFileManager.createFolderInDirectory(directory: defaultFileManager.directoryLibrary, folderName: testDirName)
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Removes the Test Directory
        _ = defaultFileManager.deleteDirectory(name: testDirName, directoryPath: defaultFileManager.directoryLibrary)
    }
    
    func testStringReadWrite() {
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        XCTAssertNil(defaultFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName), "Failed to read String from test directory")
        
        defaultFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(defaultFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName), fileContent, "Failed to read String from test directory")
    }
    
    func testDictionaryReadWrite() {
        let fileName = "TestDictionaryFile"
        let fileExtension = "plist"
        
        var fileContent : [String : Any] = [:]
        fileContent["String"] = "Test"
        fileContent["Int"] = Int(123)
        fileContent["Double"] = Double(123.45)
        fileContent["Dict"] = ["Dict" : ["Array" : ["Test", 123]]]
        
        XCTAssertNil(defaultFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName), "Failed to read Dictionary from test directory")
        
        defaultFileManager.writeDictionary(dictionary: fileContent as NSDictionary, fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(
            defaultFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName),
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
        
        XCTAssertNil(defaultFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName), "Failed to read Array from test directory")
        
        defaultFileManager.writeArray(array: fileContent as NSArray, fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(
            defaultFileManager.readArray(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName),
            fileContent as NSArray,
            "Failed to read Array from test directory")
    }
    
    func testImageReadWrite() {
        let fileName = "TestImageFile"
        var fileExtension = "JPG"
        
        var fileContent : UIImage = UIImage(named: "TestJPGImage")!
        
        XCTAssertNil(defaultFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName), "Failed to read Image from test directory")
        
        defaultFileManager.writeImage(image: fileContent, imageFormat: VCFileManager.ImageFormat(rawValue: fileExtension)!, fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(
            defaultFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName),
            "Failed to read Image from test directory")
        
        
        fileExtension = "PNG"
        
        fileContent = UIImage(named: "TestPNGImage")!
        
        XCTAssertNil(defaultFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName), "Failed to read Image from test directory")
        
        defaultFileManager.writeImage(image: fileContent, imageFormat: VCFileManager.ImageFormat(rawValue: fileExtension)!, fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(
            defaultFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName),
            "Failed to read Image from test directory")
    }
    
    func testJSONRead() {
        let fileName = "TestJSON"
        let fileExtension = "json"
        
        XCTAssertNotNil(defaultFileManager.readJSON(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryBundle!, customFolder: nil))
    }
    
    func testDirectoryCreationAndDeletion() {
        let tempFolderName = "TempDir"
        
        // Confirms the Directory doesn't exists
        XCTAssertFalse(defaultFileManager.deleteDirectory(name: tempFolderName, directoryPath: defaultFileManager.directoryLibrary).success)
        
        // Creates the Directory
        XCTAssertTrue(defaultFileManager.createFolderInDirectory(directory: defaultFileManager.directoryLibrary, folderName: tempFolderName).success)
        
        // Confirms the Directory exists
        XCTAssertFalse(defaultFileManager.createFolderInDirectory(directory: defaultFileManager.directoryLibrary, folderName: tempFolderName).success)
        
        // Removes the Directory
        XCTAssertTrue(defaultFileManager.deleteDirectory(name: tempFolderName, directoryPath: defaultFileManager.directoryLibrary).success)
        
        // Confirms the Directory doesn't exists
        XCTAssertFalse(defaultFileManager.deleteDirectory(name: tempFolderName, directoryPath: defaultFileManager.directoryLibrary).success)
        
    }
    
    func testCreationDate() {
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        defaultFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(defaultFileManager.creationDateForFileNamed(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: testDirName))
    }
    
    func testMoveFile() {
        let tempFolderName1 = testDirName+"/TempDir1"
        let tempFolderName2 = testDirName+"/TempDir2"
        
        // Creates the First Directory
        XCTAssertTrue(defaultFileManager.createFolderInDirectory(directory: defaultFileManager.directoryLibrary, folderName: tempFolderName1).success)
        
        // Creates the Second Directory
        XCTAssertTrue(defaultFileManager.createFolderInDirectory(directory: defaultFileManager.directoryLibrary, folderName: tempFolderName2).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1).count, 0)
        
        // Verifies the Second Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName2).count, 0)
        
        
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        // Creates the file on the First Directory
        defaultFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1, replaceExisting: true)
        
        
        // Verifies the First Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1).count, 1)
        
        // Verifies the Second Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName2).count, 0)
        
        // Moves the file to the Second Directory
        defaultFileManager.moveFileNamed(fileName: fileName, fileExtension: fileExtension, fromDirectory: defaultFileManager.directoryLibrary, fromCustomFolder: tempFolderName1, toDirectory: defaultFileManager.directoryLibrary, toCustomFolder: tempFolderName2)
        
        // Verifies the First Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1).count, 0)
        
        // Verifies the Second Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName2).count, 1)
        
        // Reads the file content on the Second Directory
        XCTAssertEqual(defaultFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName2), fileContent)
    }
    
    func testDeleteAllFilesInDirectory() {
        let tempFolderName1 = testDirName+"/TempDir1"
        
        // Creates the First Directory
        XCTAssertTrue(defaultFileManager.createFolderInDirectory(directory: defaultFileManager.directoryLibrary, folderName: tempFolderName1).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1).count, 0)
        
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        // Creates the file on the First Directory
        defaultFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1, replaceExisting: true)
        
        // Verifies the First Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1).count, 1)
        
        // Delete all files on the First Directory
        XCTAssertTrue(defaultFileManager.deleteAllFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(defaultFileManager.listFilesInDirectory(directory: defaultFileManager.directoryLibrary, customFolder: tempFolderName1).count, 0)
        
        // Verifies the First Directory still exists
        XCTAssertFalse(defaultFileManager.createFolderInDirectory(directory: defaultFileManager.directoryLibrary, folderName: tempFolderName1).success)
        
    }
    
}
