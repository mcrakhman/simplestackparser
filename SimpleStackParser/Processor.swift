//
//  Processor.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

enum ProcessorError: ErrorType {
	case InvalidOperation
}

class Processor {
	
	let stack: Stack<Value> = Stack <Value> ()
	var bytesInput: [Byte]	= []
	
	func process (bytes: [Byte]) throws {
		
		bytesInput	= bytes
		var index	= 0
		
		while index < bytesInput.count {
			index += try processCommandAtIndexAndMove (index)
		}
		
	}
	
	func processCommandAtIndexAndMove (index: Int) throws -> Int {
		
		let command = bytesInput [index]
		
		switch command {
			
		case ProcessorCommands.Push.code:
			let byteRepresentation	= Array (bytesInput [index + 1..<index + sizeof(Value) + 1])
			let value				= convertByteArrayToValue (byteRepresentation)
			
			push (value)
			
			return sizeof(Value) + 1
			
		case ProcessorCommands.Pop.code:
			try popAndPrint ()
			
			return 1
			
		case ProcessorCommands.Add.code:
			try add ()
			
			return 1
			
		case ProcessorCommands.Sub.code:
			try sub ()
			
			return 1
			
		case ProcessorCommands.Mul.code:
			try mul ()
			
			return 1
			
		case ProcessorCommands.Div.code:
			try div ()
			
			return 1
			
		default:
			throw ProcessorError.InvalidOperation
		}
	}
	
	func push (value: Value) {
		stack.push (value)
	}
	
	func add () throws {
		
		let firstValue	= try pop ()
		let secondValue	= try pop ()
		
		stack.push (firstValue + secondValue)
	}
	
	func sub () throws {
		let firstValue	= try pop ()
		let secondValue	= try pop ()
		
		stack.push (firstValue - secondValue)
	}
	
	func mul () throws {
		
		let firstValue	= try pop ()
		let secondValue	= try pop ()
		
		stack.push (firstValue * secondValue)
	}
	
	func div () throws {
		let firstValue	= try pop ()
		let secondValue	= try pop ()
		
		stack.push (firstValue / secondValue)
	}
	
	func pop () throws -> Value {
	
		if let value = stack.pop () {
			return value
		} else {
			throw ProcessorError.InvalidOperation
		}
	}
	
	func popAndPrint () throws {
		print (try pop ())
	}
	
}

