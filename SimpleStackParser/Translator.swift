//
//  Translator.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

enum TranslatorError : ErrorType {
	case InvalidData
}

class Translator {
	
	var bytesOutput: [Byte] = []
	var lastCommand: ProcessorCommands?
	var labelDictionary: LabelDictionary = [:]
	
	func translate (string: String) throws -> [Byte] {
		
		bytesOutput = []
		
		var selectedString = ""
		
		for character in string.characters {
			
			if character == " " || character == "\n" {
				
				if selectedString != "" {
					try analyzeString (selectedString)
					
					selectedString = ""
				}
			}
			else  {
				selectedString += String (character)
			}
		}
		
		if selectedString != "" {
			try analyzeString (selectedString)
		}
		
		if !labelDictionary.isEmpty {
			throw TranslatorError.InvalidData
		}
		
		return bytesOutput
	}
	
	func analyzeString (string: String) throws {
		
		if let command = lastCommand where isJump (command) {
			try analyzeLabelAfterJump (string)
			
			lastCommand = nil
			
			return
		}
		
		if let number = Value (string) {
			let bytesArray = convertValueToByteArray (number)
			bytesOutput.appendContentsOf (bytesArray)
			
			lastCommand = nil
			
		} else {
			if let processorCommand = ProcessorCommands (rawValue: string) {
				analyzeProcessorCommand (processorCommand)
				
			} else if let variable = Variables (rawValue: string) {
				try analyzeVariable (variable)
				
			} else if isLabel (string) {
				try analyzeStandaloneLabel (string)
				
				lastCommand = nil
			
			} else {
				throw TranslatorError.InvalidData
			}
		}
		
		
	}
	
	func analyzeProcessorCommand (command: ProcessorCommands) {
		lastCommand = command
	
		bytesOutput.append (command.code)
	}
	
	func analyzeVariable (variable: Variables) throws {

		guard let command = lastCommand
			else {
				throw TranslatorError.InvalidData
		}
		
		var compositeStringCommand = ""
		
		switch command {
		case .Pop:
			compositeStringCommand = command.rawValue + " " + variable.rawValue
		case .Push:
			compositeStringCommand = command.rawValue + " " + variable.rawValue
		default:
			throw TranslatorError.InvalidData
		}
		
		guard let compositeCommand = ProcessorCommands (rawValue: compositeStringCommand)
			else {
				throw TranslatorError.InvalidData
		}
		
		bytesOutput.removeAtIndex (bytesOutput.count - 1)
		
		analyzeProcessorCommand (compositeCommand)
	}
	
	func analyzeLabelAfterJump (label: String) throws {
		
		if let tuple = labelDictionary [label] {
			
			if let byteWhenLabelOccured = tuple.1 {
		
				let byteArrayConverted = convertValueToByteArray (byteWhenLabelOccured)
				bytesOutput.appendContentsOf (byteArrayConverted)
				
				labelDictionary.removeValueForKey (label)
				
				return
			} else {
				throw TranslatorError.InvalidData
			}
		} else {
			// if we encountered the label for the first time
			let currentPosition = bytesOutput.count
			
			labelDictionary [label] = (currentPosition, nil)
			// reserve two bytes to change them when the label will be found
			bytesOutput.appendContentsOf ([0, 0])
		}
	}
	
	func analyzeStandaloneLabel (label: String) throws {
		
		let labelRemovedColon = String (label.characters.dropFirst())
		
		if let tuple = labelDictionary [labelRemovedColon] {
			
			if let byteWhenJumpCommandOccured = tuple.0 {
				let currentPosition = TwoByte (bytesOutput.count)
				let byteArrayConverted = convertValueToByteArray (currentPosition)
				
				bytesOutput [byteWhenJumpCommandOccured] = byteArrayConverted [0]
				bytesOutput [byteWhenJumpCommandOccured + 1] = byteArrayConverted [1]
				
				labelDictionary.removeValueForKey (labelRemovedColon)
				
				return
			} else {
				throw TranslatorError.InvalidData
			}
		} else {
			// if we encountered the label for the first time
			let currentPosition = bytesOutput.count
			labelDictionary [labelRemovedColon] = (nil, TwoByte (currentPosition))
		}
	}

	func isJump (command: ProcessorCommands) -> Bool {
		
		return command.code >= 15 && command.code <= 25
	}

	func isLabel (string: String) -> Bool {
		
		return string.characters.first == ":"
	}
}
