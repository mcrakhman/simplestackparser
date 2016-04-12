//
//  Variables.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 11.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

enum Variables: String {
	
	case Ax = "ax"
	case Bx = "bx"
	case Cx = "cx"
	case Dx = "dx"
	
	var code: Byte {
		switch self {
		case .Ax:
			return 1
		case .Bx:
			return 2
		case .Cx:
			return 3
		case .Dx:
			return 4
		}
	}
}