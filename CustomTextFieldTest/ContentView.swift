//
//  ContentView.swift
//  CustomTextFieldTest
//
//  Created by Jun Morita on 2022/12/15.
//

import SwiftUI

struct ContentView: View {
    @State private var isDisable = false
    
    var body: some View {
        VStack {
            CustomCodeBaseView()
                .onCodeField(perform: { codeCount in
                    isDisable = codeCount > 0
                })
                .padding(.horizontal, 16)
            
            Button(action: {
            }, label: {
                Text("テスト")
                    .foregroundColor(isDisable ? .blue : .black)
                    .disabled(isDisable)
            })
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
