//
//  ByteConverters.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

typealias Byte	= UInt8
typealias TwoByte = UInt16
typealias Value = Float

func convertValueToByteArray <T> (_value: T) -> [Byte] {
	
	var value = _value
	
	return withUnsafePointer(&value) { pointer in
		
		let buffer = UnsafeBufferPointer (start: UnsafePointer<Byte> (pointer), count: sizeof(T))
		return Array (buffer)
	}
}

func convertByteArrayToValue <T> (byteArray: [Byte]) -> T {
	
	return byteArray.withUnsafeBufferPointer { pointer in
		
		let	value = UnsafePointer <T> (pointer.baseAddress).memory
		return	value
	}
}