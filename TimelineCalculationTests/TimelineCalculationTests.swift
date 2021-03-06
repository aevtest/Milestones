//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  TimelineCalculationTests.swift
//  TimelineCalculationTests
//
//  Copyright © 2017 Altay Cebe. All rights reserved.
//

import XCTest
@testable import Milestones


class TimelineCalculationTests: XCTestCase {
    
    var timelineCalculator :TimelineCalculator!
    let dayInterval :TimeInterval = 24*60*60

    override func setUp() {
        super.setUp()
        timelineCalculator = TimelineCalculator()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReferenceDate() {
        
        let xPosition = timelineCalculator.xPositionFor(date: timelineCalculator.referenceDate)
        XCTAssertEqual(0.0, xPosition, accuracy: 0.0)
    }
    
    func testLengthOfOneDay() {

        let nextDay = timelineCalculator.referenceDate.addingTimeInterval(dayInterval)

        let referenceXPosition = timelineCalculator.xPositionFor(date: timelineCalculator.referenceDate)
        let xPosition = timelineCalculator.xPositionFor(date: nextDay)
        
        XCTAssertEqual((xPosition - referenceXPosition), timelineCalculator.lengthOfDay, accuracy: 0.0)
    }
    
    func testLengthOfOneWeek() {
        
        let oneWeekLater = timelineCalculator.referenceDate.addingTimeInterval(dayInterval * TimeInterval(7))
        let referenceXPosition = timelineCalculator.xPositionFor(date: timelineCalculator.referenceDate)
        let xPosition = timelineCalculator.xPositionFor(date: oneWeekLater)
        let lengthOfOneWeek = timelineCalculator.lengthOfDay * CGFloat(7)
        
        XCTAssertEqual((xPosition - referenceXPosition), lengthOfOneWeek, accuracy: 0.0)
    }
    
    func testLengthOfOneYear() {
        
        let dateInRegularYear = Date.dateFor(year: 2013, month: 3, day: 10, hour: 9, minute: 17, second: 12);
        XCTAssertNotNil(dateInRegularYear)
        let dateInLeapYear =  Date.dateFor(year: 2016, month: 7, day: 21, hour: 17, minute: 37, second: 55);
        XCTAssertNotNil(dateInLeapYear)
        
        let regularYearLength = timelineCalculator.lengthOfYear(containing: dateInRegularYear!)
        let leapYearLength =  timelineCalculator.lengthOfYear(containing: dateInLeapYear!)
        
        XCTAssertEqual(regularYearLength, 365.0 * timelineCalculator.lengthOfDay)
        XCTAssertEqual(leapYearLength, 366.0 * timelineCalculator.lengthOfDay)
    }
    
    
    func testDateToPositionConversions() {

        //One day later
        var date = timelineCalculator.referenceDate.addingTimeInterval(dayInterval * 1)
        var positionForDate = timelineCalculator.xPositionFor(date: date)
        var dateForPosition = timelineCalculator.dateForXPosition(position: positionForDate)
        
        XCTAssertEqual(date, dateForPosition)
        
        //some days later
        date = timelineCalculator.referenceDate.addingTimeInterval(dayInterval * 5)
        positionForDate = timelineCalculator.xPositionFor(date: date)
        dateForPosition = timelineCalculator.dateForXPosition(position: positionForDate)

        // more than a month later
        date = timelineCalculator.referenceDate.addingTimeInterval(dayInterval * 40)
        positionForDate = timelineCalculator.xPositionFor(date: date)
        dateForPosition = timelineCalculator.dateForXPosition(position: positionForDate)
        
        XCTAssertEqual(date, dateForPosition)
        
    }
    
    func testDateToPositionConversions2 () {
        let date = timelineCalculator.dateForXPosition(position: 265211).normalized()
        
        let datePosition = timelineCalculator.xPositionFor(date: date)
        let calculatedDate = timelineCalculator.dateForXPosition(position: datePosition)
        
        XCTAssertEqual(date,calculatedDate)
    }
    
    func testCenterPosition() {
        
        let date = Date()
        let xPos = timelineCalculator.xPositionFor(date: date)
        let centerXPos = timelineCalculator.centerXPositionFor(date: date)
        let delta = centerXPos - xPos
        
        XCTAssertEqual(delta, timelineCalculator.lengthOfDay / 2.0)
        
    }
}
