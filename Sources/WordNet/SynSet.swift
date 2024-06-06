//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 4.04.2021.
//

import Foundation
import Dictionary

public class SynSet : Equatable{
    
    private var id: String
    private var pos: Pos? = nil
    private var definition: [String]? = nil
    private var example: String? = nil
    private var synonym: Synonym
    private var relations: [Relation]
    private var note: String = ""
    private var wikiPage: String = ""
    private var bcs: Int = 0
    
    /**
     * Constructor initialize SynSet ID, synonym and relations list.
     - Parameters:
        - id: Synset ID
     */
    public init(id: String){
        self.id = id
        self.synonym = Synonym()
        self.relations = []
    }
    
    /**
     * Accessor for the SynSet ID.
     *
        - Returns: SynSet ID
     */
    public func getId() -> String{
        return id
    }
    
    /**
     * Mutator method for the SynSet ID.
     - Parameters:
        - id: SynSet ID to be set
     */
    public func setId(id: String){
        self.id = id
    }
    
    /**
     * Mutator method for the definition.
     - Parameters:
        - definition: String definition
     */
    public func setDefinition(definition: String){
        self.definition = definition.split{$0 == "|"}.map(String.init)
    }
    
    /**
     * Accessor for the definition.
     *
        - Returns: definition
     */
    public func getDefinition() -> String?{
        if definition != nil{
            return definition![0]
        } else {
            return nil
        }
    }
    
    /**
     * Returns the first literal's name.
     *
        - Returns: the first literal's name.
     */
    public func representative() -> String{
        return synonym.getLiteral(index: 0).getName()
    }
    
    /**
     * Returns all the definitions in the list.
     *
        - Returns: all the definitions
     */
    public func getLongDefinition() -> String?{
        if definition != nil {
            var longDefinition : String = definition![0]
            for i in 1..<definition!.count {
                longDefinition = longDefinition + "|" + definition![i]
            }
            return longDefinition
        } else {
            return nil
        }
    }
    
    /**
     * Sorts definitions list according to their lengths.
     */
    public func sortDefinitions(){
        if definition != nil {
            for i in 0..<definition!.count {
                for j in i + 1..<definition!.count {
                    if definition![i].count < definition![j].count {
                        let tmp = definition![i]
                        definition![i] = definition![j]
                        definition![j] = tmp
                    }
                }
            }
        }
    }
    
    /**
     * Accessor for the definition at specified index.
     - Parameters:
        - index: definition index to be accessed
     - Returns: definition at specified index
     */
    public func getDefinition(index: Int) -> String?{
        if index < definition!.count && index >= 0 {
            return definition![index]
        } else {
            return nil;
        }
    }
    
    /**
     * Returns number of definitions in the list.
     *
        - Returns: number of definitions in the list.
     */
    public func numberOfDefinitions() -> Int{
        if definition != nil {
            return definition!.count
        } else {
            return 0
        }
    }
    
    /**
     * Mutator for the example.
     - Parameters:
        - example: String that will be used to set
     */
    public func setExample(example: String){
        self.example = example
    }

    /**
     * Accessor for the example.
     *
        - Returns: String example
     */
    public func getExample() -> String?{
        return example
    }
    
    /**
     * Mutator for the bcs value which enables the connection with the BalkaNet.
     - Parameters:
        - bcs: bcs value
     */
    public func setBcs(bcs: Int){
        if bcs >= 1 && bcs <= 3{
            self.bcs = bcs
        }
    }
    
    /**
     * Accessor for the bcs value
     *
        - Returns: bcs value
     */
    public func getBcs() -> Int{
        return bcs
    }
    
    /**
     * Mutator for the part of speech tags.
     - Parameters:
        - pos: part of speech tag
     */
    public func setPos(pos: Pos){
        self.pos = pos
    }
    
    /**
     * Accessor for the part of speech tag.
     *
        - Returns: part of speech tag
     */
    public func getPos() -> Pos?{
        return pos
    }
    
    /**
     * Mutator for the available notes.
     - Parameters:
        - note: String note to be set
     */
    public func setNote(note: String){
        self.note = note
    }
    
    /**
     * Accessor for the available notes.
     *
        - Returns: String note
     */
    public func getNote() -> String{
        return note
    }

    /**
     * Mutator for the available notes.
     - Parameters:
        - wikiPage: String wikiPage to be set
     */
    public func setWikiPage(wikiPage: String){
        self.wikiPage = wikiPage
    }
    
    /**
     * Accessor for the wiki page.
     *
        - Returns: String wiki page
     */
    public func getWikiPage() -> String{
        return wikiPage
    }

    /**
     * Appends the specified Relation to the end of relations list.
     - Parameters:
        - relation: element to be appended to the list
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
        relations.removeAll(){$0 == relation}
    }
    
    /**
     * Removes the first occurrence of the specified element from relations list according to relation name,
     * if it is present. If the list does not contain the element, it stays unchanged.
     - Parameters:
        - name: element to be removed from the list, if present
     */
    public func removeRelation(name: String){
        for i in 0..<relations.count{
            if relations[i].getName() == name{
                relations.remove(at: i)
                break
            }
        }
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
     * Returns interlingual relations with the synonym interlingual dependencies.
     *
        - Returns: a list of SynSets that has interlingual relations in it
     */
    public func getInterlingual() -> [String]{
        var result : [String] = []
        for i in 0..<relations.count {
            if relations[i] is InterlingualRelation {
                let relation = relations[i] as! InterlingualRelation
                if relation.getType() == InterlingualDependencyType.SYNONYM {
                    result.append(relation.getName())
                }
            }
        }
        return result
    }
    
    /**
     * Returns the size of the relations list.
     *
        - Returns: the size of the relations list
     */
    public func relationSize() -> Int{
        return relations.count
    }
    
    /**
     * Adds a specified literal to the synonym.
     - Parameters:
        - literal: literal to be added
     */
    public func addLiteral(literal: Literal){
        synonym.addLiteral(literal: literal)
    }
    
    /**
     * Accessor for the synonym.
     *
        - Returns: synonym
     */
    public func getSynonym() -> Synonym{
        return synonym
    }
    
    /**
     * Compares literals of synonym and the specified SynSet, returns true if their have same literals.
     - Parameters:
        - synSet: SynSet to compare
     - Returns: true if SynSets have same literals, false otherwise
     */
    public func containsSameLiteral(synSet: SynSet) -> Bool{
        for i in 0..<synonym.literalSize() {
            let literal1 = synonym.getLiteral(index: i).getName()
            for j in 0..<synSet.getSynonym().literalSize() {
                let literal2 = synSet.getSynonym().getLiteral(index: j).getName()
                if literal1 == literal2 {
                    return true
                }
            }
        }
        return false
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
        for relation in relations {
            if relation is SemanticRelation && (relation as! SemanticRelation).getRelationType() == semanticRelationType {
                return true
            }
        }
        return false
    }
    
    /**
     * Merges synonym and a specified SynSet with their definitions, relations, part of speech tags and examples.
     - Parameters:
        - synSet: SynSet to be merged
     */
    public func mergeSynSet(synSet: SynSet){
        for i in 0..<synSet.getSynonym().literalSize() {
            if !synonym.contains(literal: synSet.getSynonym().getLiteral(index: i)) {
                synonym.addLiteral(literal: synSet.getSynonym().getLiteral(index: i))
            }
        }
        if definition == nil && synSet.getDefinition() != nil {
            setDefinition(definition: synSet.getDefinition()!)
        } else {
            if definition != nil && synSet.getDefinition() != nil && getLongDefinition() != synSet.getLongDefinition() {
                setDefinition(definition: getLongDefinition()! + "|" + synSet.getLongDefinition()!)
            }
        }
        if synSet.relationSize() != 0 {
            for i in 0..<synSet.relationSize() {
                if !containsRelation(relation: synSet.getRelation(index: i)) && synSet.getRelation(index: i).getName() != id {
                    addRelation(relation: synSet.getRelation(index: i))
                }
            }
        }
        if pos == nil && synSet.getPos() != nil {
            setPos(pos: synSet.getPos()!)
        }
        if example == nil && synSet.getExample() != nil {
            example = synSet.getExample()
        }
    }
    
    public static func == (lhs: SynSet, rhs: SynSet) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// Overridden toString method to print the first definition or representative.
    /// - Returns: print the first definition or representative.
    public func description() -> String{
        if definition != nil {
            return definition![0]
        } else {
            return representative()
        }
    }

}
