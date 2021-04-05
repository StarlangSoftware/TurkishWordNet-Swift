//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 4.04.2021.
//

import Foundation

public class SemanticRelation : Relation{
    
    private var relationType: SemanticRelationType? = nil
    private var _toIndex: Int = 0
    
    private static var semanticDependency: [String] = ["ANTONYM", "HYPERNYM",
    "INSTANCE_HYPERNYM", "HYPONYM", "INSTANCE_HYPONYM", "MEMBER_HOLONYM", "SUBSTANCE_HOLONYM",
    "PART_HOLONYM", "MEMBER_MERONYM", "SUBSTANCE_MERONYM", "PART_MERONYM", "ATTRIBUTE",
    "DERIVATION_RELATED", "DOMAIN_TOPIC", "MEMBER_TOPIC", "DOMAIN_REGION", "MEMBER_REGION",
    "DOMAIN_USAGE", "MEMBER_USAGE", "ENTAILMENT", "CAUSE", "ALSO_SEE",
    "VERB_GROUP", "SIMILAR_TO", "PARTICIPLE_OF_VERB"]
    
    private static var semanticDependencyTags: [SemanticRelationType] = [SemanticRelationType.ANTONYM, SemanticRelationType.HYPERNYM,
    SemanticRelationType.INSTANCE_HYPERNYM, SemanticRelationType.HYPONYM, SemanticRelationType.INSTANCE_HYPONYM, SemanticRelationType.MEMBER_HOLONYM, SemanticRelationType.SUBSTANCE_HOLONYM,
    SemanticRelationType.PART_HOLONYM, SemanticRelationType.MEMBER_MERONYM, SemanticRelationType.SUBSTANCE_MERONYM, SemanticRelationType.PART_MERONYM, SemanticRelationType.ATTRIBUTE,
    SemanticRelationType.DERIVATION_RELATED, SemanticRelationType.DOMAIN_TOPIC, SemanticRelationType.MEMBER_TOPIC, SemanticRelationType.DOMAIN_REGION, SemanticRelationType.MEMBER_REGION,
    SemanticRelationType.DOMAIN_USAGE, SemanticRelationType.MEMBER_USAGE, SemanticRelationType.ENTAILMENT, SemanticRelationType.CAUSE, SemanticRelationType.ALSO_SEE,
    SemanticRelationType.VERB_GROUP, SemanticRelationType.SIMILAR_TO, SemanticRelationType.PARTICIPLE_OF_VERB]
    
    /**
     * A constructor to initialize relation type and the relation name.
     - Parameters:
        - name:         name of the relation
        - relationType: String semantic dependency tag
     */
    public init(name: String, relationType: String){
        self.relationType = SemanticRelation.getSemanticTag(tag: relationType)!
        super.init(name: name)
    }
    
    /**
     * Another constructor that initializes relation type, relation name, and the index.
     - Parameters:
        - name:         name of the relation
        - relationType: String semantic dependency tag
        - toIndex :     index of the relation
     */
    public init(name: String, relationType: String, toIndex: Int){
        self.relationType = SemanticRelation.getSemanticTag(tag: relationType)!
        _toIndex = toIndex
        super.init(name: name)
    }
    
    /**
     * Another constructor that initializes relation type and relation name.
     - Parameters:
        - name :        name of the relation
        - relationType: semantic dependency tag
     */
    public init(name: String, relationType: SemanticRelationType){
        self.relationType = relationType
        super.init(name: name)
    }

    /**
     * Another constructor that initializes relation type, relation name, and the index.
     - Parameters:
        - name:         name of the relation
        - relationType: semantic dependency tag
        - toIndex:      index of the relation
     */
    public init(name: String, relationType: SemanticRelationType, toIndex: Int){
        self.relationType = relationType
        _toIndex = toIndex
        super.init(name: name)
    }

    /**
     * Accessor to retrieve semantic relation type given a specific semantic dependency tag.
     - Parameters:
        - tag: String semantic dependency tag
     - Returns: semantic relation type
     */
    public static func getSemanticTag(tag: String) -> SemanticRelationType?{
        for j in 0..<semanticDependencyTags.count {
            if tag.lowercased() == semanticDependency[j].lowercased() {
                return semanticDependencyTags[j]
            }
        }
        return nil
    }
    
    /**
     * Returns the reverse of a specific semantic relation type.
     - Parameters:
        - semanticRelationType: semantic relation type to be reversed
     - Returns: reversed version of the semantic relation type
     */
    public static func reverse(semanticRelationType: SemanticRelationType) -> SemanticRelationType?{
        switch semanticRelationType {
            case SemanticRelationType.HYPERNYM:
                return SemanticRelationType.HYPONYM
            case SemanticRelationType.HYPONYM:
                return SemanticRelationType.HYPERNYM
            case SemanticRelationType.ANTONYM:
                return SemanticRelationType.ANTONYM
            case SemanticRelationType.INSTANCE_HYPERNYM:
                return SemanticRelationType.INSTANCE_HYPONYM
            case SemanticRelationType.INSTANCE_HYPONYM:
                return SemanticRelationType.INSTANCE_HYPERNYM
            case SemanticRelationType.MEMBER_HOLONYM:
                return SemanticRelationType.MEMBER_MERONYM
            case SemanticRelationType.MEMBER_MERONYM:
                return SemanticRelationType.MEMBER_HOLONYM
            case SemanticRelationType.PART_MERONYM:
                return SemanticRelationType.PART_HOLONYM
            case SemanticRelationType.PART_HOLONYM:
                return SemanticRelationType.PART_MERONYM
            case SemanticRelationType.SUBSTANCE_MERONYM:
                return SemanticRelationType.SUBSTANCE_HOLONYM
            case SemanticRelationType.SUBSTANCE_HOLONYM:
                return SemanticRelationType.SUBSTANCE_MERONYM
            case SemanticRelationType.DOMAIN_TOPIC:
                return SemanticRelationType.MEMBER_TOPIC
            case SemanticRelationType.MEMBER_TOPIC:
                return SemanticRelationType.DOMAIN_TOPIC
            case SemanticRelationType.DOMAIN_REGION:
                return SemanticRelationType.MEMBER_REGION
            case SemanticRelationType.MEMBER_REGION:
                return SemanticRelationType.DOMAIN_REGION
            case SemanticRelationType.DOMAIN_USAGE:
                return SemanticRelationType.MEMBER_USAGE
            case SemanticRelationType.MEMBER_USAGE:
                return SemanticRelationType.DOMAIN_USAGE
            case SemanticRelationType.DERIVATION_RELATED:
                return SemanticRelationType.DERIVATION_RELATED
            default:
                break
        }
        return nil
    }
    
    /**
     * Returns the index value.
     *
        - Returns: index value.
     */
    public func toIndex() -> Int{
        return self._toIndex
    }
    
    /**
     * Accessor for the semantic relation type.
     *
        - Returns: semantic relation type
     */
    public func getRelationType() -> SemanticRelationType?{
        return relationType
    }
    
    /**
     * Mutator for the semantic relation type.
     - Parameters:
        - relationType semantic relation type.
     */
    public func setRelationType(relationType: SemanticRelationType){
        self.relationType = relationType
    }
    
    /**
     * Accessor method to retrieve the semantic relation type as a String.
     *
        - Returns: String semantic relation type
     */
    public func getTypeAsString() -> String?{
        if relationType != nil{
            return relationType?.rawValue
        } else {
            return nil
        }
    }
    
    public static func == (lhs: SemanticRelation, rhs: SemanticRelation) -> Bool {
        return lhs.name == rhs.name && lhs.relationType == rhs.relationType && lhs._toIndex == rhs._toIndex
    }

}
