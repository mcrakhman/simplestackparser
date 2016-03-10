//
//  ProcessorCommands.swift
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