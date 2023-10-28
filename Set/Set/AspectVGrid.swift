//
//  AspectVGrid.swift
//  Set
//
//  Created by Anna Rieckmann on 19.10.23.
//

import Foundation
import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    
    
    init (items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                
                let width = widthThatFitsWithMin(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio, minWidth: 70)
                if  widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio) > 70{
                    weisauchnicht(width: width)
                    //Text(String(Int(width)))
                }else{
                    ScrollView{
                        weisauchnicht(width: width)
                        
                    }
                    Text(String(Int(width)))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
    @ViewBuilder
    func weisauchnicht(width : CGFloat)-> some View{
        LazyVGrid(columns: [adaptiveGridItem(width: width)],spacing: 0) {
            ForEach(items) { item in
                content (item) .aspectRatio(aspectRatio, contentMode: .fit)
                
            }
        }
    }
    
    
    private func adaptiveGridItem(width : CGFloat)-> GridItem{
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat (rowCount) * itemHeight < size.height {
                break
            }
            
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } 
        while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        
        return floor(size.width / CGFloat (columnCount) )
    }
    
    private func widthThatFitsWithMin(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat, minWidth: CGFloat) -> CGFloat {
        var minWidthFit : CGFloat = minWidth
        for i in stride(from: 11 , through: itemCount-1, by: +3){
            if widthThatFits(itemCount: i, in: size, itemAspectRatio: itemAspectRatio) > minWidth {
                minWidthFit = widthThatFits(itemCount: i, in: size, itemAspectRatio: itemAspectRatio)
                // print("min",minWidthFit)
            }else{
                break
            }
        }
        return floor(minWidthFit)
        
    }
}


