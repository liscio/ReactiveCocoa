import ReactiveSwift
import enum Result.NoError

/// Represents a subject of an interactive control.
///
/// Generally speaking, `ControlSubject` emits changes only for the user
/// interactions in which the subject specializes.
public final class ControlSubject<Value> {
	fileprivate let target: BindingTarget<Value>

	/// The signal of the control subject.
	public let signal: Signal<Value, NoError>

	/// The lifetime of the control.
	public var lifetime: Lifetime {
		return target.lifetime
	}

	/// Create a control subject.
	///
	/// - parameters:
	///   - signal: The signal of the subject.
	///   - target: The binding target of the subject.
	internal init(signal: Signal<Value, NoError>, target: BindingTarget<Value>) {
		self.signal = signal
		self.target = target
	}
}

extension ControlSubject: BindingTargetProtocol {
	public func consume(_ value: Value) {
		target.consume(value)
	}

	public static func <~ <S: SignalProtocol>(target: ControlSubject, source: S) -> Disposable? where S.Value == Value, S.Error == NoError {
		return target.target <~ source
	}
}

extension ControlSubject: SignalProtocol {
	public func observe(_ observer: Observer<Value, NoError>) -> Disposable? {
		return signal.observe(observer)
	}
}
