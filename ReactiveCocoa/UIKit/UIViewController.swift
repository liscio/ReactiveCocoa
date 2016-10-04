//
//  UIViewController.swift
//  Rex
//
//  Created by Rui Peres on 14/04/2016.
//  Copyright © 2016 Neil Pankey. All rights reserved.
//

import ReactiveSwift
import Result
import UIKit

extension Reactivity where Reactant: UIViewController {
	/// Returns a `Signal`, that will be triggered
	/// when `self`'s `viewDidDisappear` is called
	public var viewDidDisappear: Signal<(), NoError> {
		return reactant.trigger(for: #selector(UIViewController.viewDidDisappear(_:)))
	}

	/// Returns a `Signal`, that will be triggered
	/// when `self`'s `viewWillDisappear` is called
	public var viewWillDisappear: Signal<(), NoError> {
		return reactant.trigger(for: #selector(UIViewController.viewWillDisappear(_:)))
	}

	/// Returns a `Signal`, that will be triggered
	/// when `self`'s `viewDidAppear` is called
	public var viewDidAppear: Signal<(), NoError> {
		return reactant.trigger(for: #selector(UIViewController.viewDidAppear(_:)))
	}

	/// Returns a `Signal`, that will be triggered
	/// when `self`'s `viewWillAppear` is called
	public var viewWillAppear: Signal<(), NoError> {
		return reactant.trigger(for: #selector(UIViewController.viewWillAppear(_:)))
	}

	/// A trigger that sends a `next` event upon completion of dismissal of
	/// the presented view controller.
	public var dismissedPresented: Signal<(), NoError> {
		return reactant.trigger(for: #selector(UIViewController.dismiss(animated:completion:)))
	}
}
