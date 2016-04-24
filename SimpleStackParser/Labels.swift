//
//  Labels.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 12.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

/// .0 (Int) from tuple is the number of byte when the jmp command or call command occured
/// .1 (TwoByte) - position where the label has occured
typealias LabelDictionary = [String: ([Int]?, TwoByte?)]