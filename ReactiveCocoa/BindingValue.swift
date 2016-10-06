//
//  BindingValue.swift
//  FuzzMeasure
//
//  Created by Christopher Liscio on 2015-12-12.
//  Copyright © 2015 SuperMegaUltraGroovy, Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import enum Result.NoError

/// Represents a value to be bound to a UI control, including common placeholders for empty or multiple selections.
public enum BindingValue<ValueType> {
    /// A placeholder to represent the "No Selection" case
    case noSelection
    
    /// A placeholder to represent the "Multiple Values" case
    case multipleValues
    
    /// The value to be displayed by the control
    case value(ValueType)
    
    /// Map the value to another (possibly differently typed) value using the supplied closure
    public func map<U>(_ transform: ((ValueType)->U)) -> BindingValue<U> {
        switch self {
        case let .value(v):
            return .value(transform(v))
        case .noSelection:
            return .noSelection
        case .multipleValues:
            return .multipleValues
        }
    }
    
    /// Format the value's string using the specified formatter. (Note that you can also use `map` to achieve the same thing.)
    public func formatString(_ formatter: (ValueType) -> String) -> String {
        switch self {
        case .value(let v):
            return formatter(v)
        default:
            return description
        }
    }
    
    /// Returns whether this `BindingValue` instance represents a placeholder
    public var isPlaceholder: Bool {
        switch self {
            case .value:
                return false
            default:
                return true
        }
    }
}

extension BindingValue : CustomStringConvertible {
    public var description: String {
        switch self {
        case .value(let v):
            if let printableValue = v as? CustomStringConvertible {
                return String.localizedStringWithFormat(NSLocalizedString("Value(%@)", comment: "Debug value display"), printableValue.description)
            }
            else {
                return NSLocalizedString("Value(no description)", comment: "Debug value display for non-CustomStringConvertible type")
            }
        case .noSelection:
            return NSLocalizedString("No Selection", comment: "No selection placeholder")
        case .multipleValues:
            return NSLocalizedString("Multiple Values", comment: "Multiple values placeholder")
        }
    }
}

public extension BindingValue where ValueType : Equatable {
    /// Initializes a binding value with the default behavior for arrays of values. That is, an empty array becomes .NoSelection, an array with more than one non-matching element is .MultipleValues, and the .Value itself otherwise.
    public init(values: [ValueType]) {
        if values.isEmpty {
            self = BindingValue.noSelection
        }
        else if values.count == 1 {
            self = BindingValue.value(values.first!)
        }
        else {
            let firstValue = values.first!
            let allEqual = values.suffix(from: 1).reduce(true) { $0 && ($1 == firstValue) }
            if allEqual {
                self = BindingValue.value(firstValue)
            }
            else {
                self = BindingValue.multipleValues
            }
        }
    }
}

extension PropertyProtocol where Value: OptionalProtocol {	
	/// Maps each property from `self` to a new property, then flattens the
	/// resulting properties (into a single property), according to the
	/// semantics of the given strategy.
	///
	/// - parameters:
	///   - strategy: The preferred flatten strategy.
	///   - transform: The transform to be applied on `self` before flattening.
	///
	/// - returns: A property that sends the values of its inner properties.
	public func flatMap<P: PropertyProtocol, T: Equatable>(_ strategy: FlattenStrategy, transform: @escaping (Value.Wrapped) -> P) -> Property<BindingValue<T>> where P.Value == BindingValue<T> {
		return self.flatMap(strategy) { (myValue: Value) -> Property<BindingValue<T>> in
			switch myValue.optional {
			case let .some(value):
				return Property(transform(value))
			default:
				return Property(value: .noSelection)
			}
		}
	}
}
