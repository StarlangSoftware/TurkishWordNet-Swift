public class Relation : Equatable{
    
    public var name: String
    
    /**
     * A constructor that sets the name of the relation.
     - Parameters:
        - name: String relation name
     */
    public init(name: String){
        self.name = name
    }
    
    /**
     * Accessor method for the relation name.
     *
        - Returns: String relation name
     */
    public func getName() -> String{
        return name
    }
    
    /**
     * Mutator for the relation name.
     - Parameters:
        - name: String relation name
     */
    public func setName(name: String){
        self.name = name
    }
    
    public static func == (lhs: Relation, rhs: Relation) -> Bool {
        return lhs.name == rhs.name
    }
    
}
