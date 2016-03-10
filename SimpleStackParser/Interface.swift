//
//  Interface.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

class Interface {
	
	static let sharedInstance	= Interface		()
	
	let translator				= Translator	()
	let processor				= Processor		()
	let backwardsTranslator		= BackwardsTranslator ()
	
	let fileManager				= SimpleStackParserFileManager ()
	
	class func createFileWithFilenameAndString (string: String, filename: String) {
		
		let interface = sharedInstance
		
		interface.fileManager.createFileWithStringInApplicationDirectory(string, filename: filename)
	}
	
	class func parseLanguageFileAndCreateRunFile (filename: String) {
		
		let interface = sharedInstance
		
		var output: [Byte] = []
		
		guard let data = interface.fileManager.readFromFileInApplicationDirectory (filename)
			else {
				print ("Unable to read from file. Terminating...")
				return
		}
		
		guard let string = String (data: data, encoding: NSUTF8StringEncoding)
			else {
				print ("Have not been able to transform the data to string. This is strange...")
				return
		}
		
		do {
			try output = interface.translator.translate(string)
		} catch {
			print ("Unable to recognise language, please refer to simple stack language guide for clues.")
			return
		}
		interface.fileManager.createFileWithDataInApplicationDirectory(output, filename: filename + ".run")
	}
	
	class func runFromFile (filename: String) {
		
		let interface = sharedInstance
		
		guard let data = interface.fileManager.readFromFileInApplicationDirectory (filename)
			else {
				print ("Unable to read from file. Terminating...")
				return
		}
		
		let input = interface.convertNSDataToByte(data)
		
		do {
			try interface.processor.process(input)
		} catch {
			print ("Some troubles with your code, cannot process it. Terminating...")
		}
	}
	
	class func parseRunFileBackwards (filename: String) {
		
		let interface = sharedInstance
		
		guard let data = interface.fileManager.readFromFileInApplicationDirectory (filename)
			else {
				print ("Unable to read from file. Terminating...")
				return
		}
		
		let input = interface.convertNSDataToByte(data)
		
		var string = ""
		do {
			try string = interface.backwardsTranslator.translate(input)
		} catch {
			print ("Unable to recognise language, please refer to simple stack language guide for clues.")
			return
		}
		interface.fileManager.createFileWithStringInApplicationDirectory(string, filename: filename + ".backwards")
	}
	
	func convertNSDataToByte (data: NSData) -> [Byte] {
		
		let buffer = UnsafeBufferPointer (start: UnsafePointer<Byte> (data.bytes), count: data.length)
		
		return Array (buffer)
	}
	
}