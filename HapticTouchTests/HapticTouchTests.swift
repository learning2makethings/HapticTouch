//
//  HapticTouchTests.swift
//  HapticTouchTests
//
//  Created by Allen on 3/29/19.
//  Copyright © 2019 Coding Buddies. All rights reserved.
//

import XCTest
@testable import HapticTouch

class HapticTouchTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMetronome() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let m = Metronome(bpm: 60, supportsImpactGenerator: true)
        
        XCTAssertEqual(60, m.bpm)
        XCTAssertFalse(m.isRunning(), "Metronome shouldn't be running on init")
        
        // testing start and stop
        m.stop()
        XCTAssertFalse(m.isRunning())
        
        m.start()
        XCTAssertTrue(m.isRunning())
        
        m.start()
        XCTAssertTrue(m.isRunning())
        
        // testing toggle
        m.toggle()
        XCTAssertFalse(m.isRunning())
        
        m.toggle()
        XCTAssertTrue(m.isRunning())
        
        m.toggle()
        XCTAssertFalse(m.isRunning())
        
        // testing setBPM
        m.setBPM(to: 100)
        XCTAssertEqual(100, m.bpm)
        
        m.setBPM(to: 0)
        XCTAssertEqual(100, m.bpm, "You shouldn't be able to change the speed to 0bpm")
        
        m.setBPM(to: 100)
        m.setBPM(to: -20)
        XCTAssertEqual(100, m.bpm, "Negative bpm aren't a thing")
    }

    func testPerformanceMetronome() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
