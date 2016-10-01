//
//  UISegmentedControl.swift
//  Rex
//
//  Created by Markus Chmelar on 07/06/16.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit

extension Reactivity where Reactant: UISegmentedControl {
	/// Wraps a segmentedControls `selectedSegmentIndex` state in a bindable property.
	public var selectedSegmentIndex: MutablePropertyFacade<Int> {
		return makePropertyProxy(getter: { $0.selectedSegmentIndex },
		                         setter: { $0.selectedSegmentIndex = $1 })
	}
}
