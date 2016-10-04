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
	public var text: ControlSubject<String?> {
		return ControlSubject(signal: trigger(for: .editingDidEnd).map { [unowned reactant] in reactant.text },
		                      target: makeBindingTarget { $0.text = $1 })
	}

	public var liveText: ControlSubject<String?> {
		return ControlSubject(signal: trigger(for: .editingChanged).map { [unowned reactant] in reactant.text },
		                      target: makeBindingTarget { $0.text = $1 })
	}
}
