//
//  UserInterface.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

class SimpleStackParserFileManager {
	
	let fileManager = NSFileManager.defaultManager()
	
	func createFileWithStringInApplicationDirectory (string: String, filename: String) {
		let path	= fileManager.currentDirectoryPath + "/" + filename
		let nsdata	= string.dataUsingEncoding (NSUTF8StringEncoding)
		
		fileManager.createFileAtPath(path, contents: nsdata, attributes: nil)
	}
	
	func createFileWithDataInApplicationDirectory (data: [Byte], filename: String) {
		let path	= fileManager.currentDirectoryPath + "/" + filename
		let nsdata	= NSData (bytes: data, length: data.count)
		
		fileManager.createFileAtPath(path, contents: nsdata, attributes: nil)
	}
	
	func readFromFileInApplicationDirectory (filename: String) -> NSData? {
		let path	= fileManager.currentDirectoryPath + "/" + filename
	
		return fileManager.contentsAtPath (path)
	}
	
}