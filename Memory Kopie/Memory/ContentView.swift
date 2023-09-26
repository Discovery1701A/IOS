//
//  ContentView.swift
//  Memory
//
//  Created by Anna Rieckmann on 21.09.23.
//

import SwiftUI

struct ContentView: View {
    @State var emojis : [String] = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷"]
    @State var tiere : [String] = ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷"]
    @State var fahrzeuge : [String] = ["🚗","🚕","🚙","🚌","🚎","🚐","🚒","🚑","🚓","🏎️","🛻","🚚","🚛","🚜","🛵","🏍️","🛺"]
    
    @State var gesicht : [String] = ["😀","😃","😄","😁","😆","🥰","😘","😍","🤪","🫡","🫠","🙄","😲","🤕","🥴"]
   
    @State var emojiCount :Int = 7
    @State var thema : String = "Tiere"
    @State var neues : Bool = true
    
    var body: some View {
        
        VStack{
            // Titel
            Text("Memory!")
                .font(.largeTitle)
            //Karten
            ScrollView{
        LazyVGrid(columns: [GridItem(.adaptive (minimum: 65))], content: {
            
            ForEach(emojis[0..<emojis.count],id:\.self, content:
                        {emoji in
                CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
            })
        }).foregroundColor(/*@START_MENU_TOKEN@*/.orange/*@END_MENU_TOKEN@*/)
    }

            Spacer()
            // Buttons
            HStack{
                tier
                Spacer()
                smili
                Spacer()
                fahrzeug
               
                
            }.font (.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
            }
    var tier: some View {
        Button(action: {
            thema = "Tiere"
            emojis = tiere // ausgabe Array wird geändert
            emojis.shuffle() //Durchmischer
            neues = true
            }, label: {
                VStack{
                    Image (systemName: "pawprint.circle")
                    Text("Tiere")
                        .font(.body)
                }
        })
    }
    var smili: some View {
        Button(action: {
            thema = "Smilis"
            emojis = gesicht// ausgabe Array wird geändert
            emojis.shuffle() //Durchmischer
            neues = true
            }, label: {
                VStack{
                    Image (systemName: "face.smiling")
                    Text("Smilys")
                        .font(.body)
                }
        })
    }
    var fahrzeug: some View {
        Button(action: {
            thema = "Fahrzeug"
            emojis = fahrzeuge // ausgabe Array wird geändert
            emojis.shuffle() //Durchmischer
            neues = true
            }, label: {
                VStack{
                    Image (systemName: "car.circle")
                    Text("Fahrzeuge")
                        .font(.body)
                }
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
