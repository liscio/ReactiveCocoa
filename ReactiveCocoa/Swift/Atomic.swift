//
//  Atomic.swift
//  ReactiveCocoa
//
//  Created by Justin Spahr-Summers on 2014-06-10.
//  Copyright (c) 2014 GitHub. All rights reserved.
//

import Foundation

/// An atomic variable.
public final class Atomic<Value> {
	private var _attribute = pthread_mutexattr_t()
	private var _mutex = pthread_mutex_t()
	private var _value: Value
	
	/// Atomically gets or sets the value of the variable.
	public var value: Value {
		get {
			return withValue { $0 }
		}
	
		set(newValue) {
			modify { _ in newValue }
		}
	}
	
	/// Initializes the variable with the given initial value.
	public init(_ value: Value) {
		pthread_mutexattr_init(&_attribute)
		pthread_mutexattr_settype(&_attribute, PTHREAD_MUTEX_RECURSIVE)
		pthread_mutex_init(&_mutex, &_attribute)

		_value = value
	}
	
	deinit {
		pthread_mutexattr_destroy(&_attribute)
		pthread_mutex_destroy(&_mutex)
	}
	
	private func lock() {
		pthread_mutex_lock(&_mutex)
	}
	
	private func unlock() {
		pthread_mutex_unlock(&_mutex)
	}
	
	/// Atomically replaces the contents of the variable.
	///
	/// Returns the old value.
	public func swap(newValue: Value) -> Value {
		return modify { _ in newValue }
	}

	/// Atomically modifies the variable.
	///
	/// Returns the old value.
	public func modify(@noescape action: (Value) throws -> Value) rethrows -> Value {
		lock()
		defer { unlock() }

		let oldValue = _value
		_value = try action(_value)
		return oldValue
	}
	
	/// Atomically performs an arbitrary action using the current value of the
	/// variable.
	///
	/// Returns the result of the action.
	public func withValue<Result>(@noescape action: (Value) throws -> Result) rethrows -> Result {
		lock()
		defer { unlock() }

		return try action(_value)
	}
}
