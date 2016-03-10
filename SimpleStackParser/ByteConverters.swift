//
//  ByteConverters.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

typealias Byte	= UInt8
typealias Value = Float

func convertValueToByteArray (var value: Value) -> [Byte] {
	
	return withUnsafePointer(&value) { pointer in
		
		let buffer = UnsafeBufferPointer (start: UnsafePointer<Byte> (pointer), count: sizeof(Value))
		
		return Array (buffer)
	}
}

func convertByteArrayToValue (byteArray: [Byte]) -> Value {
	
	return byteArray.withUnsafeBufferPointer { pointer in
		
		let		value = UnsafePointer <Value> (pointer.baseAddress).memory
		return	value
	}
}