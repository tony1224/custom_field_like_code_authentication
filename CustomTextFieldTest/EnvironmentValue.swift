//
//  EnvironmentValue.swift
//  CustomTextFieldTest
//
//  Created by Jun Morita on 2022/12/15.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var codeStyle: CodeStyle {
        get { return self[CodeStyleKey.self] }
        set { self[CodeStyleKey.self] = newValue }
    }
}

struct CodeStyleKey: EnvironmentKey {
    static let defaultValue: CodeStyle = Styles.defaultStyle
}
