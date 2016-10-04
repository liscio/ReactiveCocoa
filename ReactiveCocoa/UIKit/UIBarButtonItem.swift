//
//  UIBarButtonItem.swift
//  Rex
//
//  Created by Bjarke Hesthaven Søndergaard on 24/07/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit

extension Reactivity where Reactant: UIBarButtonItem {
	private var associatedAction: Atomic<ActionContainer?> {
		return associatedObject(reactant,
		                        key: &associatedActionKey,
		                        initial: { _ in Atomic(nil) })
	}

	public func setAction<Input, Output, Error>(_ action: Action<Input, Output, Error>, inputTransform: @escaping (Reactant) -> Input) {
		associatedAction.modify { associatedAction in
			let container = ActionContainer(action) { sender in
				return inputTransform(sender as! Reactant)
			}

			reactant.target = container
			reactant.action = ActionContainer.selector
			associatedAction = container
		}
	}

	public func setAction<Output, Error>(_ action: Action<(), Output, Error>) {
		setAction(action, inputTransform: { _ in })
	}

	public func removeAction() {
		associatedAction.modify { associatedAction in
			if associatedAction != nil {
				reactant.target = nil
				reactant.action = nil
				associatedAction = nil
			}
		}
	}
}

private var associatedActionKey = 0
