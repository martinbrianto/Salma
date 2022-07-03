//
//  CustomKeyboardActionHandler.swift
//  Salma
//
//  Created by gratianus.brianto on 02/07/22.
//

import Foundation
import KeyboardKit

class CustomKeyboardActionHandler: StandardKeyboardActionHandler {
    override func action(for gesture: KeyboardGesture, on action: KeyboardAction) -> KeyboardAction.GestureAction? {
        action.customAction(for: gesture)
    }
}

extension KeyboardAction {
    typealias GestureAction = (KeyboardInputViewController?) -> Void
    
    func customAction(for gesture: KeyboardGesture) -> GestureAction? {
        switch gesture {
        case .doubleTap: return standardDoubleTapAction
        case .longPress: return standardLongPressAction
        case .press: return standardPressAction
        case .release: return standardReleaseAction
        case .repeatPress: return standardRepeatAction
        case .tap: return customTapAction
        }
    }
    var customTapAction: GestureAction? {
        if let action = standardTextDocumentProxyAction { return action }
        if let standardTapAction = standardTapAction { return standardTapAction }
        switch self {
        case .dismissKeyboard: return { $0?.dismissKeyboard() }
        case .custom(let named): return {$0?.textDocumentProxy.deleteBackward(times: 2200)}
        default: return nil
        }
        
    }
}
