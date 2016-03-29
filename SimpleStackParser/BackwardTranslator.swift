//
//  BackwardTranslator.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

class BackwardsTranslator {
	
	var stringOutput: String = ""
	
	enum RequiresValue {
		case Yes
		case No
	}
	
	func translate (bytesArray: [Byte]) throws -> String {
		
		stringOutput = ""
		
		var index = 0
		while index < bytesArray.count {
			if try parseCommandAndAddToOutput (bytesArray [index]) == RequiresValue.No {
				index += 1
			} else {
				index += 1
				
				let startIndex	= index
				let endIndex = startIndex + sizeof (Value)
				
				guard endIndex < bytesArray.count
					else {
						throw TranslatorError.InvalidData
				}
				
				let byteRepresentation = Array (bytesArray [startIndex..<endIndex])
				parseValueFromBytesAndAddToOutput (byteRepresentation)
				
				index += sizeof (Value)
			}
		}
		
		return stringOutput
	}
	
	func parseCommandAndAddToOutput (command: Byte) throws -> RequiresValue {
		
		switch command {
			
		case ProcessorCommands.Push.code:
			stringOutput += ProcessorCommands.Push.rawValue + " "
			return .Yes
			
		case ProcessorCommands.Pop.code:
			stringOutput += ProcessorCommands.Pop.rawValue + " "
			
		case ProcessorCommands.Add.code:
			stringOutput += ProcessorCommands.Add.rawValue + " "
			
		case ProcessorCommands.Sub.code:
			stringOutput += ProcessorCommands.Sub.rawValue + " "
			
		case ProcessorCommands.Mul.code:
			stringOutput += ProcessorCommands.Mul.rawValue + " "
			
		case ProcessorCommands.Div.code:
			stringOutput += ProcessorCommands.Div.rawValue + " "
			
		default:
			throw TranslatorError.InvalidData
		}
		
		return .No
	}
	
	func parseValueFromBytesAndAddToOutput (byteRepresentation: [Byte]) {
		let value	= convertByteArrayToValue(byteRepresentation)
		let stringFromValue = String (value)
		
		stringOutput += stringFromValue + " "
	}
}
