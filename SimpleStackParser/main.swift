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
	case Run = "run"
	case ParseRun = "parserun"
	case ParseBackwards = "backwards"
	case TestRun = "testrun"
}

func start () {
	
	let argumentCount = Process.arguments.count
	
	guard argumentCount >= 3
		else {
			
			print ("First of all please note that each time stack pops something, including when the application does multiplications etc, it *prints* something\n")
			
			print ("If you ever run my application, I am pretty certain you know something of its capabilities. In case you don't, it understands 6 commands push (with a parameter of type float), pop, add, sub, mul, div\n")
			
			print ("You may use the application as follows, provided that you first type \"./SimpleStackParser\":\n")
			
			print ("Type \"parse [filename]\" and it will make a byte file with .run extension which only this program can understand. So cool isn't it?) Note that the parser does not check whether you have done some logical errors like written \"push push\". In this case the error will occur while the program executes and an error message will arise\n")
			
			print ("Afterwards you may type \"run [filename]\" and it tries to run it and prints the result if, of course, you haven't made any mistakes, like tried to pop empty stack.  \n")
			
			print ("If you want to disasm the file type \"backwards [filename]\" and it will make the file with backwards extension\n")
			
			print ("Last but not least you can just type \"parserun [filename]\" and it skips the making of the run file phase.\n")
			
			print ("And almost forgot to mention that you can type \"testrun [code]\" without using any file extension.")
			
			return
	}
	if let secondArgument = Arguments (rawValue: Process.arguments [1]) {
		switch secondArgument {
			case .Parse:
				Interface.parseLanguageFileAndCreateRunFile (Process.arguments [2])
			case .Run:
				Interface.runFromFile (Process.arguments [2])
			case .ParseRun:
				Interface.parseRunFromFile (Process.arguments [2])
			case .ParseBackwards:
				Interface.parseFileBackwards (Process.arguments [2])
			case .TestRun:
				
				guard Process.arguments.count > 3
					else {
						print ("No no no where are your arguments man???")
						return
				}
				
				let endArguments = Array (Process.arguments [2..<Process.arguments.count])
				let jointString	 = endArguments.joinWithSeparator(" ")
				
				Interface.testRunFromString (jointString)
		}
	} else {
		print ("Bad arguments man, looks like you dunno who u messing with")
	}

}

start ()

//let fileManager = SimpleStackParserFileManager ()
//if let data = fileManager.readFromFileInAnyDirectoryWithPath ("/Users/mikhailrakhmanov/Documents/SwiftProgramming/TutuTrainStationSearch/fib10times.txt") {
//	if let string = String (data: data, encoding: NSUTF8StringEncoding) {
//		Interface.testRunFromString (string)
//	}
//}
//
//

//let translator = Translator ()
//
//let commandString = "reg first reg second reg index push 1 pop first push 1 pop second push 0 pop index :start call fib push index push 10 jb start end :fib push first push second add print push second pop first pop second push index push 1 add pop index ret"
////"reg varA reg varB push 5 pop varA push 6 pop varB push varA push varB mul"
//let bytesOutput = try translator.translate (commandString)
//
//let backwardsTranslator = BackwardsTranslator ()
//let finalString = try backwardsTranslator.translate (bytesOutput)
//
//print (finalString)
//
//
//let processor = Processor ()
//try processor.process (bytesOutput)

