//
//  UISwitchTests.swift
//  Rex
//
//  Created by David Rodrigues on 07/04/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import XCTest
import ReactiveSwift
import ReactiveCocoa
import Result

class UISwitchTests: XCTestCase {

	func testOnProperty() {
		let toggle = UISwitch(frame: CGRect.zero)
		toggle.isOn = false

		let (pipeSignal, observer) = Signal<Bool, NoError>.pipe()
		toggle.rac.isOn <~ SignalProducer(signal: pipeSignal)

		observer.send(value: true)
		XCTAssertTrue(toggle.isOn)
		observer.send(value: false)
		XCTAssertFalse(toggle.isOn)

		var latestValue: Bool?
		toggle.rac.isOn.observeValues { latestValue = $0 }

		toggle.isOn = true
		toggle.sendActions(for: .valueChanged)
		XCTAssertTrue(latestValue!)
	}
}
