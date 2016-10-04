//
//  UIDatePicker.swift
//  Rex
//
//  Created by Guido Marucci Blas on 3/25/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit

extension Reactivity where Reactant: UIDatePicker {
	// Wraps a datePicker's `date` value in a bindable property.
	public var date: ControlSubject<Date> {
		return ControlSubject(signal: trigger(for: .valueChanged).map { [unowned reactant] in reactant.date },
		                      target: makeBindingTarget { $0.date = $1 })
	}
}
