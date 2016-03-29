//
//  Stack.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 10.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

class Node <T> {
	var element: T?
	
	var nextNode: Node<T>?
	
	init () {
	}
	
	init (element: T) {
		self.element = element
	}
}

class Stack <T> {
	
	var node: Node <T>?
	
	func pop () -> T? {
		if node != nil {
			
			let element = node?.element
			node = node?.nextNode
			
			return element
			
		} else {
			return nil
		}
	}
	
	func push (element: T) {
		let newNode	= Node<T> (element: element)
	
		newNode.nextNode = node
		
		node = newNode
	}
	
	func printAllElements () {
		var runningNode: Node <T>?
		
		runningNode = node
		
		while runningNode != nil {
			runningNode = runningNode?.nextNode
		}
		
	}
	
}