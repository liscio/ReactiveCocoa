//
//  UIView.swift
//  Rex
//
//  Created by Neil Pankey on 6/19/15.
//  Copyright (c) 2015 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import UIKit
import enum Result.NoError

extension Reactivity where Reactant: UIControl {
	private var associatedAction: Atomic<(container: ActionContainer, events: UIControlEvents)?> {
		return associatedObject(reactant,
		                        key: &associatedActionKey,
		                        initial: { _ in Atomic(nil) })
	}

	public func trigger(for controlEvents: UIControlEvents) -> Signal<(), NoError> {
		return Signal { observer in
			let receiver = UnsafeControlReceiver(observer: observer)
			reactant.addTarget(receiver,
			                   action: #selector(UnsafeControlReceiver.sendNext),
			                   for: controlEvents)

			let disposable = reactant.rac.lifetime.ended.observeCompleted(observer.sendCompleted)

			return ActionDisposable { [weak reactant] in
				disposable?.dispose()
				reactant?.removeTarget(receiver,
				                       action: #selector(UnsafeControlReceiver.sendNext),
				                       for: controlEvents)
			}
		}
	}

	public func setAction<Input, Output, Error>(_ action: Action<Input, Output, Error>, for controlEvents: UIControlEvents, inputTransform: @escaping (Reactant) -> Input) {
		associatedAction.modify { associatedAction in
			if let old = associatedAction {
				reactant.removeTarget(old.container, action: ActionContainer.selector, for: old.events)
			}

			let container = ActionContainer(action) { sender in
				return inputTransform(sender as! Reactant)
			}

			reactant.addTarget(container, action: ActionContainer.selector, for: controlEvents)
			associatedAction = (container, controlEvents)
		}
	}

	public func setAction<Output, Error>(_ action: Action<(), Output, Error>, for controlEvents: UIControlEvents) {
		setAction(action, for: controlEvents, inputTransform: { _ in })
	}

	public func removeAction() {
		associatedAction.modify { associatedAction in
			if let old = associatedAction {
				reactant.removeTarget(old.container, action: ActionContainer.selector, for: old.events)
			}
		}
	}

	/// Wraps a control's `enabled` state in a bindable property.
	public var isEnabled: BindingTarget<Bool> {
		return makeBindingTarget { $0.isEnabled = $1 }
	}

	/// Wraps a control's `selected` state in a bindable property.
	public var isSelected: BindingTarget<Bool> {
		return makeBindingTarget { $0.isSelected = $1 }
	}

	/// Wraps a control's `highlighted` state in a bindable property.
	public var isHighlighted: BindingTarget<Bool> {
		return makeBindingTarget { $0.isHighlighted = $1 }
	}
}

internal class UnsafeControlReceiver: NSObject {
	private let observer: Observer<(), NoError>

	fileprivate init(observer: Observer<(), NoError>) {
		self.observer = observer
	}

	@objc fileprivate func sendNext() {
		observer.send(value: ())
	}
}

private var associatedActionKey = 0
