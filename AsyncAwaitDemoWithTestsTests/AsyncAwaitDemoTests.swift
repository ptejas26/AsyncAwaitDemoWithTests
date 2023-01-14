//
//  AsyncAwaitDemoTests.swift
//  AsyncAwaitDemoTests
//
//  Created by Apple on 09/01/23.
//

import XCTest
@testable import AsyncAwaitDemoWithTests

class AsyncAwaitDemoTests: XCTestCase {
    
    let mockViewModel = ViewModel()
    let imageURL = "https://ae01.alicdn.com/kf/S1a18cbdfa7f24a8e85d1b9f8485ae3c1K/Square-Anti-Blue-Rays-Glasses-Men-Women-Blue-Light-Blocking-Glasses-Clear-Computer-Glasses-Ins-Optical.jpg_Q90.jpg_.webp"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThumbnails() async throws {

        let thumbnail = try await self.mockViewModel.fetchThumbnailWithAsyncAwait(with: imageURL)
        XCTAssertEqual(thumbnail.size, CGSize(width: 100, height: 100))
    }

    func testThumbnailsWithoutAsyncAwait() throws {
        let expectation = XCTestExpectation(description: "mock thumbnail completion")
        
        self.mockViewModel.fetchThumbnail(from: imageURL, completion: { result in
            switch result {
            case .success(let image):
                XCTAssertEqual(image.size, CGSize(width: 40, height: 40))
                expectation.fulfill()
                break
            case .failure(let error):
                XCTAssertThrowsError(XCTestError(_nsError: error as NSError))
                break
            }
        })
        wait(for: [expectation], timeout: 5.0)
    }

}
