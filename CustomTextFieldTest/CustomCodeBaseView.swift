//
//  CustomTextField.swift
//  CustomTextFieldTest
//
//  Created by Jun Morita on 2022/12/15.
//

import SwiftUI
import UIKit

struct CustomCodeBaseView: View {
    private var textFieldSize: CGSize = .zero
    private var action: ((Int) -> Void)?
    
    private let labelSpacing: CGFloat = 16
    private let labelWidth: CGFloat = 44
    private let labelHeight: CGFloat = 70
    private let codeCount: Int = 6

    @State private var fields: [LabelState]
    @State private var insertCode = ""
    @State private var isTextFieldFocused = false
    
    init() {
        let width = (labelWidth * CGFloat(codeCount)) + (labelSpacing * CGFloat(codeCount - 1))
        self.textFieldSize = CGSize(width: width, height: labelHeight)
        fields = Array(repeating: .empty, count: codeCount)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: labelSpacing) {
            ForEach(fields) { state in
                Text(state.textLabel)
                    .font(.body)
                    .foregroundColor(.black)
                    .frame(width: labelWidth, height: labelHeight, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.secondary))
            }
        }
        .background(Rectangle().foregroundColor(.white))
        .background(CustomTextField(text: $insertCode, isFocusable: $isTextFieldFocused, labels: codeCount))
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused.toggle()
        }
        .frame(width: textFieldSize.width, height: textFieldSize.height)
        .onChange(of: insertCode) { newValue in
            if !newValue.isEmpty {
                let tmp = newValue.map { LabelState.field(text: "\($0)") }
                fields = tmp + Array(repeating: .empty, count: codeCount - newValue.count)
            } else {
                fields = Array(repeating: .empty, count: codeCount)
            }
            action?(newValue.count)
        }
        
    }
}

enum LabelState: Identifiable {
    var id: UUID {
        UUID()
    }
    
    case empty
    case field(text: String)
    
    var textLabel: String {
        switch self {
        case .field(let text):
            return text
        case .empty:
            return "-"
        }
    }
}

extension CustomCodeBaseView {
    func onCodeField(perform action: ((Int) -> Void)?) -> Self {
        var copy = self
        copy.action = action
        return copy
    }
}

struct CustomCodeBaseView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCodeBaseView()
    }
}

struct CustomTextField: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var isFocusable: Bool
    let labels: Int

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.tintColor = .clear
        return textField
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, labels: labels)
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFocusable {
            if !uiView.isFirstResponder {
                DispatchQueue.main.async {
                    uiView.becomeFirstResponder()
                }
            }
        } else {
            DispatchQueue.main.async {
                uiView.resignFirstResponder()
            }
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var labels: Int
        
        init(text: Binding<String>, labels: Int) {
            _text = text
            self.labels = labels
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            true
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
            
            guard string.isNumeric || string.count == 0 else  { return false}
            
            if string.count > 1 && string.count > labels {
                let index = string.index(string.startIndex, offsetBy: labels)
                textField.text = String(string.prefix(upTo: index))
                return false
            } else if string.count == 0 {
                if range.length > 1 {
                    textField.text = ""
                    return false
                } else if range.length == 1 {
                    let newString = textField.text?.dropLast()
                    textField.text = String(newString ?? "")
                    return false
                } else if range.length == 0 {
                    return true
                }
            }
            
            let newLength = text.count + string.count - range.length
            return newLength <= labels
        }
    }
    
    
    
}

extension String {
    var isNumeric: Bool {
        guard !self.isEmpty else { return false }
        return CharacterSet(charactersIn: self).isSubset(of: CharacterSet.decimalDigits)
    }
}
