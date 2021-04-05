//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 4.04.2021.
//

import Foundation

public class InterlingualRelation : Relation{
    
    private var dependencyType: InterlingualDependencyType? = nil
    
    private static var ilrDependency : [String] = ["Hypernym", "Near_antonym", "Holo_member", "Holo_part", "Holo_portion",
    "Usage_domain", "Category_domain", "Be_in_state", "Subevent", "Verb_group",
    "Similar_to", "Also_see", "Causes", "SYNONYM"]
    
    private static var interlingualDependencyTags: [InterlingualDependencyType] = [InterlingualDependencyType.HYPERNYM,
    InterlingualDependencyType.NEAR_ANTONYM, InterlingualDependencyType.HOLO_MEMBER, InterlingualDependencyType.HOLO_PART,
    InterlingualDependencyType.HOLO_PORTION, InterlingualDependencyType.USAGE_DOMAIN, InterlingualDependencyType.CATEGORY_DOMAIN,
    InterlingualDependencyType.BE_IN_STATE, InterlingualDependencyType.SUBEVENT, InterlingualDependencyType.VERB_GROUP,
    InterlingualDependencyType.SIMILAR_TO, InterlingualDependencyType.ALSO_SEE, InterlingualDependencyType.CAUSES,
    InterlingualDependencyType.SYNONYM]
    
    /**
     * InterlingualRelation method sets its relation with the specified String name, then gets the InterlingualDependencyType
     * according to specified String dependencyType.
     - Parameters:
        - name :          relation name
        - dependencyType: interlingual dependency type
     */
    public init(name: String, dependencyType: String){
        super.init(name: name)
        self.dependencyType = InterlingualRelation.getInterlingualDependencyTag(tag: dependencyType)
    }
    
    /**
     * Compares specified {@code String} tag with the tags in InterlingualDependencyType {@code Array}, ignoring case
     * considerations.
     - Parameters:
        - tag: String to compare
     - Returns: interlingual dependency type according to specified tag
     */
    public static func getInterlingualDependencyTag(tag: String) -> InterlingualDependencyType?{
        for j in 0..<ilrDependency.count {
            if tag.lowercased() == ilrDependency[j].lowercased() {
                return interlingualDependencyTags[j]
            }
        }
        return nil
    }
    
    /**
     * Accessor method to get the private InterlingualDependencyType.
     *
        - Returns: interlingual dependency type
     */
    public func getType() -> InterlingualDependencyType?{
        return dependencyType
    }
    
    /**
     * Method to retrieve interlingual dependency type as {@code String}.
     *
        - Returns: String interlingual dependency type
     */
    public func getTypeAsString() -> String{
        return dependencyType!.rawValue
    }
    
    public func description() -> String{
        return getTypeAsString() + "->" + name
    }
}
