//
//  ErrorHandler.swift
//  MiniCompiler
//
//  Created by Ethan Kusters on 4/12/20.
//  Copyright © 2020 Ethan Kusters. All rights reserved.
//

import Foundation

protocol ErrorHandler {
    func report (_ typeError: TypeError)
}
