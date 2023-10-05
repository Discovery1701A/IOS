//
//  ContentView.swift
//  Memory
//
//  Created by Anna Rieckmann on 21.09.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            ScrollView{
        LazyVGrid(columns: [GridItem(.adaptive (minimum: 65))], content: {
            
            ForEach(emojis[0..<emojiCount],id:\.self, content:
                        {emoji in
                CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
            })
        }).foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
    }

        }
        .padding(.horizontal)
            }
    
}


struct CardView: View {
    
    var body: some View {
        
        ZStack{
            let shap :RoundedRectangle = RoundedRectangle (cornerRadius: 20.0)
            if isFaceUp{
                
                    shap.fill()
                    shap.foregroundColor(.white)
                RoundedRectangle (cornerRadius: 20.0)
                    .strokeBorder(lineWidth: 3.0)
                Text(content)
                    .font(.largeTitle)
            }
            else{
                
               
                    shap.fill()
            }
        }
    }
}
































#Preview {
    ContentView()
}
