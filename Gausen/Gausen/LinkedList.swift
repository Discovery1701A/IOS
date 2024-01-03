//
//  LinkedList.swift
//  Gausen
//
//  Created by Anna Rieckmann on 15.12.23.
//
import Foundation
// Klasse für einen Linked List, Grundidee aus Aloritmen und Datenstrukturen
class LinkedList {
    // Innere Klasse für einen Listknoten
    class Node {
        var element: Any? // Das gespeicherte Element im Knoten
        var successor: Node? // Der nachfolgende Knoten in der Liste
        var predecessor: Node? // Der vorherige Knoten in der Liste
        
        // Initialisierung eines Knotens mit einem gegebenen Element
        init(element: Any?) {
            self.element = element
            successor = nil
            predecessor = nil
        }
    }
    
    var emptyNode = Node(element: nil) // Ein leerer Knoten, der als Markierung für leere Liste dient
    var firstNode: Node // Der erste Knoten in der Liste
    var lastNode: Node // Der letzte Knoten in der Liste
    var numberOfElements: Int // Die Anzahl der Elemente in der Liste
    
    // Initialisierung der verketteten Liste
    init() {
        firstNode = emptyNode
        lastNode = emptyNode
        numberOfElements = 0
    }
    
    // Funktion zum Hinzufügen eines Elements zur Liste
    func add(element: Any) {
        let addedNode = Node(element: element)
        
        if numberOfElements == 0 {
            // Wenn die Liste leer ist, wird der hinzugefügte Knoten zum ersten Knoten
            firstNode = addedNode
        } else {
            // Der Nachfolger des letzten Knotens wird auf den neuen Knoten gesetzt
            lastNode.successor = addedNode
            // Der Vorgänger des neuen Knotens wird auf den letzten Knoten gesetzt
            addedNode.predecessor = lastNode
        }
        
        // Der hinzugefügte Knoten wird zum letzten Knoten
        lastNode = addedNode
        // Die Anzahl der Elemente in der Liste wird erhöht
        numberOfElements += 1
    }
    
    // Funktion zum Entfernen eines Elements an einem bestimmten Index
    func remove(index: Int) {
        if index >= 0, index < numberOfElements {
            // Suchen des zu entfernenden Knotens
            var currentNode: Node? = firstNode
            for _ in 0..<index {
                currentNode = currentNode?.successor
            }
            
            let removedNode = currentNode
            
            // Aktualisierung der Verweise des Vorgängers und Nachfolgers des zu entfernenden Knotens
            if let predecessor = removedNode?.predecessor {
                predecessor.successor = removedNode?.successor
            } else {
                // Wenn der zu entfernende Knoten der erste Knoten ist, wird der Nachfolger zum ersten Knoten
                firstNode = removedNode?.successor ?? emptyNode
            }
            
            if let successor = removedNode?.successor {
                successor.predecessor = removedNode?.predecessor
            } else {
                // Wenn der zu entfernende Knoten der letzte Knoten ist, wird der Vorgänger zum letzten Knoten
                lastNode = removedNode?.predecessor ?? emptyNode
            }
            
            // Die Anzahl der Elemente in der Liste wird verringert
            numberOfElements -= 1
        }
    }

    // Funktion zum Abrufen des Elements an einem bestimmten Index
    func get(index: Int) -> Any? {
        if index >= 0 || index < numberOfElements {
            // Suchen des Knotens an der gegebenen Position
            var nodeAtCurrentIndex: Node = firstNode.successor!
            for _ in 0..<index {
                nodeAtCurrentIndex = nodeAtCurrentIndex.successor!
            }
            return nodeAtCurrentIndex.element
        }
        return nil
    }
    
    // Funktion zum Entfernen aller Knoten hinter einem bestimmten Knoten
    func removeAllBehinde(currentNode: Node) {
        // Setzen des Nachfolgers des aktuellen Knotens auf nil, um alle nachfolgenden Knoten zu entfernen
        currentNode.successor = nil
        // Der letzte Knoten wird auf den aktuellen Knoten gesetzt
        lastNode = currentNode
    }
    
    // Funktion zum Zurückgehen zu einem vorherigen Knoten in der Liste
    func back(currentNode: Node) -> Node {
        // Wenn ein vorheriger Knoten vorhanden ist, wird er zurückgegeben, sonst der leere Knoten
        if currentNode.predecessor != nil {
            return currentNode.predecessor!
        }
        return emptyNode
    }

    // Funktion zum Vorwärtsgehen zu einem nachfolgenden Knoten in der Liste
    func forwart(currentNode: Node) -> Node {
        // Wenn ein nachfolgender Knoten vorhanden ist, wird er zurückgegeben, sonst der leere Knoten
        if currentNode.successor != nil {
            return currentNode.successor!
        }
        return emptyNode
    }
    
    // Funktion zum Zurücksetzen der gesamten Liste
    func reset() {
        firstNode = emptyNode
        lastNode = emptyNode
        numberOfElements = 0
    }
}
