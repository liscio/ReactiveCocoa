//
//  UISwitch.swift
//  Rex
//
//  Created by David Rodrigues on 07/04/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit

extension Reactivity where Reactant: UISwitch {
	/// Wraps a switch's `on` value in a bindable property.
	public var isOn: ControlSubject<Bool> {
		return ControlSubject(signal: trigger(for: .valueChanged).map { [unowned reactant] in reactant.isOn },
		                      target: makeBindingTarget { $0.isOn = $1 })
	}
}
