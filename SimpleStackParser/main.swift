//
//  main.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

enum Arguments: String {
	case Parse			= "parse"
	case Run			= "run"
	case ParseRun		= "parserun"
	case ParseBackwards = "backwards"
}

func start () {
	
	let argumentCount = Process.arguments.count
	
	guard argumentCount == 3
		else {
			print ("First of all please note that each time stack pops something, including when the application does multiplications etc, it *prints* something\n\nIf you ever run my application, I am pretty certain you know something of its capabilities. In case you don't, it understands 6 commands push (with a parameter of type float), pop, add, sub, mul, div\n\nYou may use the application as follows:\n\nType \"parse [filename]\" and it will make a byte file with .run extension which only this program can understand. So cool isn't it?) Note that the parser does not check whether you have done some logical errors like written \"push push\". In this case the error will occur while the program executes and an error message will arise\n\nAfterwards you may type \"run [filename]\" and it tries to run it and prints the result if, of course, you haven't made any mistakes, like tried to pop empty stack.  \n\nIf you want to disasm the file type \"backwards [filename]\" and it will make the file with backwards extension\n\nLast but not least you can just type \"parserun filename\" and it skips the making of the run file phase.")
			return
	}
	if let secondArgument = Arguments (rawValue: Process.arguments [1]) {
		switch secondArgument {
			case .Parse:
				Interface.parseLanguageFileAndCreateRunFile (Process.arguments [2])
			case .Run:
				Interface.runFromFile						(Process.arguments [2])
			case .ParseRun:
				Interface.parseRunFromFile					(Process.arguments [2])
			case .ParseBackwards:
				Interface.parseFileBackwards				(Process.arguments [2])		
		}
	} else {
		print ("Bad arguments man, looks like you dunno who u messing with")
	}

}

start ()

