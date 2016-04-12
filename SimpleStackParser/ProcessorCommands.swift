//
//  ProcessorCommands.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

enum ProcessorCommands: String {
	case Push = "push"
	case Pop = "pop"
	case Add = "add"
	case Mul = "mul"
	case Div = "div"
	case Sub = "sub"
	case PushAx = "push ax"
	case PushBx = "push bx"
	case PushCx = "push cx"
	case PushDx = "push dx"
	case PopAx = "pop ax"
	case PopBx = "pop bx"
	case PopCx = "pop cx"
	case PopDx = "pop dx"
	case Jump = "jmp"
	case JumpIfAbove = "ja"
	case JumpIfBelow = "jb"
	case JumpIfEqual = "je"
	case JumpIfAboveOrEqual = "jae"
	case JumpIfBelowOrEqual = "jbe"
	case JumpIfNotAbove = "jna"
	case JumpIfNotBelow = "jnb"
	case JumpIfNotEqual = "jne"
	case JumpIfNotAboveOrEqual = "jnae"
	case JumpIfNotBelowOrEqual = "jnbe"
	case SquareRoot = "sqr"
	
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
		case .PushAx:
			return 7
		case .PushBx:
			return 8
		case .PushCx:
			return 9
		case .PushDx:
			return 10
		case .PopAx:
			return 11
		case .PopBx:
			return 12
		case .PopCx:
			return 13
		case .PopDx:
			return 14
		case .Jump:
			return 15
		case .JumpIfAbove:
			return 16
		case .JumpIfBelow:
			return 17
		case .JumpIfEqual:
			return 18
		case .JumpIfAboveOrEqual:
			return 19
		case .JumpIfBelowOrEqual:
			return 20
		case .JumpIfNotAbove:
			return 21
		case .JumpIfNotBelow:
			return 22
		case .JumpIfNotEqual:
			return 23
		case .JumpIfNotAboveOrEqual:
			return 24
		case .JumpIfNotBelowOrEqual:
			return 25
		case .SquareRoot:
			return 26
		}
	}
}

enum ProcessorCommandsBackwards: Byte {
	case Push = 1
	case Pop = 2
	case Add = 3
	case Mul = 4
	case Div = 5
	case Sub = 6
	case PushAx = 7
	case PushBx = 8
	case PushCx = 9
	case PushDx = 10
	case PopAx = 11
	case PopBx = 12
	case PopCx = 13
	case PopDx = 14
	case Jump = 15
	case JumpIfAbove = 16
	case JumpIfBelow = 17
	case JumpIfEqual = 18
	case JumpIfAboveOrEqual = 19
	case JumpIfBelowOrEqual = 20
	case JumpIfNotAbove = 21
	case JumpIfNotBelow = 22
	case JumpIfNotEqual = 23
	case JumpIfNotAboveOrEqual = 24
	case JumpIfNotBelowOrEqual = 25
	case SquareRoot = 26
	
	var code: String {
		switch self {
		case .Push:
			return "push"
		case .Pop:
			return "pop"
		case .Add:
			return "add"
		case .Mul:
			return "mul"
		case .Div:
			return "div"
		case .Sub:
			return "sub"
		case .PushAx:
			return "push ax"
		case .PushBx:
			return "push bx"
		case .PushCx:
			return "push cx"
		case .PushDx:
			return "push dx"
		case .PopAx:
			return "pop ax"
		case .PopBx:
			return "pop bx"
		case .PopCx:
			return "pop cx"
		case .PopDx:
			return "pop dx"
		case .Jump:
			return "jmp"
		case .JumpIfAbove:
			return "ja"
		case .JumpIfBelow:
			return "jb"
		case .JumpIfEqual:
			return "je"
		case .JumpIfAboveOrEqual:
			return "jae"
		case .JumpIfBelowOrEqual:
			return "jbe"
		case .JumpIfNotAbove:
			return "jna"
		case .JumpIfNotBelow:
			return "jnb"
		case .JumpIfNotEqual:
			return "jne"
		case .JumpIfNotAboveOrEqual:
			return "jnae"
		case .JumpIfNotBelowOrEqual:
			return "jnbe"
		case .SquareRoot:
			return "sqr"
		}
	}
}