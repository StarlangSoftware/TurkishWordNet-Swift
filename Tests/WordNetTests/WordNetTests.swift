import XCTest
import Dictionary
@testable import WordNet

final class WordNetTest: XCTestCase {
    var turkish : WordNet = WordNet()
    
    func testSize() {
        XCTAssertEqual(77100, turkish.size())
    }

    func testSynSetList() {
        var literalCount : Int = 0
        for synSet in turkish.synSetList() {
            literalCount += synSet.getSynonym().literalSize()
        }
        XCTAssertEqual(109007, literalCount)
    }

    func testWikiPages() {
        var wikiCount : Int = 0
        for synSet in turkish.synSetList() {
            if synSet.getWikiPage() != ""{
                wikiCount += 1
            }
        }
        XCTAssertEqual(10987, wikiCount)
    }

    func testLiteralList() {
        XCTAssertEqual(81062, turkish.literalList().count)
    }
    
    func testGetSynSetWithId(){
        XCTAssertNotNil(turkish.getSynSetWithId(synSetId: "TUR10-0000040"))
        XCTAssertNotNil(turkish.getSynSetWithId(synSetId: "TUR10-0648550"))
        XCTAssertNotNil(turkish.getSynSetWithId(synSetId: "TUR10-1034170"))
        XCTAssertNotNil(turkish.getSynSetWithId(synSetId: "TUR10-1047180"))
        XCTAssertNotNil(turkish.getSynSetWithId(synSetId: "TUR10-1196250"))
    }
    
    func testGetSynSetWithLiteral(){
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "sıradaki", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "Türkçesi", sense: 2))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "tropikal orman", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "mesut olmak", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "acı badem kurabiyesi", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "açık kapı siyaseti", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "bir baştan bir başa", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "eş zamanlı dil bilimi", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "bir iğne bir iplik olmak", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "yedi kat yerin dibine geçmek", sense: 2))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "kedi gibi dört ayak üzerine düşmek", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "bir kulağından girip öbür kulağından çıkmak", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "anasından emdiği süt burnundan fitil fitil gelmek", sense: 1))
        XCTAssertNotNil(turkish.getSynSetWithLiteral(literal: "bir ayak üstünde kırk yalanın belini bükmek", sense: 1))
    }
    
    func testNumberOfSynSetsWithLiteral(){
        XCTAssertEqual(1, turkish.numberOfSynSetsWithLiteral(literal: "yolcu etmek"))
        XCTAssertEqual(2, turkish.numberOfSynSetsWithLiteral(literal: "açık pembe"))
        XCTAssertEqual(3, turkish.numberOfSynSetsWithLiteral(literal: "bürokrasi"))
        XCTAssertEqual(4, turkish.numberOfSynSetsWithLiteral(literal: "bordür"))
        XCTAssertEqual(5, turkish.numberOfSynSetsWithLiteral(literal: "duygulanım"))
        XCTAssertEqual(6, turkish.numberOfSynSetsWithLiteral(literal: "sarsıntı"))
        XCTAssertEqual(7, turkish.numberOfSynSetsWithLiteral(literal: "kuvvetli"))
        XCTAssertEqual(8, turkish.numberOfSynSetsWithLiteral(literal: "merkez"))
        XCTAssertEqual(9, turkish.numberOfSynSetsWithLiteral(literal: "yüksek"))
        XCTAssertEqual(10, turkish.numberOfSynSetsWithLiteral(literal: "biçim"))
        XCTAssertEqual(11, turkish.numberOfSynSetsWithLiteral(literal: "yurt"))
        XCTAssertEqual(12, turkish.numberOfSynSetsWithLiteral(literal: "iğne"))
        XCTAssertEqual(13, turkish.numberOfSynSetsWithLiteral(literal: "kol"))
        XCTAssertEqual(14, turkish.numberOfSynSetsWithLiteral(literal: "alem"))
        XCTAssertEqual(15, turkish.numberOfSynSetsWithLiteral(literal: "taban"))
        XCTAssertEqual(16, turkish.numberOfSynSetsWithLiteral(literal: "yer"))
        XCTAssertEqual(17, turkish.numberOfSynSetsWithLiteral(literal: "ağır"))
        XCTAssertEqual(18, turkish.numberOfSynSetsWithLiteral(literal: "iş"))
        XCTAssertEqual(19, turkish.numberOfSynSetsWithLiteral(literal: "dökmek"))
        XCTAssertEqual(20, turkish.numberOfSynSetsWithLiteral(literal: "kaldırmak"))
        XCTAssertEqual(21, turkish.numberOfSynSetsWithLiteral(literal: "girmek"))
        XCTAssertEqual(22, turkish.numberOfSynSetsWithLiteral(literal: "gitmek"))
        XCTAssertEqual(23, turkish.numberOfSynSetsWithLiteral(literal: "vermek"))
        XCTAssertEqual(24, turkish.numberOfSynSetsWithLiteral(literal: "olmak"))
        XCTAssertEqual(25, turkish.numberOfSynSetsWithLiteral(literal: "bırakmak"))
        XCTAssertEqual(26, turkish.numberOfSynSetsWithLiteral(literal: "çıkarmak"))
        XCTAssertEqual(27, turkish.numberOfSynSetsWithLiteral(literal: "kesmek"))
        XCTAssertEqual(28, turkish.numberOfSynSetsWithLiteral(literal: "açmak"))
        XCTAssertEqual(33, turkish.numberOfSynSetsWithLiteral(literal: "düşmek"))
        XCTAssertEqual(38, turkish.numberOfSynSetsWithLiteral(literal: "atmak"))
        XCTAssertEqual(39, turkish.numberOfSynSetsWithLiteral(literal: "geçmek"))
        XCTAssertEqual(44, turkish.numberOfSynSetsWithLiteral(literal: "çekmek"))
        XCTAssertEqual(50, turkish.numberOfSynSetsWithLiteral(literal: "tutmak"))
        XCTAssertEqual(59, turkish.numberOfSynSetsWithLiteral(literal: "çıkmak"))
    }
    
    func testGetSynSetsWithPartOfSpeech(){
        XCTAssertEqual(43871, turkish.getSynSetsWithPartOfSpeech(pos: Pos.NOUN).count)
        XCTAssertEqual(17776, turkish.getSynSetsWithPartOfSpeech(pos: Pos.VERB).count)
        XCTAssertEqual(12406, turkish.getSynSetsWithPartOfSpeech(pos: Pos.ADJECTIVE).count)
        XCTAssertEqual(2549, turkish.getSynSetsWithPartOfSpeech(pos: Pos.ADVERB).count)
        XCTAssertEqual(339, turkish.getSynSetsWithPartOfSpeech(pos: Pos.INTERJECTION).count)
        XCTAssertEqual(68, turkish.getSynSetsWithPartOfSpeech(pos: Pos.PRONOUN).count)
        XCTAssertEqual(61, turkish.getSynSetsWithPartOfSpeech(pos: Pos.CONJUNCTION).count)
        XCTAssertEqual(30, turkish.getSynSetsWithPartOfSpeech(pos: Pos.PREPOSITION).count)
    }
    
    func testGetInterlingual(){
        XCTAssertEqual(1, turkish.getInterlingual(synSetId: "ENG31-05674544-n").count)
        XCTAssertEqual(2, turkish.getInterlingual(synSetId: "ENG31-00220161-r").count)
        XCTAssertEqual(3, turkish.getInterlingual(synSetId: "ENG31-02294200-v").count)
        XCTAssertEqual(4, turkish.getInterlingual(synSetId: "ENG31-06205574-n").count)
        XCTAssertEqual(5, turkish.getInterlingual(synSetId: "ENG31-02687605-v").count)
        XCTAssertEqual(6, turkish.getInterlingual(synSetId: "ENG31-01099197-n").count)
        XCTAssertEqual(7, turkish.getInterlingual(synSetId: "ENG31-00587299-n").count)
        XCTAssertEqual(9, turkish.getInterlingual(synSetId: "ENG31-02214901-v").count)
        XCTAssertEqual(10, turkish.getInterlingual(synSetId: "ENG31-02733337-v").count)
        XCTAssertEqual(19, turkish.getInterlingual(synSetId: "ENG31-00149403-v").count)
    }
    
    func testFindPathToRoot(){
        XCTAssertEqual(1, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0814560")!).count)
        XCTAssertEqual(2, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0755370")!).count)
        XCTAssertEqual(3, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0516010")!).count)
        XCTAssertEqual(4, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0012910")!).count)
        XCTAssertEqual(5, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0046370")!).count)
        XCTAssertEqual(6, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0186560")!).count)
        XCTAssertEqual(7, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0172740")!).count)
        XCTAssertEqual(8, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0195110")!).count)
        XCTAssertEqual(9, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0285060")!).count)
        XCTAssertEqual(10, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0066050")!).count)
        XCTAssertEqual(11, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0226380")!).count)
        XCTAssertEqual(12, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0490230")!).count)
        XCTAssertEqual(13, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-1198750")!).count)
        XCTAssertEqual(12, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0412120")!).count)
        XCTAssertEqual(13, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-1116690")!).count)
        XCTAssertEqual(13, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0621870")!).count)
        XCTAssertEqual(14, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0822980")!).count)
        XCTAssertEqual(15, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0178450")!).count)
        XCTAssertEqual(16, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0600460")!).count)
        XCTAssertEqual(17, turkish.findPathToRoot(synSet: turkish.getSynSetWithId(synSetId: "TUR10-0656390")!).count)
    }

    static var allTests = [
        ("testExample1", testSize),
        ("testExample2", testSynSetList),
        ("testExample3", testLiteralList),
        ("testExample4", testGetSynSetWithId),
        ("testExample5", testGetSynSetWithLiteral),
        ("testExample6", testNumberOfSynSetsWithLiteral),
        ("testExample7", testGetSynSetsWithPartOfSpeech),
        ("testExample8", testGetInterlingual),
        ("testExample9", testFindPathToRoot),
    ]
}
