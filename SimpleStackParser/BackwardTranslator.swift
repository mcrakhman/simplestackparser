//
//  BackwardTranslator.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

typealias CommandBytePosition = (String, TwoByte?)

class BackwardsTranslator {
	
	var output: [CommandBytePosition] = []
	var labelBytePosition: [String: TwoByte] = [:]
	
	var bytesArray: [Byte] = []
	var currentLabelNumber = 1
	
	enum Requires {
		case No
		case Value
		case Label
	}
	
	func translate (bytesArray: [Byte]) throws -> String {
		
		output = []
		self.bytesArray = bytesArray
		
		var index = 0
		while index < bytesArray.count {
			
			checkForLabelAtIndexAndAddToOutput (index)
			
			print (convertCommandByteArrayToString(output))
			
			let requires = try parseCommandAndAddToOutput (index)
			index += 1
			
			switch requires {
			case .No:
				break
			
			case .Value:
				try parseValueAndAddToOutput (index)
				index += sizeof (Value)
			
			case .Label:
				try parseLabelAndAddToOutput (index)
				index += sizeof (TwoByte)
			}
		}
		
		return convertCommandByteArrayToString (output)
	}
	
	func convertCommandByteArrayToString (commandByteArray: [CommandBytePosition]) -> String {
		return commandByteArray
			.map { $0.0 }
			.reduce ("", combine: { firstString, secondString in
				return firstString + secondString + " "
		})
	}
	
	func parseCommandAndAddToOutput (index: Int) throws -> Requires {
		
		let command = bytesArray [index]
		
		guard let backwardsCommand = ProcessorCommandsBackwards (rawValue: command)
			else {
				throw TranslatorError.InvalidData
		}
		
		output.append ((backwardsCommand.code, TwoByte (index)))
		
		if backwardsCommand == .Push {
			return .Value
		}
		
		if isJump (backwardsCommand) {
			return .Label
		}
		
		return .No
	}
	
	func parseLabelAndAddToOutput (index: Int) throws {
		
		let startIndex = index
		let endIndex = startIndex + sizeof (TwoByte)
		
		guard endIndex <= bytesArray.count
			else {
				throw TranslatorError.InvalidData
		}
		let byteRepresentation = Array (bytesArray [startIndex..<endIndex])
		let bytePosition: TwoByte = convertByteArrayToValue (byteRepresentation)
		
		let labelName = String (currentLabelNumber)
		
		if let i = commandNoForBytePosition (bytePosition) {
			output.insert ((":" + labelName, nil), atIndex: i)
		} else {
			labelBytePosition [labelName] = bytePosition
		}
		
		output.append ((labelName, TwoByte (index)))
		
		currentLabelNumber += 1
		
	}
	
	func commandNoForBytePosition (bytePosition: TwoByte) -> Int? {
		
		for i in 0 ..< output.count {
			if output [i].1 == bytePosition {
				return i
			}
		}
		
		return nil
	}
	
	func parseValueAndAddToOutput (index: Int) throws {
	
		let startIndex = index
		let endIndex = startIndex + sizeof (Value)
		
		guard endIndex <= bytesArray.count
			else {
				throw TranslatorError.InvalidData
		}
		
		let byteRepresentation = Array (bytesArray [startIndex..<endIndex])
		let value: Value = convertByteArrayToValue (byteRepresentation)
		let stringFromValue = String (value)
		
		output.append ((stringFromValue, TwoByte (index)))
	}
	
	func checkForLabelAtIndexAndAddToOutput (index: Int) {
		for keyValuePair in labelBytePosition {
			if keyValuePair.1 == TwoByte (index) {
				
				let labelName = keyValuePair.0
				output.append ((":" + labelName, nil))
				
				labelBytePosition.removeValueForKey (labelName)
			}
		}
	}
	
	func isJump (command: ProcessorCommandsBackwards) -> Bool {
		
		return command.rawValue >= 15 && command.rawValue <= 25
	}
}

