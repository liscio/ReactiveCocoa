//
//  NSTextField.swift
//  Rex
//
//  Created by Yury Lapitsky on 7/8/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import AppKit
import enum Result.NoError

extension Reactivity where Reactant: NSTextField {
	/// Make user-visible changes to the control's stringValue
	public var stringValue: BindingTarget<String> {
		return makeBindingTarget { $0.stringValue = $1 }
	}

	public var value: BindingTarget<BindingValue<String>> {
		return makeBindingTarget {
			switch $1 {
			case let .value(v):
				$0.stringValue = v
			default:
				// The placeholderString is only shown if the string value is cleared on the control
				if #available(OSX 10.10, *) {
					$0.stringValue = ""
					$0.placeholderString = $1.formatString({ _ in return "" })
				} else {
					// TODO: Below 10.10, we must also manipulate the string color/etc.
					$0.stringValue = $1.formatString({ _ in return "" })
				}
			}
		}
	}

	/// Provides changes to the control's stringValue, supplying new values when
	/// the user concludes editing.
	///
	/// - note: If you require continuous updates as the user is typing, use
	///         `continuousStringValue` instead.
	public var stringValues: Signal<String, NoError> {
		var signal: Signal<String, NoError>!

		NotificationCenter.default
			.rac_notifications(forName: .NSControlTextDidEndEditing, object: reactant)
			.take(during: lifetime)
			.map { ($0.object as! NSTextField).stringValue }
			.startWithSignal { innerSignal, _ in signal = innerSignal }

		return signal
	}

	/// Provides continuous changes to the control's stringValue, supplying new
	/// values as the user types text.
	public var continuousStringValue: Signal<String, NoError> {
		var signal: Signal<String, NoError>!

		NotificationCenter.default
			.rac_notifications(forName: .NSControlTextDidChange, object: reactant)
			.take(during: lifetime)
			.map { ($0.object as! NSTextField).stringValue }
			.startWithSignal { innerSignal, _ in signal = innerSignal }

		return signal
	}
}
