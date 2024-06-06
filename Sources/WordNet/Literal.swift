//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 4.04.2021.
//

import Foundation

public class Literal : Equatable{

    public var name: String
    public var sense: Int
    public var synSetId: String
    public var origin: String? = nil
    public var groupNo: Int = 0
    public var relations: [Relation]
    
    /**
     * A constructor that initializes name, sense, SynSet ID and the relations.
     - Parameters:
        - name:     name of a literal
        - sense:    index of sense
        - synSetId: ID of the SynSet
     */
    public init(name: String, sense: Int, synSetId: String){
        self.name = name
        self.sense = sense
        self.synSetId = synSetId
        self.relations = []
    }
    
    public static func == (lhs: Literal, rhs: Literal) -> Bool {
        return lhs.name == rhs.name && lhs.sense == rhs.sense
    }
    
    /**
     * Accessor method to return SynSet ID.
     *
        - Returns: String of SynSet ID
     */
    public func getSynSetId() -> String{
        return synSetId
    }
    
    /**
     * Accessor method to return name of the literal.
     *
        - Returns: name of the literal
     */
    public func getName() -> String{
        return name
    }
    
    /**
     * Accessor method to return the index of sense of the literal.
     *
        - Returns: index of sense of the literal
     */
    public func getSense() -> Int{
        return sense
    }
    
    /**
     * Accessor method to return the origin of the literal.
     *
        - Returns: origin of the literal
     */
    public func getOrigin() -> String?{
        return origin
    }
    
    /**
     * Mutator method to set the origin with specified origin.
     - Parameters:
        - origin: origin of the literal to set
     */
    public func setOrigin(origin: String){
        self.origin = origin
    }

    /**
     * Accessor method to return the group no of the literal.
     *
     - Returns: group no of the literal
     */
    public func getGroupNo() -> Int{
        return groupNo
    }
    
    /**
     * Mutator method to set the group no with specified group no.
     - Parameters:
     - origin: group no of the literal to set
     */
    public func setGroupNo(groupNo: Int){
        self.groupNo = groupNo
    }

    /**
     * Mutator method to set the sense index of the literal.
     - Parameters:
        - sense: sense index of the literal to set
     */
    public func setSense(sense: Int){
        self.sense = sense
    }
    
    /**
     * Appends the specified Relation to the end of relations list.
     - Parameters:
        - relation element to be appended to the list
     */
    public func addRelation(relation: Relation){
        relations.append(relation)
    }
    
    /**
     * Removes the first occurrence of the specified element from relations list,
     * if it is present. If the list does not contain the element, it stays unchanged.
    - Parameters:
        - relation: element to be removed from the list, if present
     */
    public func removeRelation(relation: Relation){
        relations.removeAll {$0 == relation}
    }
    
    /**
     * Returns true if relations list contains the specified relation.
     - Parameters:
        - relation: element whose presence in the list is to be tested
     - Returns: true if the list contains the specified element
     */
    public func containsRelation(relation: Relation) -> Bool{
        return relations.contains(relation)
    }
    
    /**
     * Returns true if specified semantic relation type presents in the relations list.
     - Parameters:
        - semanticRelationType: element whose presence in the list is to be tested
     - Returns: true if specified semantic relation type presents in the relations list
     */
    public func containsRelationType(semanticRelationType: SemanticRelationType) -> Bool{
        for relation in relations{
            if relation is SemanticRelation && (relation as! SemanticRelation).getRelationType() == semanticRelationType{
                return true
            }
        }
        return false
    }
    
    /**
     * Returns the element at the specified position in relations list.
     - Parameters:
        - index: index of the element to return
     - Returns: the element at the specified position in the list
     */
    public func getRelation(index: Int) -> Relation{
        return relations[index]
    }
    
    /**
     * Returns size of relations list.
     *
        - Returns: the size of the list
     */
    public func relationSize() -> Int{
        return relations.count
    }
    
    /**
     * Mutator method to set name of a literal.
     - Parameters:
        - name: name of the literal to set
     */
    public func setName(name: String){
        self.name = name
    }
    
    /**
     * Mutator method to set SynSet ID of a literal.
     - Parameters:
        - synSetId: SynSet ID of the literal to set
     */
    public func setSynSetId(synSetId: String){
        self.synSetId = synSetId
    }
    
    /// Overridden description method to print names and sense of literals.
    /// - Returns: concatenated names and senses of literals
    public func description() -> String{
        return name + " " + String(sense)
    }
}
