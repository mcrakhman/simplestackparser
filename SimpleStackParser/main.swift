//
//  main.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

enum Arguments: String {
	case Parse	= "parse"
	case Run	= "run"
}

func start () {
	
	let argumentCount = Process.arguments.count
	
	guard argumentCount == 3
		else {
			print ("Shame on you man you dunno how to use my application")
			return
	}
	if let secondArgument = Arguments (rawValue: Process.arguments [1]) {
		switch secondArgument {
			case .Parse:
				Interface.parseLanguageFileAndCreateRunFile (Process.arguments [2])
			case .Run:
				Interface.runFromFile (Process.arguments [2])
		}
	} else {
		print ("Bad arguments man, looks like you dunno who u messing with")
	}

}

start ()

