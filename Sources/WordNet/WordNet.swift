//
//  File.swift
//  
//
//  Created by Olcay Taner YILDIZ on 4.04.2021.
//

import Foundation
import Dictionary
import MorphologicalAnalysis

public class WordNet: NSObject, XMLParserDelegate{
    
    private var _synSetList : [String : SynSet] = [:]
    private var _literalList : [String : [Literal]] = [:]
    private var exceptionList : [String : [ExceptionalWord]] = [:]
    public var interlingualList : [String : [SynSet]] = [:]
    private var locale: Locale = Locale(identifier: "tr")

    private var value: String = ""
    private var synSet: SynSet? = nil
    private var literal: Literal? = nil
    private var relatedId: String? = nil
    private var relationType: String? = nil
    private var synonymMode: Bool = false
    private var to: String? = nil
    
    private func parse(fileName: String){
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let url = thisDirectory.appendingPathComponent(fileName)
        let parser : XMLParser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
    }

    public override init(){
        super.init()
        parse(fileName: "turkish_wordnet.xml")
    }

    public init(fileName: String){
        super.init()
        locale = Locale(identifier: "en")
        parse(fileName: fileName)
        parse(fileName: "english_exception.xml")
    }

    public init(fileName: String, locale: Locale){
        super.init()
        self.locale = locale
        parse(fileName: fileName)
    }

    public init(fileName: String, exceptionFileName: String, locale: Locale){
        super.init()
        self.locale = locale
        parse(fileName: fileName)
        parse(fileName: exceptionFileName)
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        switch elementName {
            case "word":
                let name = attributeDict["name"]
                let root = attributeDict["root"]!
                var pos : Pos
                switch attributeDict["pos"] {
                    case "Adj":
                        pos = Pos.ADJECTIVE
                    case "Adv":
                        pos = Pos.ADVERB
                    case "Noun":
                        pos = Pos.NOUN
                    case "Verb":
                        pos = Pos.VERB
                    default:
                        pos = Pos.NOUN
                }
                var rootList : [ExceptionalWord] = []
                if exceptionList[name!] != nil{
                    rootList = exceptionList[name!]!
                }
                rootList.append(ExceptionalWord(name: name!, root: root, pos: pos))
                exceptionList[name!] = rootList
            case "SYNSET":
                synSet = SynSet(id: "")
            case "ID":
                value = ""
            case "SYNONYM":
                synonymMode = true
            case "LITERAL":
                literal = Literal(name: "", sense: 0, synSetId: (synSet?.getId())!)
                value = ""
            case "SENSE":
                literal?.setName(name: value)
                value = ""
            case "POS":
                value = ""
            case "DEF":
                value = ""
            case "EXAMPLE":
                value = ""
            case "ILR":
                value = ""
            case "SR":
                value = ""
                to = nil
            case "TYPE":
                relatedId = value
                value = ""
            case "TO":
                value = ""
            default:
                break
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        switch elementName {
            case "SYNSET":
                addSynSet(synSet: synSet!)
                synSet = nil
            case "ID":
                synSet?.setId(id: value)
            case "SYNONYM":
                synonymMode = false
            case "LITERAL":
                synSet?.getSynonym().addLiteral(literal: literal!)
                addLiteralToLiteralList(literal: literal!)
                literal = nil
            case "SENSE":
                literal?.setSense(sense: Int(value)!)
            case "POS":
                switch value {
                    case "a":
                        synSet?.setPos(pos: Pos.ADJECTIVE)
                    case "v":
                        synSet?.setPos(pos: Pos.VERB)
                    case "b":
                        synSet?.setPos(pos: Pos.ADVERB)
                    case "n":
                        synSet?.setPos(pos: Pos.NOUN)
                    case "i":
                        synSet?.setPos(pos: Pos.INTERJECTION)
                    case "c":
                        synSet?.setPos(pos: Pos.CONJUNCTION)
                    case "p":
                        synSet?.setPos(pos: Pos.PREPOSITION)
                    case "r":
                        synSet?.setPos(pos: Pos.PRONOUN)
                    default:
                        break
                }
            case "DEF":
                synSet?.setDefinition(definition: value)
            case "EXAMPLE":
                synSet?.setExample(example: value)
            case "TYPE":
                relationType = value
            case "ILR":
                var synSetList : [SynSet] = []
                if interlingualList[relatedId!] != nil{
                    synSetList = interlingualList[relatedId!]!
                }
                synSetList.append(synSet!)
                interlingualList[relatedId!] = synSetList
                synSet?.addRelation(relation: InterlingualRelation(name: relatedId!, dependencyType: relationType!))
            case "TO":
                to = value
            case "SR":
                if to != nil{
                    if synonymMode{
                        literal?.addRelation(relation: SemanticRelation(name: relatedId!, relationType: relationType!, toIndex: Int(to!)!))
                    } else {
                        synSet?.addRelation(relation: SemanticRelation(name: relatedId!, relationType: relationType!, toIndex: Int(to!)!))
                    }
                } else {
                    if synonymMode{
                        literal?.addRelation(relation: SemanticRelation(name: relatedId!, relationType: relationType!))
                    } else {
                        synSet?.addRelation(relation: SemanticRelation(name: relatedId!, relationType: relationType!))
                    }
                }
            default:
                break
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String){
        if string != "\n"{
            value = value + string
        }
    }
    /**
     * Adds a specified literal to the literal list.
     - Parameters:
        - literal: literal to be added
     */
    public func addLiteralToLiteralList(literal: Literal){
        var literals : [Literal]
        if _literalList[literal.getName()] != nil {
            literals = _literalList[literal.getName()]!
        } else {
            literals = []
        }
        literals.append(literal)
        _literalList[literal.getName()] = literals
    }
    
    private func updateAllRelationsAccordingToNewSynSet(oldSynSet: SynSet, newSynSet: SynSet){
        for synSet in synSetList(){
            var i : Int = 0
            while i < synSet.relationSize(){
                if synSet.getRelation(index: i) is SemanticRelation{
                    let sr = synSet.getRelation(index: i) as! SemanticRelation
                    if synSet.getRelation(index: i).getName() == oldSynSet.getId(){
                        let newRelation : SemanticRelation = SemanticRelation(name: newSynSet.getId(),relationType: sr.getRelationType()!)
                        if synSet.getId() == newSynSet.getId() || synSet.containsRelation(relation: newRelation){
                            synSet.removeRelation(relation: synSet.getRelation(index: i))
                            i -= 1
                        } else {
                            synSet.getRelation(index: i).setName(name: newSynSet.getId())
                        }
                    }
                }
                i += 1
            }
        }
    }
    
    /**
     * Returns the values of the SynSet list.
     *
        - Returns: values of the SynSet list
     */
    public func synSetList() -> [SynSet]{
        return Array(_synSetList.values)
    }
    
    /**
     * Returns the keys of the literal list.
     *
        - Returns: keys of the literal list
     */
    public func literalList() -> [String]{
        return Array(_literalList.keys)
    }
    
    /**
     * Adds specified SynSet to the SynSet list.
     - Parameters:
        - synSet: SynSet to be added
     */
    public func addSynSet(synSet: SynSet){
        _synSetList[synSet.getId()] = synSet
    }

    /**
     * Removes specified SynSet from the SynSet list.
     - Parameters:
        - synSet: SynSet to be removed
     */
    public func removeSynSet(synSet: SynSet){
        _synSetList.removeValue(forKey: synSet.getId())
    }
    
    /**
     * Changes ID of a specified SynSet with the specified new ID.
     - Parameters:
        - synSet: SynSet whose ID will be updated
        - newId:  new ID
     */
    public func changeSynSetId(synSet: SynSet, newId: String){
        _synSetList.removeValue(forKey: synSet.getId())
        synSet.setId(id: newId)
        _synSetList[newId] = synSet
    }
    
    /**
     * Returns SynSet with the specified SynSet ID.
     - Parameters:
        - synSetId: ID of the SynSet to be returned
     - Returns: SynSet with the specified SynSet ID
     */
    public func getSynSetWithId(synSetId: String) -> SynSet?{
        return _synSetList[synSetId]
    }
    
    /**
     * Returns SynSet with the specified literal and sense index.
     - Parameters:
        - literal: SynSet literal
        - sense:   SynSet's corresponding sense index
     - Returns: SynSet with the specified literal and sense index
     */
    public func getSynSetWithLiteral(literal: String, sense: Int) -> SynSet?{
        let literals : [Literal]? = _literalList[literal]
        if literals != nil{
            for current in literals!{
                if current.getSense() == sense{
                    return getSynSetWithId(synSetId: current.getSynSetId())
                }
            }
        }
        return nil
    }
    
    /**
     * Returns the number of SynSets with a specified literal.
     - Parameters:
        - literal: literal to be searched in SynSets
     - Returns: the number of SynSets with a specified literal
     */
    public func numberOfSynSetsWithLiteral(literal: String) -> Int{
        if _literalList[literal] != nil{
            return _literalList[literal]!.count
        } else {
            return 0
        }
    }
    
    /**
     * Returns a list of SynSets with a specified part of speech tag.
     - Parameters:
        - pos: part of speech tag to be searched in SynSets
     - Returns: a list of SynSets with a specified part of speech tag
     */
    public func getSynSetsWithPartOfSpeech(pos: Pos)->[SynSet]{
        var result : [SynSet] = []
        for synSet in _synSetList.values {
            if synSet.getPos() != nil && synSet.getPos() == pos {
                result.append(synSet)
            }
        }
        return result
    }
    
    /**
     * Returns a list of literals with a specified literal String.
     - Parameters:
        - literal: literal String to be searched in literal list
     - Returns: a list of literals with a specified literal String
     */
    public func getLiteralsWithName(literal: String) -> [Literal]{
        if _literalList[literal] != nil{
            return _literalList[literal]!
        } else {
            return []
        }
    }
    
    /**
     * Finds the SynSet with specified literal String and part of speech tag and adds to the given SynSet list.
     - Parameters:
        - result:  SynSet list to add the specified SynSet
        - literal: literal String to be searched in literal list
        - pos:     part of speech tag to be searched in SynSets
     */
    public func addSynSetsWithLiteralToList(result: inout [SynSet], literal: String, pos: Pos){
        for current in _literalList[literal]! {
            let synSet = getSynSetWithId(synSetId: current.getSynSetId())
            if synSet != nil && synSet!.getPos() == pos {
                result.append(synSet!)
            }
        }
    }
    
    /**
     * Finds SynSets with specified literal String and adds to the newly created SynSet list.
     - Parameters:
        - literal: literal String to be searched in literal list
     - Returns: returns a list of SynSets with specified literal String
     */
    public func getSynSetsWithLiteral(literal: String) -> [SynSet]{
        var result : [SynSet] = []
        if _literalList[literal] != nil {
            for current in _literalList[literal]! {
                let synSet = getSynSetWithId(synSetId: current.getSynSetId())
                if synSet != nil {
                    result.append(synSet!)
                }
            }
        }
        return result
    }
    
    /**
     * Finds literals with specified literal String and adds to the newly created literal String list. Ex: cleanest - clean
     - Parameters:
        - literal: literal String to be searched in literal list
     - Returns: returns a list of literals with specified literal String
     */
    public func getLiteralsWithPossibleModifiedLiteral(literal: String) -> [String]{
        var result : [String] = []
        result.append(literal)
        let wordWithoutLastOne = literal.prefix(literal.count - 1)
        let wordWithoutLastTwo = literal.prefix(literal.count - 2)
        let wordWithoutLastThree = literal.prefix(literal.count - 3)
        if exceptionList[literal] != nil {
            for exceptionalWord in exceptionList[literal]! {
                result.append(exceptionalWord.getRoot())
            }
        }
        if literal.hasSuffix("s") && _literalList[String(wordWithoutLastOne)] != nil {
            result.append(String(wordWithoutLastOne))
        }
        if (literal.hasSuffix("es") || literal.hasSuffix("ed") || literal.hasSuffix("er")) && _literalList[String(wordWithoutLastTwo)] != nil {
            result.append(String(wordWithoutLastTwo))
        }
        if literal.hasSuffix("ed") && _literalList[wordWithoutLastTwo + String(Word.charAt(s: literal, i: literal.count - 3))] != nil {
            result.append(wordWithoutLastTwo + String(Word.charAt(s: literal, i: literal.count - 3)))
        }
        if (literal.hasSuffix("ed") || literal.hasSuffix("er")) && _literalList[wordWithoutLastTwo + "e"] != nil {
            result.append(wordWithoutLastTwo + "e")
        }
        if (literal.hasSuffix("ing") || literal.hasSuffix("est")) && _literalList[String(wordWithoutLastThree)] != nil {
            result.append(String(wordWithoutLastThree))
        }
        if literal.hasSuffix("ing") && _literalList[wordWithoutLastThree + String(Word.charAt(s: literal, i: literal.count - 4))] != nil {
            result.append(wordWithoutLastThree + String(Word.charAt(s: literal, i: literal.count - 4)))
        }
        if (literal.hasSuffix("ing") || literal.hasSuffix("est")) && _literalList[wordWithoutLastThree + "e"] != nil {
            result.append(wordWithoutLastThree + "e")
        }
        if literal.hasSuffix("ies") && _literalList[wordWithoutLastThree + "y"] != nil {
            result.append(wordWithoutLastThree + "y")
        }
        return result
    }
    
    /**
     * Finds SynSets with specified literal String and part of speech tag, then adds to the newly created SynSet list. Ex: cleanest - clean
     - Parameters:
        - literal: literal String to be searched in literal list
        - pos :    part of speech tag to be searched in SynSets
     - Returns: returns a list of SynSets with specified literal String and part of speech tag
     */
    public func getSynSetsWithPossiblyModifiedLiteral(literal: String, pos: Pos) -> [SynSet]{
        var result : [SynSet] = []
        let modifiedLiterals : [String] = getLiteralsWithPossibleModifiedLiteral(literal: literal)
        for modifiedLiteral in modifiedLiterals {
            if _literalList[modifiedLiteral] != nil {
                addSynSetsWithLiteralToList(result: &result, literal: modifiedLiteral, pos: pos)
            }
        }
        return result
    }
    
    /**
     * Adds the reverse relations to the SynSet.
     - Parameters:
        - synSet :          SynSet to add the reverse relations
        - semanticRelation:  relation whose reverse will be added
     */
    public func addReverseRelation(synSet: SynSet, semanticRelation: SemanticRelation){
        let otherSynSet = getSynSetWithId(synSetId: semanticRelation.getName())
        if otherSynSet != nil && SemanticRelation.reverse(semanticRelationType: semanticRelation.getRelationType()!) != nil {
            let otherRelation : SemanticRelation = SemanticRelation(name: synSet.getId(), relationType: SemanticRelation.reverse(semanticRelationType: semanticRelation.getRelationType()!)!)
            if !otherSynSet!.containsRelation(relation: otherRelation) {
                otherSynSet?.addRelation(relation: otherRelation)
            }
        }
    }
    
    /**
     * Removes the reverse relations from the SynSet.
     - Parameters:
        - synSet:           SynSet to remove the reverse relation
        - semanticRelation: relation whose reverse will be removed
     */
    public func removeReverseRelation(synSet: SynSet, semanticRelation: SemanticRelation){
        let otherSynSet = getSynSetWithId(synSetId: semanticRelation.getName())
        if otherSynSet != nil && SemanticRelation.reverse(semanticRelationType: semanticRelation.getRelationType()!) != nil {
            let otherRelation = SemanticRelation(name: synSet.getId(), relationType: SemanticRelation.reverse(semanticRelationType: semanticRelation.getRelationType()!)!)
            if otherSynSet!.containsRelation(relation: otherRelation) {
                otherSynSet!.removeRelation(relation: otherRelation)
            }
        }
    }
    
    /**
     * Loops through the SynSet list and adds the possible reverse relations.
     */
    private func equalizeSemanticRelations(){
        for synSet in _synSetList.values {
            for i in 0..<synSet.relationSize() {
                if synSet.getRelation(index: i) is SemanticRelation {
                    let relation = synSet.getRelation(index: i) as! SemanticRelation
                    addReverseRelation(synSet: synSet, semanticRelation: relation)
                }
            }
        }
    }
    
    /**
     * Creates a list of literals with a specified word, or possible words corresponding to morphological parse.
     - Parameters:
        - word:      literal String
        - parse:     morphological parse to get possible words
        - metaParse: metamorphic parse to get possible words
        - fsm:       finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of literal
     */
    public func constructLiterals(word: String, parse: MorphologicalParse, metaParse: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [Literal]{
        var result : [Literal] = []
        if parse.size() > 0 {
            if !parse.isPunctuation() && !parse.isCardinal() && !parse.isReal() {
                let possibleWords = fsm.getPossibleWords(morphologicalParse: parse, metamorphicParse: metaParse)
                for possibleWord in possibleWords {
                    result.append(contentsOf: getLiteralsWithName(literal: possibleWord))
                }
            } else {
                result.append(contentsOf: getLiteralsWithName(literal: word))
            }
        } else {
            result.append(contentsOf: getLiteralsWithName(literal: word))
        }
        return result
    }
    
    /**
     * Creates a list of SynSets with a specified word, or possible words corresponding to morphological parse.
     - Parameters:
        - word:      literal String  to get SynSets with
        - parse:     morphological parse to get SynSets with proper literals
        - metaParse: metamorphic parse to get possible words
        - fsm :      finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of SynSets
     */
    public func constructSynSets(word: String, parse: MorphologicalParse, metaParse: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [SynSet]{
        var result : [SynSet] = []
        if parse.size() > 0 {
            if parse.isProperNoun() {
                result.append(getSynSetWithLiteral(literal: "(özel isim)", sense: 1)!)
            }
            if parse.isTime() {
                result.append(getSynSetWithLiteral(literal: "(zaman)", sense: 1)!)
            }
            if parse.isDate() {
                result.append(getSynSetWithLiteral(literal: "(tarih)", sense: 1)!)
            }
            if parse.isHashTag() {
                result.append(getSynSetWithLiteral(literal: "(hashtag)", sense: 1)!)
            }
            if parse.isEmail() {
                result.append(getSynSetWithLiteral(literal: "(eposta)", sense: 1)!)
            }
            if parse.isOrdinal() {
                result.append(getSynSetWithLiteral(literal: "(sayı sıra sıfatı)", sense: 1)!)
            }
            if parse.isPercent() {
                result.append(getSynSetWithLiteral(literal: "(yüzde)", sense: 1)!)
            }
            if parse.isFraction() {
                result.append(getSynSetWithLiteral(literal: "(kesir sayı)", sense: 1)!)
            }
            if parse.isRange() {
                result.append(getSynSetWithLiteral(literal: "(sayı aralığı)", sense: 1)!)
            }
            if parse.isReal() {
                result.append(getSynSetWithLiteral(literal: "(reel sayı)", sense: 1)!)
            }
            if !parse.isPunctuation() && !parse.isCardinal() && !parse.isReal() {
                let possibleWords = fsm.getPossibleWords(morphologicalParse: parse, metamorphicParse: metaParse)
                for possibleWord in possibleWords {
                    let synSets = getSynSetsWithLiteral(literal: possibleWord)
                    if synSets.count > 0 {
                        for synSet in synSets {
                            if synSet.getPos() != nil && (parse.getPos() == "NOUN" || parse.getPos() == "ADVERB" || parse.getPos() == "VERB" || parse.getPos() == "ADJ" || parse.getPos() == "CONJ") {
                                if synSet.getPos() == Pos.NOUN {
                                    if parse.getPos() == "NOUN" || parse.getRootPos() == "NOUN" {
                                        result.append(synSet)
                                    }
                                } else {
                                    if synSet.getPos() == Pos.ADVERB {
                                        if parse.getPos() == "ADVERB" || parse.getRootPos() == "ADVERB" {
                                            result.append(synSet)
                                        }
                                    } else {
                                        if synSet.getPos() == Pos.VERB {
                                            if parse.getPos() == "VERB" || parse.getRootPos() == "VERB" {
                                                result.append(synSet)
                                            }
                                        } else {
                                            if synSet.getPos() == Pos.ADJECTIVE {
                                                if parse.getPos() == "ADJ" || parse.getRootPos() == "ADJ" {
                                                    result.append(synSet)
                                                }
                                            } else {
                                                if synSet.getPos() == Pos.CONJUNCTION {
                                                    if parse.getPos() == "CONJ" || parse.getRootPos() == "CONJ" {
                                                        result.append(synSet)
                                                    }
                                                } else {
                                                    result.append(synSet)
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                result.append(synSet)
                            }
                        }
                    }
                }
                if result.count == 0 {
                    for possibleWord in possibleWords {
                        let synSets = getSynSetsWithLiteral(literal: possibleWord)
                        result.append(contentsOf: synSets)
                    }
                }
            } else {
                result.append(contentsOf: getSynSetsWithLiteral(literal: word))
            }
            if parse.isCardinal() && result.count == 0 {
                result.append(getSynSetWithLiteral(literal: "(tam sayı)", sense: 1)!)
            }
        } else {
            result.append(contentsOf: getSynSetsWithLiteral(literal: word))
        }
        return result
    }
    
    /**
     * Returns a list of literals using 5 possible words gathered with the specified morphological parses and metamorphic parses.
     - Parameters:
        - morphologicalParse1: morphological parse to get possible words
        - morphologicalParse2: morphological parse to get possible words
        - morphologicalParse3: morphological parse to get possible words
        - morphologicalParse4: morphological parse to get possible words
        - morphologicalParse5: morphological parse to get possible words
        - metaParse1:          metamorphic parse to get possible words
        - metaParse2:          metamorphic parse to get possible words
        - metaParse3 :         metamorphic parse to get possible words
        - metaParse4:         metamorphic parse to get possible words
        - metaParse5 :        metamorphic parse to get possible words
        - fsm:                 finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of literals
     */
    public func constructIdiomLiterals(morphologicalParse1: MorphologicalParse, morphologicalParse2: MorphologicalParse, morphologicalParse3: MorphologicalParse, morphologicalParse4: MorphologicalParse, morphologicalParse5: MorphologicalParse, metaParse1: MetamorphicParse, metaParse2: MetamorphicParse, metaParse3: MetamorphicParse,  metaParse4: MetamorphicParse, metaParse5: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [Literal]{
        var result : [Literal] = []
        let possibleWords1 = fsm.getPossibleWords(morphologicalParse: morphologicalParse1, metamorphicParse: metaParse1)
        let possibleWords2 = fsm.getPossibleWords(morphologicalParse: morphologicalParse2, metamorphicParse: metaParse2)
        let possibleWords3 = fsm.getPossibleWords(morphologicalParse: morphologicalParse3, metamorphicParse: metaParse3)
        let possibleWords4 = fsm.getPossibleWords(morphologicalParse: morphologicalParse4, metamorphicParse: metaParse4)
        let possibleWords5 = fsm.getPossibleWords(morphologicalParse: morphologicalParse5, metamorphicParse: metaParse5)
        for possibleWord1 in possibleWords1 {
            for possibleWord2 in possibleWords2 {
                for possibleWord3 in possibleWords3 {
                    for possibleWord4 in possibleWords4 {
                        for possibleWord5 in possibleWords5 {
                            result.append(contentsOf: getLiteralsWithName(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3 + " " + possibleWord4 + " " + possibleWord5))
                        }
                    }
                }
            }
        }
        return result
    }

    /**
     * Returns a list of synsets using 5 possible words gathered with the specified morphological parses and metamorphic parses.
     - Parameters:
        - morphologicalParse1: morphological parse to get possible words
        - morphologicalParse2: morphological parse to get possible words
        - morphologicalParse3: morphological parse to get possible words
        - morphologicalParse4: morphological parse to get possible words
        - morphologicalParse5: morphological parse to get possible words
        - metaParse1:          metamorphic parse to get possible words
        - metaParse2:          metamorphic parse to get possible words
        - metaParse3 :         metamorphic parse to get possible words
        - metaParse4:         metamorphic parse to get possible words
        - metaParse5 :        metamorphic parse to get possible words
        - fsm:                 finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of synsets
     */
    public func constructIdiomSynSets(morphologicalParse1: MorphologicalParse, morphologicalParse2: MorphologicalParse, morphologicalParse3: MorphologicalParse, morphologicalParse4: MorphologicalParse, morphologicalParse5: MorphologicalParse, metaParse1: MetamorphicParse, metaParse2: MetamorphicParse, metaParse3: MetamorphicParse,  metaParse4: MetamorphicParse, metaParse5: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [SynSet]{
        var result : [SynSet] = []
        let possibleWords1 = fsm.getPossibleWords(morphologicalParse: morphologicalParse1, metamorphicParse: metaParse1)
        let possibleWords2 = fsm.getPossibleWords(morphologicalParse: morphologicalParse2, metamorphicParse: metaParse2)
        let possibleWords3 = fsm.getPossibleWords(morphologicalParse: morphologicalParse3, metamorphicParse: metaParse3)
        let possibleWords4 = fsm.getPossibleWords(morphologicalParse: morphologicalParse4, metamorphicParse: metaParse4)
        let possibleWords5 = fsm.getPossibleWords(morphologicalParse: morphologicalParse5, metamorphicParse: metaParse5)
        for possibleWord1 in possibleWords1 {
            for possibleWord2 in possibleWords2 {
                for possibleWord3 in possibleWords3 {
                    for possibleWord4 in possibleWords4 {
                        for possibleWord5 in possibleWords5 {
                            if numberOfSynSetsWithLiteral(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3 + " " + possibleWord4 + " " + possibleWord5) > 0{
                                result.append(contentsOf: getSynSetsWithLiteral(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3 + " " + possibleWord4 + " " + possibleWord5))
                            }
                        }
                    }
                }
            }
        }
        return result
    }

    /**
     * Returns a list of literals using 4 possible words gathered with the specified morphological parses and metamorphic parses.
     - Parameters:
        - morphologicalParse1: morphological parse to get possible words
        - morphologicalParse2: morphological parse to get possible words
        - morphologicalParse3: morphological parse to get possible words
        - morphologicalParse4: morphological parse to get possible words
        - metaParse1:          metamorphic parse to get possible words
        - metaParse2:          metamorphic parse to get possible words
        - metaParse3 :         metamorphic parse to get possible words
        - metaParse4:         metamorphic parse to get possible words
        - fsm:                 finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of literals
     */
    public func constructIdiomLiterals(morphologicalParse1: MorphologicalParse, morphologicalParse2: MorphologicalParse, morphologicalParse3: MorphologicalParse, morphologicalParse4: MorphologicalParse, metaParse1: MetamorphicParse, metaParse2: MetamorphicParse, metaParse3: MetamorphicParse,  metaParse4: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [Literal]{
        var result : [Literal] = []
        let possibleWords1 = fsm.getPossibleWords(morphologicalParse: morphologicalParse1, metamorphicParse: metaParse1)
        let possibleWords2 = fsm.getPossibleWords(morphologicalParse: morphologicalParse2, metamorphicParse: metaParse2)
        let possibleWords3 = fsm.getPossibleWords(morphologicalParse: morphologicalParse3, metamorphicParse: metaParse3)
        let possibleWords4 = fsm.getPossibleWords(morphologicalParse: morphologicalParse4, metamorphicParse: metaParse4)
        for possibleWord1 in possibleWords1 {
            for possibleWord2 in possibleWords2 {
                for possibleWord3 in possibleWords3 {
                    for possibleWord4 in possibleWords4 {
                        result.append(contentsOf: getLiteralsWithName(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3 + " " + possibleWord4))
                    }
                }
            }
        }
        return result
    }

    /**
     * Returns a list of synsets using 4 possible words gathered with the specified morphological parses and metamorphic parses.
     - Parameters:
        - morphologicalParse1: morphological parse to get possible words
        - morphologicalParse2: morphological parse to get possible words
        - morphologicalParse3: morphological parse to get possible words
        - morphologicalParse4: morphological parse to get possible words
        - metaParse1:          metamorphic parse to get possible words
        - metaParse2:          metamorphic parse to get possible words
        - metaParse3 :         metamorphic parse to get possible words
        - metaParse4:         metamorphic parse to get possible words
        - fsm:                 finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of synsets
     */
    public func constructIdiomSynSets(morphologicalParse1: MorphologicalParse, morphologicalParse2: MorphologicalParse, morphologicalParse3: MorphologicalParse, morphologicalParse4: MorphologicalParse, metaParse1: MetamorphicParse, metaParse2: MetamorphicParse, metaParse3: MetamorphicParse,  metaParse4: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [SynSet]{
        var result : [SynSet] = []
        let possibleWords1 = fsm.getPossibleWords(morphologicalParse: morphologicalParse1, metamorphicParse: metaParse1)
        let possibleWords2 = fsm.getPossibleWords(morphologicalParse: morphologicalParse2, metamorphicParse: metaParse2)
        let possibleWords3 = fsm.getPossibleWords(morphologicalParse: morphologicalParse3, metamorphicParse: metaParse3)
        let possibleWords4 = fsm.getPossibleWords(morphologicalParse: morphologicalParse4, metamorphicParse: metaParse4)
        for possibleWord1 in possibleWords1 {
            for possibleWord2 in possibleWords2 {
                for possibleWord3 in possibleWords3 {
                    for possibleWord4 in possibleWords4 {
                        if numberOfSynSetsWithLiteral(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3 + " " + possibleWord4) > 0{
                            result.append(contentsOf: getSynSetsWithLiteral(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3 + " " + possibleWord4))
                        }
                    }
                }
            }
        }
        return result
    }

    /**
     * Returns a list of literals using 3 possible words gathered with the specified morphological parses and metamorphic parses.
     - Parameters:
        - morphologicalParse1: morphological parse to get possible words
        - morphologicalParse2: morphological parse to get possible words
        - morphologicalParse3: morphological parse to get possible words
        - metaParse1:          metamorphic parse to get possible words
        - metaParse2:          metamorphic parse to get possible words
        - metaParse3 :         metamorphic parse to get possible words
        - fsm:                 finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of literals
     */
    public func constructIdiomLiterals(morphologicalParse1: MorphologicalParse, morphologicalParse2: MorphologicalParse, morphologicalParse3: MorphologicalParse, metaParse1: MetamorphicParse, metaParse2: MetamorphicParse, metaParse3: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [Literal]{
        var result : [Literal] = []
        let possibleWords1 = fsm.getPossibleWords(morphologicalParse: morphologicalParse1, metamorphicParse: metaParse1)
        let possibleWords2 = fsm.getPossibleWords(morphologicalParse: morphologicalParse2, metamorphicParse: metaParse2)
        let possibleWords3 = fsm.getPossibleWords(morphologicalParse: morphologicalParse3, metamorphicParse: metaParse3)
        for possibleWord1 in possibleWords1 {
            for possibleWord2 in possibleWords2 {
                for possibleWord3 in possibleWords3 {
                    result.append(contentsOf: getLiteralsWithName(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3))
                }
            }
        }
        return result
    }

    /**
     * Returns a list of synsets using 3 possible words gathered with the specified morphological parses and metamorphic parses.
     - Parameters:
        - morphologicalParse1: morphological parse to get possible words
        - morphologicalParse2: morphological parse to get possible words
        - morphologicalParse3: morphological parse to get possible words
        - metaParse1:          metamorphic parse to get possible words
        - metaParse2:          metamorphic parse to get possible words
        - metaParse3 :         metamorphic parse to get possible words
        - fsm:                 finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of synsets
     */
    public func constructIdiomSynSets(morphologicalParse1: MorphologicalParse, morphologicalParse2: MorphologicalParse, morphologicalParse3: MorphologicalParse, metaParse1: MetamorphicParse, metaParse2: MetamorphicParse, metaParse3: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [SynSet]{
        var result : [SynSet] = []
        let possibleWords1 = fsm.getPossibleWords(morphologicalParse: morphologicalParse1, metamorphicParse: metaParse1)
        let possibleWords2 = fsm.getPossibleWords(morphologicalParse: morphologicalParse2, metamorphicParse: metaParse2)
        let possibleWords3 = fsm.getPossibleWords(morphologicalParse: morphologicalParse3, metamorphicParse: metaParse3)
        for possibleWord1 in possibleWords1 {
            for possibleWord2 in possibleWords2 {
                for possibleWord3 in possibleWords3 {
                    if numberOfSynSetsWithLiteral(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3 ) > 0{
                        result.append(contentsOf: getSynSetsWithLiteral(literal: possibleWord1 + " " + possibleWord2 + " " + possibleWord3))
                    }
                }
            }
        }
        return result
    }

    /**
     * Returns a list of literals using 2 possible words gathered with the specified morphological parses and metamorphic parses.
     - Parameters:
        - morphologicalParse1: morphological parse to get possible words
        - morphologicalParse2: morphological parse to get possible words
        - metaParse1:          metamorphic parse to get possible words
        - metaParse2:          metamorphic parse to get possible words
        - fsm:                 finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of literals
     */
    public func constructIdiomLiterals(morphologicalParse1: MorphologicalParse, morphologicalParse2: MorphologicalParse, metaParse1: MetamorphicParse, metaParse2: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [Literal]{
        var result : [Literal] = []
        let possibleWords1 = fsm.getPossibleWords(morphologicalParse: morphologicalParse1, metamorphicParse: metaParse1)
        let possibleWords2 = fsm.getPossibleWords(morphologicalParse: morphologicalParse2, metamorphicParse: metaParse2)
        for possibleWord1 in possibleWords1 {
            for possibleWord2 in possibleWords2 {
                result.append(contentsOf: getLiteralsWithName(literal: possibleWord1 + " " + possibleWord2))
            }
        }
        return result
    }

    /**
     * Returns a list of synsets using 2 possible words gathered with the specified morphological parses and metamorphic parses.
     - Parameters:
        - morphologicalParse1: morphological parse to get possible words
        - morphologicalParse2: morphological parse to get possible words
        - metaParse1:          metamorphic parse to get possible words
        - metaParse2:          metamorphic parse to get possible words
        - metaParse3 :         metamorphic parse to get possible words
        - fsm:                 finite state machine morphological analyzer to be used at getting possible words
     - Returns: a list of synsets
     */
    public func constructIdiomSynSets(morphologicalParse1: MorphologicalParse, morphologicalParse2: MorphologicalParse, metaParse1: MetamorphicParse, metaParse2: MetamorphicParse, fsm: FsmMorphologicalAnalyzer) -> [SynSet]{
        var result : [SynSet] = []
        let possibleWords1 = fsm.getPossibleWords(morphologicalParse: morphologicalParse1, metamorphicParse: metaParse1)
        let possibleWords2 = fsm.getPossibleWords(morphologicalParse: morphologicalParse2, metamorphicParse: metaParse2)
        for possibleWord1 in possibleWords1 {
            for possibleWord2 in possibleWords2 {
                if numberOfSynSetsWithLiteral(literal: possibleWord1 + " " + possibleWord2) > 0{
                    result.append(contentsOf: getSynSetsWithLiteral(literal: possibleWord1 + " " + possibleWord2))
                }
            }
        }
        return result
    }
    
    /**
     * Sorts definitions of SynSets in SynSet list according to their lengths.
     */
    public func sortDefinitions(){
        for synSet in synSetList() {
            synSet.sortDefinitions()
        }
    }
    
    /**
     * Returns a list of SynSets with the interlingual relations of a specified SynSet ID.
     - Parameters:
        - synSetId: SynSet ID to be searched
     - Returns: a list of SynSets with the interlingual relations of a specified SynSet ID
     */
    public func getInterlingual(synSetId: String) -> [SynSet]{
        if interlingualList[synSetId] != nil {
            return interlingualList[synSetId]!
        } else {
            return []
        }
    }

    /**
     * Returns the size of the SynSet list.
     *
        - Returns: the size of the SynSet list
     */
    public func size() -> Int{
        return _synSetList.count
    }
    
    /**
     * Conduct common operations between similarity metrics.
     - Parameters:
        - pathToRootOfSynSet1: first list of Strings
        - pathToRootOfSynSet2: second list of Strings
     - Returns: path length
     */
    public func findPathLength(pathToRootOfSynSet1: [String], pathToRootOfSynSet2: [String]) -> Int{
        for i in 0..<pathToRootOfSynSet1.count {
            let foundIndex = pathToRootOfSynSet2.firstIndex(of: pathToRootOfSynSet1[i])
            if foundIndex != -1 {
                return i + foundIndex! - 1
            }
        }
        return -1
    }
    
    /**
     * Returns the depth of path.
     - Parameters:
        - pathToRootOfSynSet1: first list of Strings
        - pathToRootOfSynSet2: second list of Strings
     - Returns: LCS depth
     */
    public func findLCSdepth(pathToRootOfSynSet1: [String], pathToRootOfSynSet2: [String]) -> Int?{
        let temp = findLCS(pathToRootOfSynSet1: pathToRootOfSynSet1, pathToRootOfSynSet2: pathToRootOfSynSet2)
        if temp != nil {
            return temp?.1
        }
        return nil
    }
    
    /**
     * Returns the ID of LCS of path.
     - Parameters:
        - pathToRootOfSynSet1: first list of Strings
        - pathToRootOfSynSet2: second list of Strings
     - Returns: LCS ID
     */
    public func findLCSid(pathToRootOfSynSet1: [String], pathToRootOfSynSet2: [String]) -> String?{
        let temp = findLCS(pathToRootOfSynSet1: pathToRootOfSynSet1, pathToRootOfSynSet2: pathToRootOfSynSet2)
        if temp != nil {
            return temp?.0
        }
        return nil
    }
    
    /**
     * Returns depth and ID of the LCS.
     - Parameters:
        - pathToRootOfSynSet1: first list of Strings
        - pathToRootOfSynSet2: second list of Strings
     - Returns: depth and ID of the LCS
     */
    public func findLCS(pathToRootOfSynSet1: [String], pathToRootOfSynSet2: [String]) -> (String, Int)?{
        for i in 0..<pathToRootOfSynSet1.count {
            let LCSid = pathToRootOfSynSet1[i]
            if pathToRootOfSynSet2.contains(LCSid) {
                return (LCSid, pathToRootOfSynSet1.count - i + 1)
            }
        }
        return nil
    }
    
    /**
     * Finds the path to the root node of a SynSets.
     - Parameters:
        - synSet: SynSet whose root path will be found
     - Returns: list of String corresponding to nodes in the path
     */
    public func findPathToRoot(synSet: SynSet) -> [String]{
        var pathToRoot : [String] = []
        var iterated : SynSet? = synSet
        while iterated != nil {
            if pathToRoot.contains(iterated!.getId()) {
                break
            }
            pathToRoot.append(iterated!.getId())
            iterated = percolateUp(root: iterated!)
        }
        return pathToRoot
    }
    
    /**
     * Finds the parent of a node. It does not move until the root, instead it goes one level up.
     - Parameters:
        - root: SynSet whose parent will be find
     - Returns: parent SynSet
     */
    public func percolateUp(root: SynSet) -> SynSet?{
        for i in 0..<root.relationSize() {
            let r = root.getRelation(index: i)
            if r is SemanticRelation {
                if (r as! SemanticRelation).getRelationType() == SemanticRelationType.HYPERNYM || (r as! SemanticRelation).getRelationType() == SemanticRelationType.INSTANCE_HYPERNYM {
                    return getSynSetWithId(synSetId: r.getName())
                }
            }
        }
        return nil
    }
}
