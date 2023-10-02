//
//  ContentView.swift
//  Memory
//
//  Created by Anna Rieckmann on 21.09.23.
//

import SwiftUI

struct ContentView: View {
    var emojis :Array<String> = ["😄","🥰","🐶","🦊","🙈","🦄","🐕","🦭"]
    @State var emojiCount :Int = 2
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

            Spacer()
            HStack{
                remove
                Spacer()
                add
                
            }.font (.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
            }
    var remove: some View {
        Button(action: {
            if emojiCount > 1 {
                emojiCount -= 1}}, label: {
            Image (systemName: "minus.circle")
        })
    }
    var add: some View {
        Button(action: {
            if emojiCount < emojis.count{
                emojiCount+=1}}, label: {
            Image (systemName: "plus.circle")
        })
    }
}


struct CardView: View {
    var content : String
   @State var isFaceUp: Bool = true
    
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
        .onTapGesture{
            isFaceUp = !isFaceUp
        }
    }
}
































#Preview {
    ContentView()
}
