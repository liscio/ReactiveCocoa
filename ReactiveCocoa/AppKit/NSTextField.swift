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
	public var text: ControlSubject<String> {
		var signal: Signal<String, NoError>!

		NotificationCenter.default
			.rac_notifications(forName: .NSControlTextDidChange, object: reactant)
			.take(during: lifetime)
			.map { ($0.object as! NSTextField).stringValue }
			.startWithSignal { innerSignal, _ in signal = innerSignal }

		return ControlSubject(signal: signal,
		                      target: makeBindingTarget { $0.stringValue = $1 })
	}
}
