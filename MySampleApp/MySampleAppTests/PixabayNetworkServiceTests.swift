//
//  PixabayNetworkServiceTests.swift
//  MySampleAppTests
//
//  Created by Alex Núñez on 15/06/2019.
//  Copyright © 2019 All rights reserved.
//

import Foundation
import XCTest

@testable import MySampleApp

class PixabayNetworkServiceTests: XCTestCase {
	
	var mockPixabayNetworkService: MockPixabayNetworkService!
	var hitsIterator: HitsInteractor!
	var mockJson: Data?
	
	override func setUp() {
		super.setUp()
		
		mockPixabayNetworkService =  MockPixabayNetworkService()
		
		// Mock JSON file
		generateMockResponseModel()
	}
	
	private func generateMockResponseModel() {
		guard let ressourceURL = Bundle(for: type(of: self)).url(forResource: "PixabayHitsResponseModel", withExtension: "json"),
			let resourceData = try? Data(contentsOf: ressourceURL) else {
				XCTFail("PixabayHitsResponseModel.json file doesn't exist or it's invalid")
				return
		}
		
		mockJson = resourceData
	}
	
	override func tearDown() {
		super.tearDown()
		mockPixabayNetworkService = nil
		hitsIterator = nil
		mockJson = nil
	}
	
	func test_getHits_withData_shouldNotBeEmpty() {
		let expectation = XCTestExpectation(description: "Shouldn't be empty")
		
		mockPixabayNetworkService.session.nextData = mockJson
		mockPixabayNetworkService.getHits { (result) in
			switch result {
			case .success(let hits):
				XCTAssertNotNil(hits, "The data is empty")
				expectation.fulfill()
			case .failure(_):
				XCTFail("It shouldn't return an error")
			}
		}
		
		wait(for: [expectation], timeout: 3.0)
	}
	
	func test_getHits_withData_shouldHave3Items() {
		let expectation = XCTestExpectation(description: "Should return 3 items")
		
		mockPixabayNetworkService.session.nextData = mockJson
		
		mockPixabayNetworkService.getHits { (result) in
			switch result {
			case .success(let data):
				XCTAssertEqual(data.count, 3, "The return item is diferent than 3")
				expectation.fulfill()
			case .failure(_):
				XCTFail("It shouldn't return an error")
			}
		}
		
		wait(for: [expectation], timeout: 3.0)
	}
	
	func test_fetchHits_withNoata() {
		let expectation = XCTestExpectation(description: "Shouldn't return data")
		
		mockPixabayNetworkService.getHits { (result) in
			switch result {
			case .success(let data):
				XCTAssertNil(data, "Data should be nil")
			case .failure(let error):
				if error == NetworkError.emptyData {
					expectation.fulfill()
				} else {
					XCTFail("fetchHits is returning a different error than empty data")
				}
			}
		}
		
		wait(for: [expectation], timeout: 3.0)
	}
	
	func test_fetchHits_withError() {
		let expectation = XCTestExpectation(description: "Shouldn't return data")
		
		mockPixabayNetworkService.session.nextError = NetworkError.apiError(error: NetworkError.unknownError)
		
		mockPixabayNetworkService.getHits { (result) in
			switch result {
			case .success(let data):
				XCTAssertNil(data, "Data should be nil")
			case .failure(let error):
				if error == NetworkError.apiError(error: NetworkError.unknownError) {
					expectation.fulfill()
				} else {
					XCTFail("fetchHits is returning a different error than apiError")
				}
			}
		}
		
		wait(for: [expectation], timeout: 3.0)
	}
	
}

