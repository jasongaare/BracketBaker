//
//  FileSaveHelper.swift
//  BracketBaker
//
//  Created by Jason Gaare on 12/11/15.
//  Copyright © 2015 Jason Gaare. All rights reserved.
//

// Resource found here: http://www.learncoredata.com/how-to-save-files-to-disk/


import Foundation

class FileSaveHelper {
    
    // MARK:- Error Types
    private enum FileErrors:ErrorType {
        case JsonNotSerialized
        case FileNotSaved
        case ImageNotConvertedToData
        case FileNotRead
        case FileNotFound
    }
    
    // MARK:- File Extension Types
    enum FileExension:String {
        case TXT = ".txt"
        case JPG = ".jpg"
        case JSON = ".json"
    }
    
    // MARK:- Private Properties
    private let directory:NSSearchPathDirectory
    private let directoryPath: String
    private let fileManager = NSFileManager.defaultManager()
    private let fileName:String
    private let filePath:String
    private let fullyQualifiedPath:String
    private let subDirectory:String


    // MARK: Boolean computed variables
    var fileExists:Bool {
        get {
            return fileManager.fileExistsAtPath(fullyQualifiedPath)
        }
    }
    
    var directoryExists:Bool {
        get {
            var isDir = ObjCBool(true)
            return fileManager.fileExistsAtPath(filePath, isDirectory: &isDir )
        }
    }
    
    // MARK: Initializer, File Accesses
    
    init(fileName:String, fileExtension:FileExension, subDirectory:String, directory:NSSearchPathDirectory){
        self.fileName = fileName + fileExtension.rawValue
        self.subDirectory = "/\(subDirectory)"
        self.directory = directory
        
        self.directoryPath = NSSearchPathForDirectoriesInDomains(directory, .UserDomainMask, true)[0]
        self.filePath = directoryPath + self.subDirectory
        self.fullyQualifiedPath = "\(filePath)/\(self.fileName)"
        
        //print(self.directoryPath)
        
        createDirectory()
    }
    
    
    private func createDirectory(){
        if !directoryExists {
            do {
                try fileManager.createDirectoryAtPath(filePath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print("An Error was generated creating directory")
            }
        }
    }


    func saveFile(string fileContents:String) throws{
        do {
            try fileContents.writeToFile(fullyQualifiedPath, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch  {
            throw error
        }

    }
    
    func getContentsOfFile() throws -> String {
        guard fileExists else {
            throw FileErrors.FileNotFound
        }
        
        var returnString:String
        
        do {
            returnString = try String(contentsOfFile: fullyQualifiedPath, encoding: NSUTF8StringEncoding)
        }
        catch {
            throw FileErrors.FileNotRead
        }

        return returnString
    }
    
    
}


