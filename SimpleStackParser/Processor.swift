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
	var bytesInput: [Byte] = []
	
	var ax: Value = 0
	var bx: Value = 0
	var cx: Value = 0
	var dx: Value = 0
	
	func process (bytes: [Byte]) throws {
		
		print ("Yo, I am starting, let's see and... your answer is...")
		
		bytesInput = bytes
		var index = 0
		
		while index < bytesInput.count {
			index = try processCommandAtIndexAndMove (index)
		}
		
	}
	
	func processCommandAtIndexAndMove (index: Int) throws -> Int {
		
		let command = bytesInput [index]
		
		switch command {
		
		case ProcessorCommands.Jump.code:
			return try jump (index) 
			
		case ProcessorCommands.JumpIfAbove.code:
			return try jump (index, condition: >)
		
		case ProcessorCommands.JumpIfBelow.code:
			return try jump (index, condition: <)
			
		case ProcessorCommands.JumpIfEqual.code:
			return try jump (index, condition: ==)
			
		case ProcessorCommands.JumpIfNotEqual.code:
			return try jump (index, condition: !=)
			
		case ProcessorCommands.JumpIfNotAbove.code:
			return try jump (index, condition: <=)
			
		case ProcessorCommands.JumpIfNotBelow.code:
			return try jump (index, condition: >=)
			
		case ProcessorCommands.JumpIfNotBelowOrEqual.code:
			return try jump (index, condition: >)
			
		case ProcessorCommands.JumpIfNotAboveOrEqual.code:
			return try jump (index, condition: <)
		
		case ProcessorCommands.JumpIfAboveOrEqual.code:
			return try jump (index, condition: >=)
			
		case ProcessorCommands.JumpIfBelowOrEqual.code:
			return try jump (index, condition: <=)
			
		case ProcessorCommands.PushAx.code:
			push (ax)
			return index + 1
		
		case ProcessorCommands.PushBx.code:
			push (bx)
			return index + 1
		
		case ProcessorCommands.PushCx.code:
			push (cx)
			return index + 1
	
		case ProcessorCommands.PushDx.code:
			push (dx)
			return index + 1
			
		case ProcessorCommands.PopAx.code:
			ax = try pop ()
			return index + 1
			
		case ProcessorCommands.PopBx.code:
			bx = try pop ()
			return index + 1
			
		case ProcessorCommands.PopCx.code:
			cx = try pop ()
			return index + 1
			
		case ProcessorCommands.PopDx.code:
			dx = try pop ()
			return index + 1
			
		case ProcessorCommands.Push.code:
			
			let value: Value = try read (index)
			push (value)
			
			return index + sizeof(Value) + 1
			
		case ProcessorCommands.Pop.code:
			try pop ()
			
			return index + 1
			
		case ProcessorCommands.Add.code:
			try add ()
			
			return index + 1
			
		case ProcessorCommands.Sub.code:
			try sub ()
			
			return index + 1
			
		case ProcessorCommands.Mul.code:
			try mul ()
			
			return index + 1
			
		case ProcessorCommands.Div.code:
			try div ()
			
			return index + 1
		
		case ProcessorCommands.SquareRoot.code:
			try sqr ()
			
			return index + 1
			
		default:
			throw ProcessorError.InvalidOperation
		}
	}
	
	func jump (index: Int, condition: ((Value, Value) -> Bool)? = nil) throws -> Int {
		
		let jumpIndex: TwoByte = try read (index)
		
		guard let condition = condition
			else {
				return Int (jumpIndex)
		}
		
		let firstValue	= try pop ()
		let secondValue	= try pop ()
		
		if condition (secondValue, firstValue) {
			return Int (jumpIndex)
		} else {
			return index + 1 + sizeof (TwoByte)
		}
	}
	
	func read <T> (index: Int) throws -> T {
		let startIndex = index + 1
		let endIndex = startIndex + sizeof (T)
		
		guard endIndex <= bytesInput.count
			else {
				throw ProcessorError.InvalidOperation
		}
		
		let byteRepresentation	= Array (bytesInput [startIndex..<endIndex])
		let value: T = convertByteArrayToValue (byteRepresentation)
		
		return value
	}
	
	func push (value: Value) {
		stack.push (value)
	}
	
	func sqr () throws {
		let value = sqrt (try pop ())
		
		print ("Let's sqrt that thing: \(value)")
		
		stack.push (value)
	}
	
	func add () throws {
		
		let firstValue = try pop ()
		let secondValue	= try pop ()
		
		let value = firstValue + secondValue
		
		print ("Let's add that thing: \(value)")
		
		stack.push (value)
	}
	
	func sub () throws {
		let firstValue	= try pop ()
		let secondValue	= try pop ()
		
		let value = firstValue - secondValue
		
		print ("Let's sub that thing: \(value)")
		
		stack.push (value)
	}
	
	func mul () throws {
		
		let firstValue = try pop ()
		let secondValue	= try pop ()
		
		let value = firstValue * secondValue
		
		print ("Let's mul that thing: \(value)")
		
		stack.push (value)
	}
	
	func div () throws {
		let firstValue = try pop ()
		let secondValue	= try pop ()
		
		guard secondValue != 0
			else {
				throw ProcessorError.InvalidOperation
		}
		
		let value = firstValue / secondValue
		
		print ("Let's div that thing: \(value)")
		
		stack.push (value)
	}
	
	func pop () throws -> Value {
	
		if let value = stack.pop () {
		
			print ("Let's pop that thing: \(value)")

			return value
		} else {
			throw ProcessorError.InvalidOperation
		}
	}
	
	func popAndPrint () throws {
		print (try pop ())
	}
	
}

