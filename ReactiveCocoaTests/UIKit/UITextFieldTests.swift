//
//  UITextFieldTests.swift
//  Rex
//
//  Created by Rui Peres on 17/01/2016.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import ReactiveCocoa
import UIKit
import XCTest

class UITextFieldTests: XCTestCase {
	func testTextProperty() {
		let expectation = self.expectation(description: "Expected `rac_text`'s value to equal to the textField's text")
		defer { self.waitForExpectations(timeout: 2, handler: nil) }

		let textField = UITextField(frame: CGRect.zero)
		textField.text = "Test"

		textField.rac.text.observeValues { text in
			XCTAssertEqual(text, textField.text)
			expectation.fulfill()
		}

		textField.sendActions(for: .editingDidEnd)
	}

	func testLiveTextProperty() {
		let expectation = self.expectation(description: "Expected `rac_text`'s value to equal to the textField's text")
		defer { self.waitForExpectations(timeout: 2, handler: nil) }

		let textField = UITextField(frame: CGRect.zero)
		textField.text = "Test"

		textField.rac.liveText.observeValues { text in
			XCTAssertEqual(text, textField.text)
			expectation.fulfill()
		}

		textField.sendActions(for: .editingChanged)
		
	}
}
