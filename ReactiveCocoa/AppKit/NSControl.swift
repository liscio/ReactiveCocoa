//
//  NSControl.swift
//  ReactiveCocoa
//
//  Created by Christopher Liscio on 2016-10-06.
//  Copyright © 2016 GitHub. All rights reserved.
//

import ReactiveSwift
import AppKit
import enum Result.NoError

extension Reactivity where Reactant: NSControl {
	/// Accepts values to modify the enabled state of the control
	public var isEnabled: BindingTarget<Bool> {
		return makeBindingTarget { $0.isEnabled = $1 }
	}
}
