//
//  LinkedList.swift
//  Gausen
//
//  Created by Anna Rieckmann on 15.12.23.
//
import Foundation

class LinkedList {
    class Node {
        var element: Any?
        var successor: Node?
        var predecessor: Node?
        
        init(element: Any?) {
            self.element = element
            self.successor = nil
            self.predecessor = nil
        }
    }
    
    var emptyNode = Node(element: nil)
    var firstNode: Node
    var lastNode: Node
    var numberOfElements: Int 
    
    init() {
        firstNode = emptyNode
        lastNode = emptyNode
        numberOfElements = 0
    }
    
    func add(element: Any) {
        let addedNode = Node(element: element)
        
        if numberOfElements == 0 {
            firstNode = addedNode
        } else {
            lastNode.successor = addedNode
            addedNode.predecessor = lastNode
        }
        
        lastNode = addedNode
        numberOfElements += 1
    }
    
    func remove(index: Int) {
        if index >= 0 && index < numberOfElements {
            var currentNode: Node? = firstNode
            
            for currentIndex in 0..<index {
                currentNode = currentNode?.successor
            }
            
            let removedNode = currentNode
            
            if let predecessor = removedNode?.predecessor {
                predecessor.successor = removedNode?.successor
            } else {
                firstNode = removedNode?.successor ?? emptyNode
            }
            
            if let successor = removedNode?.successor {
                successor.predecessor = removedNode?.predecessor
            } else {
                lastNode = removedNode?.predecessor ?? emptyNode
            }
            
            numberOfElements -= 1
        }
    }
    func get(index : Int) -> Any? {
        if index >= 0 || index < numberOfElements {
            
            var nodeAtCurrentIndex : Node = firstNode.successor!
            
            for _ in 0..<index {
                nodeAtCurrentIndex = nodeAtCurrentIndex.successor!
                
            }
            return nodeAtCurrentIndex.element
            
        }
        return nil
    }
    
    func removeAllBehinde(currentNode : Node) {
        currentNode.successor = nil
        lastNode = currentNode
    }
    
    func back(currentNode : Node) -> Node {
        if currentNode.predecessor != nil {
            return currentNode.predecessor!
        }
        return emptyNode
    }
    func forwart (currentNode : Node) -> Node {
        if currentNode.successor != nil {
            return currentNode.successor!
        }
        return emptyNode
    }
    
    func reset () {
        firstNode = emptyNode
        lastNode = emptyNode
        numberOfElements = 0
    }
    
}
