//
//  NSPopUpButton.swift
//  ReactiveCocoa
//
//  Created by Christopher Liscio on 2016-10-07.
//  Copyright © 2016 GitHub. All rights reserved.
//

import Foundation

import ReactiveSwift
import AppKit
import enum Result.NoError

extension Reactive where Base: NSPopUpButton {

	public var menuItems: BindingTarget<BindingValue<[NSMenuItem]>> {
		return makeBindingTarget { base, value in
			switch value {
			case let .value(v):
				base.removeAllItems()
				v.forEach { base.menu?.addItem($0) }
			default:
				base.displayPlaceholder(value)
			}
		}
	}

	public var selectedIndex: BindingTarget<BindingValue<Int>> {
		return makeBindingTarget { button, value in
			switch value {
			case let .value(v):
				button.selectItem(at: v)
				(button.cell as? NSPopUpButtonCell)?.menuItem = button.itemArray[v]
				button.synchronizeTitleAndSelectedItem()
			default:
				button.displayPlaceholder(value)
			}
		}
	}

	public var rex_selectedTagBinding: BindingTarget<BindingValue<Int>> {
		return makeBindingTarget { button, value in
			switch value {
			case let .value(v):
				button.selectItem(withTag: v)
			default:
				button.displayPlaceholder(value)
			}
		}
	}

	public var menuItem: BindingTarget<BindingValue<NSMenuItem>> {
		return makeBindingTarget { button, value in
			switch value {
			case let .value(v):
				(button.cell as? NSPopUpButtonCell)?.menuItem = v
			default:
				button.displayPlaceholder(value)
			}
		}
	}
}

fileprivate extension NSPopUpButton {
	/// Displays the placeholder text for the provided value.
	///
	/// - precondition: `placeholder` must specify a placeholder `BindingValue`
	fileprivate func displayPlaceholder<T>(_ placeholder: BindingValue<T>) {
		precondition(placeholder.isPlaceholder, "displayPlaceholder must be called with a placeholder value.")

		let font: NSFont
		if #available(OSXApplicationExtension 10.10, *) {
			font = NSFont.systemFont(ofSize: NSFont.systemFontSize(for: self.controlSize))
		} else {
			// Fallback on earlier versions
			font = NSFont.systemFont(ofSize: NSFont.systemFontSize())
		}

		let placeholder = placeholder.formatString({ _ in return "" })

		let disabledColor: NSColor
		if #available(OSX 10.10, *) {
			disabledColor = NSColor.tertiaryLabelColor
		} else {
			disabledColor = NSColor.black.withAlphaComponent(0.5)
		}

		let attrs: [String : Any] = [NSForegroundColorAttributeName : disabledColor, NSFontAttributeName : font]

		let menuItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
		menuItem.attributedTitle = NSAttributedString(string: placeholder, attributes: attrs)
		(self.cell as? NSPopUpButtonCell)?.menuItem = menuItem
	}
}
