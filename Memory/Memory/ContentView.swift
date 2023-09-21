//
//  ContentView.swift
//  Memory
//
//  Created by Anna Rieckmann on 21.09.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            CardView(isFaceUp: false)
            CardView()
            CardView()
            }
        .padding(.horizontal).foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
    }
}


struct CardView: View {
    var isFaceUp: Bool = true
    
    var body: some View {
        
        ZStack{
            let shap :RoundedRectangle = RoundedRectangle (cornerRadius: 20.0)
            if isFaceUp{
                
                    shap.fill()
                    shap.foregroundColor(.white)
                RoundedRectangle (cornerRadius: 20.0)
                    .stroke(lineWidth: 3.0)
                Text("Hello")
                    .font(.largeTitle)
            }
            else{
                
               
                    shap.fill()
            }
        }
        .onTapGesture(perform: {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
        })
    }
}
































#Preview {
    ContentView()
}
