import ReactiveSwift
import enum Result.NoError

/// A facade that conforms to `MutablePropertyProtocol`.
public final class MutablePropertyFacade<Value>: MutablePropertyProtocol {
	private let get: () -> Value
	private let set: (Value) -> Void
	private let scheduler: SchedulerProtocol?

	public let lifetime: Lifetime

	public var producer: SignalProducer<Value, NoError> {
		return SignalProducer(signal: signal).prefix(value: get())
	}

	public let signal: Signal<Value, NoError>

	public var value: Value {
		get { return get() }
		set {
			if let scheduler = scheduler {
				scheduler.schedule { self.set(newValue) }
			} else {
				set(newValue)
			}
		}
	}

	public init(
		get: @escaping () -> Value,
		set: @escaping (Value) -> Void,
		changes signal: Signal<Value, NoError>,
		lifetime: Lifetime,
		setOn scheduler: SchedulerProtocol?
	) {
		self.get = get
		self.set = set
		self.signal = signal
		self.lifetime = lifetime
		self.scheduler = scheduler
	}

	public static func <~ <S: SignalProtocol>(target: MutablePropertyFacade, source: S) -> Disposable? where S.Value == Value, S.Error == NoError {
		return source.signal
			.take(during: target.lifetime)
			.observeValues { [scheduler = target.scheduler, set = target.set] newValue in
				if let scheduler = scheduler {
					scheduler.schedule { set(newValue) }
				} else {
					set(newValue)
				}
			}
	}
}
