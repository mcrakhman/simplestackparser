//
//  Labels.swift
//  SimpleStackParser
//
//  Created by MIKHAIL RAKHMANOV on 12.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

/// .0 (Int) from tuple is the number of byte when the label occured
/// .1 (Int) - where the jmp command occured
typealias LabelDictionary = [String: ([Int]?, TwoByte?)]