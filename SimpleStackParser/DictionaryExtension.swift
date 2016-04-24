//
//  DictionaryExtension.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 24.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
	
	func anyKeyFor (value: Value) -> Key? {
		
		guard let index = indexOf({ $0.1 == value }) else {
			return nil
		}
		
		return self [index].0
	}	
}