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
