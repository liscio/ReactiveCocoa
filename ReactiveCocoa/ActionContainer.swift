import ReactiveSwift

internal final class ActionContainer: NSObject {
	/// The selector that a caller should invoke upon a CocoaAction in order to
	/// execute it.
	internal static let selector: Selector = #selector(CocoaAction.execute(_:))

	private let _execute: (AnyObject?) -> Void

	/// Initializes a Cocoa action that will invoke the given Action by
	/// transforming the object given to execute().
	///
	/// - note: You must cast the passed in object to the control type you need
	///         since there is no way to know where this cocoa action will be
	///         added as a target.
	///
	/// - parameters:
	///   - action: Executable action.
	///   - inputTransform: Closure that accepts the UI control performing the
	///                     action and returns a value (e.g.
	///                     `(UISwitch) -> (Bool)` to reflect whether a provided
	///                     switch is currently on.
	internal init<Input, Output, Error>(_ action: Action<Input, Output, Error>, _ inputTransform: @escaping (AnyObject?) -> Input) {
		self._execute = { [weak action] input in
			let producer = action?.apply(inputTransform(input))
			producer?.start()
		}

		super.init()
	}

	/// Attempts to execute the underlying action with the given input, subject
	/// to the behavior described by the initializer that was used.
	///
	/// - parameters:
	///   - input: A value for the action passed during initialization.
	@objc fileprivate func execute(_ input: AnyObject?) {
		_execute(input)
	}
}
