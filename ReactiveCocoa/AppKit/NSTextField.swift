import ReactiveSwift
import AppKit
import enum Result.NoError

extension Reactive where Base: NSTextField {

	/// Provides continuous changes to the control's stringValue, supplying new
	/// values as the user types text.
	public var continuousStringValues: Signal<String, NoError> {
		return NotificationCenter.default
			.reactive
			.notifications(forName: .NSControlTextDidChange, object: base)
			.take(during: lifetime)
			.map { ($0.object as! NSTextField).stringValue }
	}

	/// A signal of values in `NSAttributedString` from the text field upon any
	/// changes.
	public var continuousAttributedStringValues: Signal<NSAttributedString, NoError> {
		return NotificationCenter.default
			.reactive
			.notifications(forName: .NSControlTextDidChange, object: base)
			.take(during: lifetime)
			.map { ($0.object as! NSTextField).attributedStringValue }
	}

	public var value: BindingTarget<BindingValue<String>> {
		return makeBindingTarget {
			switch $1 {
			case let .value(v):
				$0.stringValue = v
			default:
				// The placeholderString is only shown if the string value is cleared on the control
				if #available(OSX 10.10, *) {
					$0.stringValue = ""
					$0.placeholderString = $1.formatString({ _ in return "" })
				} else {
					// TODO: Below 10.10, we must also manipulate the string color/etc.
					$0.stringValue = $1.formatString({ _ in return "" })
				}
			}
		}
	}
}
