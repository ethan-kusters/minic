// Generated from Mini.g4 by ANTLR 4.8

   /* package declaration here */

import Antlr4

open class MiniLexer: Lexer {

	internal static var _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = MiniLexer._ATN.getNumberOfDecisions()
          for i in 0..<length {
          	    decisionToDFA.append(DFA(MiniLexer._ATN.getDecisionState(i)!, i))
          }
           return decisionToDFA
     }()

	internal static let _sharedContextCache = PredictionContextCache()

	public
	static let T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, 
            T__8=9, T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, 
            T__15=16, T__16=17, T__17=18, T__18=19, T__19=20, T__20=21, 
            T__21=22, T__22=23, T__23=24, T__24=25, T__25=26, T__26=27, 
            T__27=28, T__28=29, T__29=30, T__30=31, T__31=32, T__32=33, 
            T__33=34, T__34=35, T__35=36, T__36=37, T__37=38, ID=39, INTEGER=40, 
            WS=41, COMMENT=42

	public
	static let channelNames: [String] = [
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN"
	]

	public
	static let modeNames: [String] = [
		"DEFAULT_MODE"
	]

	public
	static let ruleNames: [String] = [
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "T__16", 
		"T__17", "T__18", "T__19", "T__20", "T__21", "T__22", "T__23", "T__24", 
		"T__25", "T__26", "T__27", "T__28", "T__29", "T__30", "T__31", "T__32", 
		"T__33", "T__34", "T__35", "T__36", "T__37", "ID", "INTEGER", "WS", "COMMENT"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'struct'", "'{'", "'}'", "';'", "'int'", "'bool'", "','", "'fun'", 
		"'('", "')'", "'void'", "'='", "'read'", "'print'", "'endl'", "'if'", 
		"'else'", "'while'", "'delete'", "'return'", "'.'", "'-'", "'!'", "'*'", 
		"'/'", "'+'", "'<'", "'>'", "'<='", "'>='", "'=='", "'!='", "'&&'", "'||'", 
		"'true'", "'false'", "'new'", "'null'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "ID", "INTEGER", 
		"WS", "COMMENT"
	]
	public
	static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)


	override open
	func getVocabulary() -> Vocabulary {
		return MiniLexer.VOCABULARY
	}

	public
	required init(_ input: CharStream) {
	    RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION)
		super.init(input)
		_interp = LexerATNSimulator(self, MiniLexer._ATN, MiniLexer._decisionToDFA, MiniLexer._sharedContextCache)
	}

	override open
	func getGrammarFileName() -> String { return "Mini.g4" }

	override open
	func getRuleNames() -> [String] { return MiniLexer.ruleNames }

	override open
	func getSerializedATN() -> String { return MiniLexer._serializedATN }

	override open
	func getChannelNames() -> [String] { return MiniLexer.channelNames }

	override open
	func getModeNames() -> [String] { return MiniLexer.modeNames }

	override open
	func getATN() -> ATN { return MiniLexer._ATN }


	public
	static let _serializedATN: String = MiniLexerATN().jsonString

	public
	static let _ATN: ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}