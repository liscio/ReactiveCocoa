//
//  UITextField.swift
//  Rex
//
//  Created by Rui Peres on 17/01/2016.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit

extension Reactivity where Reactant: UITextField {
	/// Wraps a textField's `text` value in a bindable property.
	public var text: MutablePropertyFacade<String?> {
		let getter: (UITextField) -> String? = { $0.text }
		let setter: (UITextField, String?) -> () = { $0.text = $1 }

		return makePropertyProxy(getter: getter, setter: setter)
	}

}

private var textKey: UInt8 = 0
