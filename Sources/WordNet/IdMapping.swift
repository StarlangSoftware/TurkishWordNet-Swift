//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 4.04.2021.
//

import Foundation

public class IdMapping{
    
    private var map: Dictionary<String, String> = [:]
    
    /**
     * Constructor to load ID mappings from specific file "mapping.txt" to a {@link HashMap}.
     */
    public init(){
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let url = thisDirectory.appendingPathComponent("idmapping.txt")
        do{
            let fileContent = try String(contentsOf: url, encoding: .utf8)
            let lines : [String] = fileContent.split(whereSeparator: \.isNewline).map(String.init)
            for line in lines{
                let mapInfo : [String] = line.components(separatedBy: "->")
                map[mapInfo[0]] = mapInfo[1]
            }
        } catch {
        }
    }

    /**
     * Constructor to load ID mappings from given file to a {@link HashMap}.
     - Parameters:
        - fileName: String file name input that will be read
     */
    public init(fileName: String){
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let url = thisDirectory.appendingPathComponent(fileName)
        do{
            let fileContent = try String(contentsOf: url, encoding: .utf8)
            let lines : [String] = fileContent.split(whereSeparator: \.isNewline).map(String.init)
            for line in lines{
                let mapInfo : [String] = line.components(separatedBy: "->")
                map[mapInfo[0]] = mapInfo[1]
            }
        } catch {
        }
    }
    
    /**
     * Returns a {@link Set} view of the keys contained in this map.
     *
        - Returns: a set view of the keys contained in this map
     */
    public func keySet() -> Dictionary<String, String>.Keys{
        return map.keys
    }
    
    /**
     * Returns the value to which the specified key is mapped,
     * or {@code null} if this map contains no mapping for the key.
     - Parameters:
        - id: String id of a key
     - Returns: value of the specified key
     */
    public func map(id: String)->String?{
        if map[id] == nil {
            return nil
        }
        var mappedId : String = map[id]!
        while map[mappedId] != nil {
            mappedId = map[mappedId]!
        }
        return mappedId
    }
    
    /**
     * Returns the value to which the specified key is mapped.
     - Parameters:
        - id: String id of a key
     - Returns: value of the specified key
     */
    public func singleMap(id: String) -> String{
        return map[id]!
    }

    /**
     * Associates the specified value with the specified key in this map.
     - Parameters:
        - key:   key with which the specified value is to be associated
        - value: value to be associated with the specified key
     */
    public func add(key: String, value: String){
        map[key] = value
    }
    
    /**
     * Removes the mapping for the specified key from this map if present.
     - Parameters:
        - key: key whose mapping is to be removed from the map
     */
    public func remove(key: String){
        map.removeValue(forKey: key)
    }
}
