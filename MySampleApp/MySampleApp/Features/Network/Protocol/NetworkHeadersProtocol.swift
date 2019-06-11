//
//  NetworkHeadersProtocol.swift
//  MySampleApp
//
//  Created by Alex Núñez on 08/06/2019.
//  Copyright © 2019 Touchsoft. All rights reserved.
//

import Foundation

protocol NetworkHeadersProtocol {
	var headers: [String: String] { get }
}