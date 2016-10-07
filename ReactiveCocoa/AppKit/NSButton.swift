//
//  NSButton.swift
//  ReactiveCocoa
//
//  Created by Christopher Liscio on 2016-10-07.
//  Copyright © 2016 GitHub. All rights reserved.
//

import ReactiveSwift
import AppKit
import enum Result.NoError

extension Reactive where Base: NSButton {
	public var boolStateValue: BindingTarget<BindingValue<Bool>> {
		return makeBindingTarget {
			switch $1 {
			case let .value(v):
				$0.state = v ? NSOnState : NSOffState
			case .multipleValues:
				$0.state = $0.allowsMixedState ? NSMixedState : NSOnState
			default:
				$0.state = NSOffState
			}
		}
	}

	public var stateValue: BindingTarget<BindingValue<Int>> {
		return makeBindingTarget {
			switch $1 {
			case let .value(v):
				$0.state = v
			case .multipleValues:
				$0.state = $0.allowsMixedState ? NSMixedState : NSOnState
			default:
				$0.state = NSOffState
			}
		}
	}
}
