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
	/// Provides and accepts changes to the control's stringValue. 
	///
	/// - note: If you require continuous updates as the user is typing, use
	///         `continuousStringValue` instead.
	public var stringValue: Binding<String> {
		var signal: Signal<String, NoError>!

		NotificationCenter.default
			.rac_notifications(forName: .NSControlTextDidEndEditing, object: reactant)
			.take(during: lifetime)
			.map { ($0.object as! NSTextField).stringValue }
			.startWithSignal { innerSignal, _ in signal = innerSignal }

		return Binding(signal: signal,
		               target: makeBindingTarget { $0.stringValue = $1 })
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
