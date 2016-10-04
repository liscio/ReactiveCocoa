//
//  UITextView.swift
//  Rex
//
//  Created by Rui Peres on 05/04/2016.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit
import enum Result.NoError

extension Reactivity where Reactant: UITextView {
	/// Sends the textView's string value whenever it changes.
	public var text: ControlSubject<String> {
		var signal: Signal<String, NoError>!

		NotificationCenter.default
			.rac_notifications(forName: .UITextViewTextDidChange, object: reactant)
			.take(during: reactant.rac.lifetime)
			.map { ($0.object as! UITextView).text! }
			.startWithSignal { innerSignal, _ in signal = innerSignal }

		return ControlSubject(signal: signal,
		                      target: makeBindingTarget { $0.text = $1 })
	}
}
