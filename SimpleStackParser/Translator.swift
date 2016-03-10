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
	
	
	func translate (string: String) throws -> [Byte] {
		
		bytesOutput = []
		
		var selectedString = ""
		
		for character in string.characters {
			
			if character == " " || character == "\n" {
				
				if selectedString != "" {
					try analyzeString(selectedString)
					
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
		if let number = Value (string) {
			
			let bytesArray = convertValueToByteArray (number)
			bytesOutput.appendContentsOf (bytesArray)
		} else {
			if let processorCommand = ProcessorCommands (rawValue: string) {
				analyzeProcessorCommand(processorCommand)
			} else {
				throw TranslatorError.InvalidData
			}
		}
	}
	
	func analyzeProcessorCommand (command: ProcessorCommands) {
		switch command {
		case ProcessorCommands.Push:
			
			bytesOutput.append(ProcessorCommands.Push.code)
			
		case ProcessorCommands.Pop:
			
			bytesOutput.append(ProcessorCommands.Pop.code)
			
		case ProcessorCommands.Add:
			
			bytesOutput.append(ProcessorCommands.Add.code)
			
		case ProcessorCommands.Sub:
			
			bytesOutput.append(ProcessorCommands.Sub.code)
			
		case ProcessorCommands.Mul:
			
			bytesOutput.append(ProcessorCommands.Mul.code)
			
		case ProcessorCommands.Div:
			
			bytesOutput.append(ProcessorCommands.Div.code)
		}
	}
}
