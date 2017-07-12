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
        _ = VCFileManager.createFolderInDirectory(directory: VCFileManager.Directory.library, folderName: testDirName)
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Removes the Test Directory
        _ = VCFileManager.deleteDirectory(directory: .library, customFolder: testDirName)
    }
    
    func testStringReadWrite() {
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        XCTAssertNil(VCFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName), "Failed to read String from test directory")
        
        VCFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(VCFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName), fileContent, "Failed to read String from test directory")
    }
    
    func testDictionaryReadWrite() {
        let fileName = "TestDictionaryFile"
        let fileExtension = "plist"
        
        var fileContent : [String : Any] = [:]
        fileContent["String"] = "Test"
        fileContent["Int"] = Int(123)
        fileContent["Double"] = Double(123.45)
        fileContent["Dict"] = ["Dict" : ["Array" : ["Test", 123]]]
        
        XCTAssertNil(VCFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName), "Failed to read Dictionary from test directory")
        
        VCFileManager.writeDictionary(dictionary: fileContent as NSDictionary, fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(
            VCFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName),
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
        
        XCTAssertNil(VCFileManager.readDictionary(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName), "Failed to read Array from test directory")
        
        VCFileManager.writeArray(array: fileContent as NSArray, fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertEqual(
            VCFileManager.readArray(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName),
            fileContent as NSArray,
            "Failed to read Array from test directory")
    }
    
    func testImageReadWrite() {
        let fileName = "TestImageFile"
        var fileExtension = "JPG"
        
        var fileContent : UIImage = UIImage(named: "TestJPGImage")!
        
        XCTAssertNil(VCFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName), "Failed to read Image from test directory")
        
        VCFileManager.writeImage(image: fileContent, imageFormat: VCFileManager.ImageFormat(rawValue: fileExtension)!, fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(
            VCFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName),
            "Failed to read Image from test directory")
        
        
        fileExtension = "PNG"
        
        fileContent = UIImage(named: "TestPNGImage")!
        
        XCTAssertNil(VCFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName), "Failed to read Image from test directory")
        
        VCFileManager.writeImage(image: fileContent, imageFormat: VCFileManager.ImageFormat(rawValue: fileExtension)!, fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(
            VCFileManager.readImage(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName),
            "Failed to read Image from test directory")
    }
    
    func testJSONRead() {
        let fileName = "TestJSON"
        let fileExtension = "json"
        
        XCTAssertNotNil(VCFileManager.readJSON(fileName: fileName, fileExtension: fileExtension, directory: .bundle, customFolder: nil))
    }
    
    func testDirectoryCreationAndDeletion() {
        let tempFolderName = "TempDir"
        
        // Confirms the Directory doesn't exists
        XCTAssertFalse(VCFileManager.deleteDirectory(directory: .library, customFolder: tempFolderName).success)
        
        // Creates the Directory
        XCTAssertTrue(VCFileManager.createFolderInDirectory(directory: VCFileManager.Directory.library, folderName: tempFolderName).success)
        
        // Confirms the Directory exists
        XCTAssertFalse(VCFileManager.createFolderInDirectory(directory: VCFileManager.Directory.library, folderName: tempFolderName).success)
        
        // Removes the Directory
        XCTAssertTrue(VCFileManager.deleteDirectory(directory: .library, customFolder: tempFolderName).success)
        
        // Confirms the Directory doesn't exists
        XCTAssertFalse(VCFileManager.deleteDirectory(directory: .library, customFolder: tempFolderName).success)
        
    }
    
    func testCreationDate() {
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        VCFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName, replaceExisting: true)
        
        XCTAssertNotNil(VCFileManager.creationDateForFileNamed(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: testDirName))
    }
    
    func testMoveFile() {
        let tempFolderName1 = testDirName+"/TempDir1"
        let tempFolderName2 = testDirName+"/TempDir2"
        
        // Creates the First Directory
        XCTAssertTrue(VCFileManager.createFolderInDirectory(directory: VCFileManager.Directory.library, folderName: tempFolderName1).success)
        
        // Creates the Second Directory
        XCTAssertTrue(VCFileManager.createFolderInDirectory(directory: VCFileManager.Directory.library, folderName: tempFolderName2).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName1).count, 0)
        
        // Verifies the Second Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName2).count, 0)
        
        
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        // Creates the file on the First Directory
        VCFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: tempFolderName1, replaceExisting: true)
        
        
        // Verifies the First Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName1).count, 1)
        
        // Verifies the Second Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName2).count, 0)
        
        // Moves the file to the Second Directory
        VCFileManager.moveFileNamed(fileName: fileName, fileExtension: fileExtension, fromDirectory: VCFileManager.Directory.library, fromCustomFolder: tempFolderName1, toDirectory: VCFileManager.Directory.library, toCustomFolder: tempFolderName2)
        
        // Verifies the First Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName1).count, 0)
        
        // Verifies the Second Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName2).count, 1)
        
        // Reads the file content on the Second Directory
        XCTAssertEqual(VCFileManager.readString(fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: tempFolderName2), fileContent)
    }
    
    func testDeleteAllFilesInDirectory() {
        let tempFolderName1 = testDirName+"/TempDir1"
        
        // Creates the First Directory
        XCTAssertTrue(VCFileManager.createFolderInDirectory(directory: VCFileManager.Directory.library, folderName: tempFolderName1).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName1).count, 0)
        
        let fileName = "TestStringFile"
        let fileExtension = "txt"
        let fileContent = "Testing string 1234"
        
        // Creates the file on the First Directory
        VCFileManager.writeString(string: fileContent, fileName: fileName, fileExtension: fileExtension, directory: VCFileManager.Directory.library, customFolder: tempFolderName1, replaceExisting: true)
        
        // Verifies the First Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName1).count, 1)
        
        // Delete all files on the First Directory
        XCTAssertTrue(VCFileManager.deleteAllFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName1).success)
        
        // Verifies the First Directory content
        XCTAssertEqual(VCFileManager.listFilesInDirectory(directory: VCFileManager.Directory.library, customFolder: tempFolderName1).count, 0)
        
        // Verifies the First Directory still exists
        XCTAssertFalse(VCFileManager.createFolderInDirectory(directory: VCFileManager.Directory.library, folderName: tempFolderName1).success)
        
    }
    
}
