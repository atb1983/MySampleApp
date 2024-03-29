//
//  NetworkManagerProtocol.swift
//  MySampleApp
//
//  Created by Alex Núñez on 15/06/2019.
//  Copyright © 2019 All rights reserved.
//

import Foundation

public protocol NetworkManagerProtocol {
	typealias NetworkManagerCompleteHandler = ( Result<Data, NetworkError> ) -> Void
	
	init(networkModel: NetworkModelProtocol, session: URLSessionProtocol)
	func execute(completionHandler: @escaping NetworkManagerCompleteHandler)
	func handleServerResponse(data: Data?, response: URLResponse?, error: Error?, completionHandler: NetworkManagerCompleteHandler)
}
