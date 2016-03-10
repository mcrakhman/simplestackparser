//
//  Translator.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

enum ProcessorCommands: String {
	case Push	= "push"
	case Pop	= "pop"
	case Add	= "add"
	case Mul	= "mul"
	case Div	= "div"
	case Sub	= "sub"
	
	var code: Byte {
		switch self {
		case .Push:
			return 1
		case .Pop:
			return 2
		case .Add:
			return 3
		case .Mul:
			return 4
		case .Div:
			return 5
		case .Sub:
			return 6
		}
	}
}

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
