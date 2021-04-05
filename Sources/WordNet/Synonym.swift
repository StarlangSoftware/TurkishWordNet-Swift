//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 4.04.2021.
//

import Foundation

public class Synonym{
    
    private var literals: [Literal] = []
    
    /**
     * A constructor that creates a new {@link ArrayList} literals.
     */
    public init(){
    }
    
    /**
     * Appends the specified Literal to the end of literals list.
     - Parameters:
        - literal: element to be appended to the list
     */
    public func addLiteral(literal: Literal){
        literals.append(literal)
    }
    
    /**
     * Moves the specified literal to the first of literals list.
     - Parameters:
        - literal: element to be moved to the first element of the list
     */
    public func moveFirst(literal: Literal){
        if contains(literal: literal){
            literals.removeAll() {$0 == literal}
            literals.insert(literal, at: 0)
        }
    }
    
    /**
     * Returns the element at the specified position in literals list.
     - Parameters:
        - index: index of the element to return
     - Returns: the element at the specified position in the list
     */
    public func getLiteral(index: Int) -> Literal{
        return literals[index]
    }
    
    /**
     * Returns the element with the specified name in literals list.
     - Parameters:
        - name: name of the element to return
     - Returns: the element with the specified name in the list
     */
    public func getLiteral(name: String) -> Literal?{
        for literal in literals{
            if literal.getName() == name{
                return literal
            }
        }
        return nil
    }
    
    /**
     * Returns size of literals list.
     *
        - Returns: the size of the list
     */
    public func literalSize() -> Int{
        return literals.count
    }
    
    /**
     * Returns true if literals list contains the specified literal.
     - Parameters:
        - literal: element whose presence in the list is to be tested
     - Returns: true if the list contains the specified element
     */
    public func contains(literal: Literal) -> Bool{
        return literals.contains(literal)
    }
    
    /**
     * Returns true if literals list contains the specified String literal.
     - Parameters:
        - literalName: element whose presence in the list is to be tested
     - Returns: true if the list contains the specified element
     */
    public func containsLiteral(literal: String) -> Bool{
        for literal1 in literals{
            if literal1.getName() == literal{
                return true
            }
        }
        return false
    }
    
    /**
     * Removes the first occurrence of the specified element from literals list,
     * if it is present. If the list does not contain the element, it stays unchanged.
     - Parameters:
        - toBeRemoved: element to be removed from the list, if present
     */
    public func removeLiteral(toBeRemoved: Literal){
        literals.removeAll() {$0 == toBeRemoved}
    }
    
    public func description() -> String{
        var result : String = ""
        for literal in literals {
            result = result + literal.getName() + " "
        }
        return result
    }
}
