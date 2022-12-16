//
//  CodeStyle.swift
//  CustomTextFieldTest
//
//  Created by Jun Morita on 2022/12/15.
//

import Foundation
import SwiftUI

struct Styles {
    static let defaultStyle = CodeStyle(labelWidth: 20, labelHeight: 30, labelSpacing: 15, textColor: .black)
}

class CodeStyle {
    let labelWidth: CGFloat
    let labelHeight: CGFloat
    let labelSpacing: CGFloat
    let textColor: Color
    
    init(labelWidth: CGFloat, labelHeight: CGFloat, labelSpacing: CGFloat, textColor: Color) {
        self.labelWidth = labelWidth
        self.labelHeight = labelHeight
        self.labelSpacing = labelSpacing
        self.textColor = textColor
    }
    
}
