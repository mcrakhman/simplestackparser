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
	var variableRAMNamesArray: [String] = []
	
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
		
		return bytesOutput
	}
	
	func analyzeString (string: String) throws {
		
		if let command = lastCommand {
			
			if isJumpOrCall(command) {
				try analyzeLabelAfterJump (string)
				lastCommand = nil
				
				return
			}
			if (command == .Push || command == .Pop) && isVariableRAM (string) {
				try analyzeVariableRAMAfterPushPop (string)
				lastCommand = nil
				
				return
			}
			if command == .RegisterVariable {
				try analyzeVariableRAMAfterReg (string)
				lastCommand = nil
				
				return
			}
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
	
	func analyzeVariableRAMAfterPushPop (string: String) throws {
		
		guard let indexOfVariable = variableRAMNamesArray.indexOf (string),
				let command = lastCommand
			else {
				throw TranslatorError.InvalidData
		}
		
		let byteIndex = Byte (indexOfVariable)
		bytesOutput.removeAtIndex (bytesOutput.count - 1)
		
		switch command {
		case .Push:
			bytesOutput.append (ProcessorCommandsBackwards.PushVariable.rawValue)
		case .Pop:
			bytesOutput.append (ProcessorCommandsBackwards.PopVariable.rawValue)
		default:
			throw TranslatorError.InvalidData
		}
		
		bytesOutput.append (byteIndex)
		
	}
	
	func analyzeVariableRAMAfterReg (string: String) throws {
		
		guard !variableRAMNamesArray.contains (string)
			else {
				throw TranslatorError.InvalidData
		}
		
		variableRAMNamesArray.append (string)
		
		let byteIndex = Byte (variableRAMNamesArray.count - 1)
		bytesOutput.append (byteIndex)
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
		
		if let tuple = labelDictionary [label] where tuple.1 != nil {
			
			if let byteWhenLabelOccured = tuple.1 {
		
				let byteArrayConverted = convertValueToByteArray (byteWhenLabelOccured)
				bytesOutput.appendContentsOf (byteArrayConverted)
				
				//labelDictionary.removeValueForKey (label)
				
				return
			} else {
				throw TranslatorError.InvalidData
			}
		} else {
			// if we don't know the label's position
			let currentPosition = bytesOutput.count
			
			if labelDictionary [label]?.0 == nil {
				labelDictionary [label] = ([currentPosition], nil)
			} else {
				labelDictionary [label]?.0?.append (currentPosition)
			}
			
			// reserve two bytes to change them when the label will be found
			bytesOutput.appendContentsOf ([0, 0])
		}
	}
	
	func analyzeStandaloneLabel (label: String) throws {
		
		let labelRemovedColon = String (label.characters.dropFirst())
		
		if let tuple = labelDictionary [labelRemovedColon] {
			
			if let bytesWhenJumpCommandOccured = tuple.0 {
				let currentPosition = TwoByte (bytesOutput.count)
				let byteArrayConverted = convertValueToByteArray (currentPosition)
				
				for byte in bytesWhenJumpCommandOccured {
					bytesOutput [byte] = byteArrayConverted [0]
					bytesOutput [byte + 1] = byteArrayConverted [1]
				}
				
				//labelDictionary.removeValueForKey (labelRemovedColon)
				
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

	func isJumpOrCall (command: ProcessorCommands) -> Bool {
		
		return command.code >= 15 && command.code <= 26
	}
	
	func isVariableRAM (string: String) -> Bool {
		return variableRAMNamesArray.contains (string)
	}

	func isLabel (string: String) -> Bool {
		
		return string.characters.first == ":"
	}
}
