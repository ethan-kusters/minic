// Generated from Mini.g4 by ANTLR 4.8

   /* package declaration here */

import Antlr4

open class MiniParser: Parser {

	internal static var _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = MiniParser._ATN.getNumberOfDecisions()
          for i in 0..<length {
            decisionToDFA.append(DFA(MiniParser._ATN.getDecisionState(i)!, i))
           }
           return decisionToDFA
     }()

	internal static let _sharedContextCache = PredictionContextCache()

	public
	enum Tokens: Int {
		case EOF = -1, T__0 = 1, T__1 = 2, T__2 = 3, T__3 = 4, T__4 = 5, T__5 = 6, 
                 T__6 = 7, T__7 = 8, T__8 = 9, T__9 = 10, T__10 = 11, T__11 = 12, 
                 T__12 = 13, T__13 = 14, T__14 = 15, T__15 = 16, T__16 = 17, 
                 T__17 = 18, T__18 = 19, T__19 = 20, T__20 = 21, T__21 = 22, 
                 T__22 = 23, T__23 = 24, T__24 = 25, T__25 = 26, T__26 = 27, 
                 T__27 = 28, T__28 = 29, T__29 = 30, T__30 = 31, T__31 = 32, 
                 T__32 = 33, T__33 = 34, T__34 = 35, T__35 = 36, T__36 = 37, 
                 T__37 = 38, ID = 39, INTEGER = 40, WS = 41, COMMENT = 42
	}

	public
	static let RULE_program = 0, RULE_types = 1, RULE_typeDeclaration = 2, 
            RULE_nestedDecl = 3, RULE_decl = 4, RULE_type = 5, RULE_declarations = 6, 
            RULE_declaration = 7, RULE_functions = 8, RULE_function = 9, 
            RULE_parameters = 10, RULE_returnType = 11, RULE_statement = 12, 
            RULE_block = 13, RULE_statementList = 14, RULE_lvalue = 15, 
            RULE_expression = 16, RULE_arguments = 17

	public
	static let ruleNames: [String] = [
		"program", "types", "typeDeclaration", "nestedDecl", "decl", "type", "declarations", 
		"declaration", "functions", "function", "parameters", "returnType", "statement", 
		"block", "statementList", "lvalue", "expression", "arguments"
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
	func getGrammarFileName() -> String { return "Mini.g4" }

	override open
	func getRuleNames() -> [String] { return MiniParser.ruleNames }

	override open
	func getSerializedATN() -> String { return MiniParser._serializedATN }

	override open
	func getATN() -> ATN { return MiniParser._ATN }


	override open
	func getVocabulary() -> Vocabulary {
	    return MiniParser.VOCABULARY
	}

	override public
	init(_ input:TokenStream) throws {
	    RuntimeMetaData.checkVersion("4.8", RuntimeMetaData.VERSION)
		try super.init(input)
		_interp = ParserATNSimulator(self,MiniParser._ATN,MiniParser._decisionToDFA, MiniParser._sharedContextCache)
	}


	public class ProgramContext: ParserRuleContext {
			open
			func types() -> TypesContext? {
				return getRuleContext(TypesContext.self, 0)
			}
			open
			func declarations() -> DeclarationsContext? {
				return getRuleContext(DeclarationsContext.self, 0)
			}
			open
			func functions() -> FunctionsContext? {
				return getRuleContext(FunctionsContext.self, 0)
			}
			open
			func EOF() -> TerminalNode? {
				return getToken(MiniParser.Tokens.EOF.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_program
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterProgram(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitProgram(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitProgram(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitProgram(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func program() throws -> ProgramContext {
        let _localctx: ProgramContext = ProgramContext(_ctx, getState())
		try enterRule(_localctx, 0, MiniParser.RULE_program)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(36)
		 	try types()
		 	setState(37)
		 	try declarations()
		 	setState(38)
		 	try functions()
		 	setState(39)
		 	try match(MiniParser.Tokens.EOF.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypesContext: ParserRuleContext {
			open
			func typeDeclaration() -> [TypeDeclarationContext] {
				return getRuleContexts(TypeDeclarationContext.self)
			}
			open
			func typeDeclaration(_ i: Int) -> TypeDeclarationContext? {
				return getRuleContext(TypeDeclarationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_types
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterTypes(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitTypes(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitTypes(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitTypes(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func types() throws -> TypesContext {
        let _localctx: TypesContext = TypesContext(_ctx, getState())
		try enterRule(_localctx, 2, MiniParser.RULE_types)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(48)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,1, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(44)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,0,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(41)
		 				try typeDeclaration()

		 		 
		 			}
		 			setState(46)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,0,_ctx)
		 		}

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeDeclarationContext: ParserRuleContext {
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}
			open
			func nestedDecl() -> NestedDeclContext? {
				return getRuleContext(NestedDeclContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_typeDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterTypeDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitTypeDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitTypeDeclaration(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitTypeDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeDeclaration() throws -> TypeDeclarationContext {
        let _localctx: TypeDeclarationContext = TypeDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 4, MiniParser.RULE_typeDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(50)
		 	try match(MiniParser.Tokens.T__0.rawValue)
		 	setState(51)
		 	try match(MiniParser.Tokens.ID.rawValue)
		 	setState(52)
		 	try match(MiniParser.Tokens.T__1.rawValue)
		 	setState(53)
		 	try nestedDecl()
		 	setState(54)
		 	try match(MiniParser.Tokens.T__2.rawValue)
		 	setState(55)
		 	try match(MiniParser.Tokens.T__3.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class NestedDeclContext: ParserRuleContext {
			open
			func decl() -> [DeclContext] {
				return getRuleContexts(DeclContext.self)
			}
			open
			func decl(_ i: Int) -> DeclContext? {
				return getRuleContext(DeclContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_nestedDecl
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterNestedDecl(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitNestedDecl(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitNestedDecl(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitNestedDecl(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func nestedDecl() throws -> NestedDeclContext {
        let _localctx: NestedDeclContext = NestedDeclContext(_ctx, getState())
		try enterRule(_localctx, 6, MiniParser.RULE_nestedDecl)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(60) 
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	repeat {
		 		setState(57)
		 		try decl()
		 		setState(58)
		 		try match(MiniParser.Tokens.T__3.rawValue)


		 		setState(62); 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	} while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MiniParser.Tokens.T__0.rawValue,MiniParser.Tokens.T__4.rawValue,MiniParser.Tokens.T__5.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }())

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DeclContext: ParserRuleContext {
			open
			func type() -> TypeContext? {
				return getRuleContext(TypeContext.self, 0)
			}
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_decl
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterDecl(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitDecl(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitDecl(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitDecl(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func decl() throws -> DeclContext {
        let _localctx: DeclContext = DeclContext(_ctx, getState())
		try enterRule(_localctx, 8, MiniParser.RULE_decl)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(64)
		 	try type()
		 	setState(65)
		 	try match(MiniParser.Tokens.ID.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_type
		}
	}
	public class BoolTypeContext: TypeContext {

		public
		init(_ ctx: TypeContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterBoolType(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitBoolType(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitBoolType(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitBoolType(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class StructTypeContext: TypeContext {
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}

		public
		init(_ ctx: TypeContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterStructType(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitStructType(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitStructType(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitStructType(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class IntTypeContext: TypeContext {

		public
		init(_ ctx: TypeContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterIntType(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitIntType(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitIntType(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitIntType(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func type() throws -> TypeContext {
		var _localctx: TypeContext = TypeContext(_ctx, getState())
		try enterRule(_localctx, 10, MiniParser.RULE_type)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(71)
		 	try _errHandler.sync(self)
		 	switch (MiniParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .T__4:
		 		_localctx =  IntTypeContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(67)
		 		try match(MiniParser.Tokens.T__4.rawValue)

		 		break

		 	case .T__5:
		 		_localctx =  BoolTypeContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(68)
		 		try match(MiniParser.Tokens.T__5.rawValue)

		 		break

		 	case .T__0:
		 		_localctx =  StructTypeContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(69)
		 		try match(MiniParser.Tokens.T__0.rawValue)
		 		setState(70)
		 		try match(MiniParser.Tokens.ID.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DeclarationsContext: ParserRuleContext {
			open
			func declaration() -> [DeclarationContext] {
				return getRuleContexts(DeclarationContext.self)
			}
			open
			func declaration(_ i: Int) -> DeclarationContext? {
				return getRuleContext(DeclarationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_declarations
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterDeclarations(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitDeclarations(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitDeclarations(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitDeclarations(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declarations() throws -> DeclarationsContext {
        let _localctx: DeclarationsContext = DeclarationsContext(_ctx, getState())
		try enterRule(_localctx, 12, MiniParser.RULE_declarations)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(76)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MiniParser.Tokens.T__0.rawValue,MiniParser.Tokens.T__4.rawValue,MiniParser.Tokens.T__5.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(73)
		 		try declaration()


		 		setState(78)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DeclarationContext: ParserRuleContext {
			open
			func type() -> TypeContext? {
				return getRuleContext(TypeContext.self, 0)
			}
			open
			func ID() -> [TerminalNode] {
				return getTokens(MiniParser.Tokens.ID.rawValue)
			}
			open
			func ID(_ i:Int) -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_declaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitDeclaration(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declaration() throws -> DeclarationContext {
        let _localctx: DeclarationContext = DeclarationContext(_ctx, getState())
		try enterRule(_localctx, 14, MiniParser.RULE_declaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(79)
		 	try type()
		 	setState(80)
		 	try match(MiniParser.Tokens.ID.rawValue)
		 	setState(85)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == MiniParser.Tokens.T__6.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(81)
		 		try match(MiniParser.Tokens.T__6.rawValue)
		 		setState(82)
		 		try match(MiniParser.Tokens.ID.rawValue)


		 		setState(87)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(88)
		 	try match(MiniParser.Tokens.T__3.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionsContext: ParserRuleContext {
			open
			func function() -> [FunctionContext] {
				return getRuleContexts(FunctionContext.self)
			}
			open
			func function(_ i: Int) -> FunctionContext? {
				return getRuleContext(FunctionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_functions
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterFunctions(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitFunctions(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitFunctions(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitFunctions(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functions() throws -> FunctionsContext {
        let _localctx: FunctionsContext = FunctionsContext(_ctx, getState())
		try enterRule(_localctx, 16, MiniParser.RULE_functions)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(93)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == MiniParser.Tokens.T__7.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(90)
		 		try function()


		 		setState(95)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionContext: ParserRuleContext {
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}
			open
			func parameters() -> ParametersContext? {
				return getRuleContext(ParametersContext.self, 0)
			}
			open
			func returnType() -> ReturnTypeContext? {
				return getRuleContext(ReturnTypeContext.self, 0)
			}
			open
			func declarations() -> DeclarationsContext? {
				return getRuleContext(DeclarationsContext.self, 0)
			}
			open
			func statementList() -> StatementListContext? {
				return getRuleContext(StatementListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_function
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterFunction(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitFunction(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitFunction(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitFunction(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func function() throws -> FunctionContext {
        let _localctx: FunctionContext = FunctionContext(_ctx, getState())
		try enterRule(_localctx, 18, MiniParser.RULE_function)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(96)
		 	try match(MiniParser.Tokens.T__7.rawValue)
		 	setState(97)
		 	try match(MiniParser.Tokens.ID.rawValue)
		 	setState(98)
		 	try parameters()
		 	setState(99)
		 	try returnType()
		 	setState(100)
		 	try match(MiniParser.Tokens.T__1.rawValue)
		 	setState(101)
		 	try declarations()
		 	setState(102)
		 	try statementList()
		 	setState(103)
		 	try match(MiniParser.Tokens.T__2.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ParametersContext: ParserRuleContext {
			open
			func decl() -> [DeclContext] {
				return getRuleContexts(DeclContext.self)
			}
			open
			func decl(_ i: Int) -> DeclContext? {
				return getRuleContext(DeclContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_parameters
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterParameters(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitParameters(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitParameters(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitParameters(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func parameters() throws -> ParametersContext {
        let _localctx: ParametersContext = ParametersContext(_ctx, getState())
		try enterRule(_localctx, 20, MiniParser.RULE_parameters)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(105)
		 	try match(MiniParser.Tokens.T__8.rawValue)
		 	setState(114)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MiniParser.Tokens.T__0.rawValue,MiniParser.Tokens.T__4.rawValue,MiniParser.Tokens.T__5.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(106)
		 		try decl()
		 		setState(111)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == MiniParser.Tokens.T__6.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(107)
		 			try match(MiniParser.Tokens.T__6.rawValue)
		 			setState(108)
		 			try decl()


		 			setState(113)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}

		 	setState(116)
		 	try match(MiniParser.Tokens.T__9.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ReturnTypeContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_returnType
		}
	}
	public class ReturnTypeVoidContext: ReturnTypeContext {

		public
		init(_ ctx: ReturnTypeContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterReturnTypeVoid(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitReturnTypeVoid(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitReturnTypeVoid(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitReturnTypeVoid(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ReturnTypeRealContext: ReturnTypeContext {
			open
			func type() -> TypeContext? {
				return getRuleContext(TypeContext.self, 0)
			}

		public
		init(_ ctx: ReturnTypeContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterReturnTypeReal(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitReturnTypeReal(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitReturnTypeReal(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitReturnTypeReal(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func returnType() throws -> ReturnTypeContext {
		var _localctx: ReturnTypeContext = ReturnTypeContext(_ctx, getState())
		try enterRule(_localctx, 22, MiniParser.RULE_returnType)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(120)
		 	try _errHandler.sync(self)
		 	switch (MiniParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .T__0:fallthrough
		 	case .T__4:fallthrough
		 	case .T__5:
		 		_localctx =  ReturnTypeRealContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(118)
		 		try type()

		 		break

		 	case .T__10:
		 		_localctx =  ReturnTypeVoidContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(119)
		 		try match(MiniParser.Tokens.T__10.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StatementContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_statement
		}
	}
	public class AssignmentContext: StatementContext {
			open
			func lvalue() -> LvalueContext? {
				return getRuleContext(LvalueContext.self, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterAssignment(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitAssignment(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitAssignment(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitAssignment(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class DeleteContext: StatementContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterDelete(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitDelete(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitDelete(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitDelete(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PrintContext: StatementContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterPrint(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitPrint(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitPrint(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitPrint(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ReturnContext: StatementContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterReturn(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitReturn(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitReturn(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitReturn(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class InvocationContext: StatementContext {
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}
			open
			func arguments() -> ArgumentsContext? {
				return getRuleContext(ArgumentsContext.self, 0)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterInvocation(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitInvocation(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitInvocation(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitInvocation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PrintLnContext: StatementContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterPrintLn(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitPrintLn(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitPrintLn(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitPrintLn(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ConditionalContext: StatementContext {
		public var thenBlock: BlockContext!
		public var elseBlock: BlockContext!
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func block() -> [BlockContext] {
				return getRuleContexts(BlockContext.self)
			}
			open
			func block(_ i: Int) -> BlockContext? {
				return getRuleContext(BlockContext.self, i)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterConditional(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitConditional(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitConditional(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitConditional(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class NestedBlockContext: StatementContext {
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterNestedBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitNestedBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitNestedBlock(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitNestedBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class WhileContext: StatementContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}

		public
		init(_ ctx: StatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterWhile(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitWhile(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitWhile(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitWhile(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func statement() throws -> StatementContext {
		var _localctx: StatementContext = StatementContext(_ctx, getState())
		try enterRule(_localctx, 24, MiniParser.RULE_statement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(170)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,13, _ctx)) {
		 	case 1:
		 		_localctx =  NestedBlockContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(122)
		 		try block()

		 		break
		 	case 2:
		 		_localctx =  AssignmentContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(123)
		 		try lvalue(0)
		 		setState(124)
		 		try match(MiniParser.Tokens.T__11.rawValue)
		 		setState(127)
		 		try _errHandler.sync(self)
		 		switch (MiniParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .T__8:fallthrough
		 		case .T__21:fallthrough
		 		case .T__22:fallthrough
		 		case .T__34:fallthrough
		 		case .T__35:fallthrough
		 		case .T__36:fallthrough
		 		case .T__37:fallthrough
		 		case .ID:fallthrough
		 		case .INTEGER:
		 			setState(125)
		 			try expression(0)

		 			break

		 		case .T__12:
		 			setState(126)
		 			try match(MiniParser.Tokens.T__12.rawValue)

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(129)
		 		try match(MiniParser.Tokens.T__3.rawValue)

		 		break
		 	case 3:
		 		_localctx =  PrintContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(131)
		 		try match(MiniParser.Tokens.T__13.rawValue)
		 		setState(132)
		 		try expression(0)
		 		setState(133)
		 		try match(MiniParser.Tokens.T__3.rawValue)

		 		break
		 	case 4:
		 		_localctx =  PrintLnContext(_localctx);
		 		try enterOuterAlt(_localctx, 4)
		 		setState(135)
		 		try match(MiniParser.Tokens.T__13.rawValue)
		 		setState(136)
		 		try expression(0)
		 		setState(137)
		 		try match(MiniParser.Tokens.T__14.rawValue)
		 		setState(138)
		 		try match(MiniParser.Tokens.T__3.rawValue)

		 		break
		 	case 5:
		 		_localctx =  ConditionalContext(_localctx);
		 		try enterOuterAlt(_localctx, 5)
		 		setState(140)
		 		try match(MiniParser.Tokens.T__15.rawValue)
		 		setState(141)
		 		try match(MiniParser.Tokens.T__8.rawValue)
		 		setState(142)
		 		try expression(0)
		 		setState(143)
		 		try match(MiniParser.Tokens.T__9.rawValue)
		 		setState(144)
		 		try {
		 				let assignmentValue = try block()
		 				_localctx.castdown(ConditionalContext.self).thenBlock = assignmentValue
		 		     }()

		 		setState(147)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == MiniParser.Tokens.T__16.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(145)
		 			try match(MiniParser.Tokens.T__16.rawValue)
		 			setState(146)
		 			try {
		 					let assignmentValue = try block()
		 					_localctx.castdown(ConditionalContext.self).elseBlock = assignmentValue
		 			     }()


		 		}


		 		break
		 	case 6:
		 		_localctx =  WhileContext(_localctx);
		 		try enterOuterAlt(_localctx, 6)
		 		setState(149)
		 		try match(MiniParser.Tokens.T__17.rawValue)
		 		setState(150)
		 		try match(MiniParser.Tokens.T__8.rawValue)
		 		setState(151)
		 		try expression(0)
		 		setState(152)
		 		try match(MiniParser.Tokens.T__9.rawValue)
		 		setState(153)
		 		try block()

		 		break
		 	case 7:
		 		_localctx =  DeleteContext(_localctx);
		 		try enterOuterAlt(_localctx, 7)
		 		setState(155)
		 		try match(MiniParser.Tokens.T__18.rawValue)
		 		setState(156)
		 		try expression(0)
		 		setState(157)
		 		try match(MiniParser.Tokens.T__3.rawValue)

		 		break
		 	case 8:
		 		_localctx =  ReturnContext(_localctx);
		 		try enterOuterAlt(_localctx, 8)
		 		setState(159)
		 		try match(MiniParser.Tokens.T__19.rawValue)
		 		setState(161)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, MiniParser.Tokens.T__8.rawValue,MiniParser.Tokens.T__21.rawValue,MiniParser.Tokens.T__22.rawValue,MiniParser.Tokens.T__34.rawValue,MiniParser.Tokens.T__35.rawValue,MiniParser.Tokens.T__36.rawValue,MiniParser.Tokens.T__37.rawValue,MiniParser.Tokens.ID.rawValue,MiniParser.Tokens.INTEGER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(160)
		 			try expression(0)

		 		}

		 		setState(163)
		 		try match(MiniParser.Tokens.T__3.rawValue)

		 		break
		 	case 9:
		 		_localctx =  InvocationContext(_localctx);
		 		try enterOuterAlt(_localctx, 9)
		 		setState(164)
		 		try match(MiniParser.Tokens.ID.rawValue)
		 		setState(165)
		 		try match(MiniParser.Tokens.T__8.rawValue)
		 		setState(166)
		 		try arguments()
		 		setState(167)
		 		try match(MiniParser.Tokens.T__9.rawValue)
		 		setState(168)
		 		try match(MiniParser.Tokens.T__3.rawValue)

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class BlockContext: ParserRuleContext {
			open
			func statementList() -> StatementListContext? {
				return getRuleContext(StatementListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_block
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitBlock(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func block() throws -> BlockContext {
        let _localctx: BlockContext = BlockContext(_ctx, getState())
		try enterRule(_localctx, 26, MiniParser.RULE_block)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(172)
		 	try match(MiniParser.Tokens.T__1.rawValue)
		 	setState(173)
		 	try statementList()
		 	setState(174)
		 	try match(MiniParser.Tokens.T__2.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StatementListContext: ParserRuleContext {
			open
			func statement() -> [StatementContext] {
				return getRuleContexts(StatementContext.self)
			}
			open
			func statement(_ i: Int) -> StatementContext? {
				return getRuleContext(StatementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_statementList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterStatementList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitStatementList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitStatementList(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitStatementList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func statementList() throws -> StatementListContext {
        let _localctx: StatementListContext = StatementListContext(_ctx, getState())
		try enterRule(_localctx, 28, MiniParser.RULE_statementList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(179)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MiniParser.Tokens.T__1.rawValue,MiniParser.Tokens.T__13.rawValue,MiniParser.Tokens.T__15.rawValue,MiniParser.Tokens.T__17.rawValue,MiniParser.Tokens.T__18.rawValue,MiniParser.Tokens.T__19.rawValue,MiniParser.Tokens.ID.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(176)
		 		try statement()


		 		setState(181)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}


	public class LvalueContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_lvalue
		}
	}
	public class LvalueIdContext: LvalueContext {
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}

		public
		init(_ ctx: LvalueContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterLvalueId(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitLvalueId(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitLvalueId(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitLvalueId(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class LvalueDotContext: LvalueContext {
			open
			func lvalue() -> LvalueContext? {
				return getRuleContext(LvalueContext.self, 0)
			}
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}

		public
		init(_ ctx: LvalueContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterLvalueDot(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitLvalueDot(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitLvalueDot(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitLvalueDot(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 public final  func lvalue( ) throws -> LvalueContext   {
		return try lvalue(0)
	}
	@discardableResult
	private func lvalue(_ _p: Int) throws -> LvalueContext   {
		let _parentctx: ParserRuleContext? = _ctx
        let _parentState: Int = getState()
		var _localctx: LvalueContext = LvalueContext(_ctx, _parentState)
        let _startState: Int = 30
		try enterRecursionRule(_localctx, 30, MiniParser.RULE_lvalue, _p)
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			_localctx = LvalueIdContext(_localctx)
			_ctx = _localctx

			setState(183)
			try match(MiniParser.Tokens.ID.rawValue)

			_ctx!.stop = try _input.LT(-1)
			setState(190)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,15,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_localctx = LvalueDotContext(  LvalueContext(_parentctx, _parentState))
					try pushNewRecursionContext(_localctx, _startState, MiniParser.RULE_lvalue)
					setState(185)
					if (!(precpred(_ctx, 1))) {
					    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 1)"))
					}
					setState(186)
					try match(MiniParser.Tokens.T__20.rawValue)
					setState(187)
					try match(MiniParser.Tokens.ID.rawValue)

			 
				}
				setState(192)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,15,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}


	public class ExpressionContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_expression
		}
	}
	public class IntegerExprContext: ExpressionContext {
			open
			func INTEGER() -> TerminalNode? {
				return getToken(MiniParser.Tokens.INTEGER.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterIntegerExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitIntegerExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitIntegerExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitIntegerExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class TrueExprContext: ExpressionContext {

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterTrueExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitTrueExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitTrueExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitTrueExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class IdentifierExprContext: ExpressionContext {
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterIdentifierExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitIdentifierExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitIdentifierExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitIdentifierExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class BinaryExprContext: ExpressionContext {
		public var lft: ExpressionContext!
		public var op: Token!
		public var rht: ExpressionContext!
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterBinaryExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitBinaryExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitBinaryExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitBinaryExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class NewExprContext: ExpressionContext {
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterNewExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitNewExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitNewExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitNewExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class NestedExprContext: ExpressionContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterNestedExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitNestedExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitNestedExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitNestedExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class DotExprContext: ExpressionContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterDotExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitDotExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitDotExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitDotExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class UnaryExprContext: ExpressionContext {
		public var op: Token!
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterUnaryExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitUnaryExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitUnaryExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitUnaryExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class InvocationExprContext: ExpressionContext {
			open
			func ID() -> TerminalNode? {
				return getToken(MiniParser.Tokens.ID.rawValue, 0)
			}
			open
			func arguments() -> ArgumentsContext? {
				return getRuleContext(ArgumentsContext.self, 0)
			}

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterInvocationExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitInvocationExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitInvocationExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitInvocationExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class FalseExprContext: ExpressionContext {

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterFalseExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitFalseExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitFalseExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitFalseExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class NullExprContext: ExpressionContext {

		public
		init(_ ctx: ExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterNullExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitNullExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitNullExpr(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitNullExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 public final  func expression( ) throws -> ExpressionContext   {
		return try expression(0)
	}
	@discardableResult
	private func expression(_ _p: Int) throws -> ExpressionContext   {
		let _parentctx: ParserRuleContext? = _ctx
        let _parentState: Int = getState()
		var _localctx: ExpressionContext = ExpressionContext(_ctx, _parentState)
		var  _prevctx: ExpressionContext = _localctx
        let _startState: Int = 32
		try enterRecursionRule(_localctx, 32, MiniParser.RULE_expression, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(212)
			try _errHandler.sync(self)
			switch(try getInterpreter().adaptivePredict(_input,16, _ctx)) {
			case 1:
				_localctx = InvocationExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx

				setState(194)
				try match(MiniParser.Tokens.ID.rawValue)
				setState(195)
				try match(MiniParser.Tokens.T__8.rawValue)
				setState(196)
				try arguments()
				setState(197)
				try match(MiniParser.Tokens.T__9.rawValue)

				break
			case 2:
				_localctx = UnaryExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(199)
				_localctx.castdown(UnaryExprContext.self).op = try _input.LT(1)
				_la = try _input.LA(1)
				if (!(//closure
				 { () -> Bool in
				      let testSet: Bool = _la == MiniParser.Tokens.T__21.rawValue || _la == MiniParser.Tokens.T__22.rawValue
				      return testSet
				 }())) {
					_localctx.castdown(UnaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
				}
				else {
					_errHandler.reportMatch(self)
					try consume()
				}
				setState(200)
				try expression(14)

				break
			case 3:
				_localctx = IdentifierExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(201)
				try match(MiniParser.Tokens.ID.rawValue)

				break
			case 4:
				_localctx = IntegerExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(202)
				try match(MiniParser.Tokens.INTEGER.rawValue)

				break
			case 5:
				_localctx = TrueExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(203)
				try match(MiniParser.Tokens.T__34.rawValue)

				break
			case 6:
				_localctx = FalseExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(204)
				try match(MiniParser.Tokens.T__35.rawValue)

				break
			case 7:
				_localctx = NewExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(205)
				try match(MiniParser.Tokens.T__36.rawValue)
				setState(206)
				try match(MiniParser.Tokens.ID.rawValue)

				break
			case 8:
				_localctx = NullExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(207)
				try match(MiniParser.Tokens.T__37.rawValue)

				break
			case 9:
				_localctx = NestedExprContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(208)
				try match(MiniParser.Tokens.T__8.rawValue)
				setState(209)
				try expression(0)
				setState(210)
				try match(MiniParser.Tokens.T__9.rawValue)

				break
			default: break
			}
			_ctx!.stop = try _input.LT(-1)
			setState(237)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,18,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(235)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,17, _ctx)) {
					case 1:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						(_localctx as! BinaryExprContext).lft = _prevctx
						try pushNewRecursionContext(_localctx, _startState, MiniParser.RULE_expression)
						setState(214)
						if (!(precpred(_ctx, 13))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 13)"))
						}
						setState(215)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == MiniParser.Tokens.T__23.rawValue || _la == MiniParser.Tokens.T__24.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(216)
						try {
								let assignmentValue = try expression(14)
								_localctx.castdown(BinaryExprContext.self).rht = assignmentValue
						     }()


						break
					case 2:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						(_localctx as! BinaryExprContext).lft = _prevctx
						try pushNewRecursionContext(_localctx, _startState, MiniParser.RULE_expression)
						setState(217)
						if (!(precpred(_ctx, 12))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 12)"))
						}
						setState(218)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == MiniParser.Tokens.T__21.rawValue || _la == MiniParser.Tokens.T__25.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(219)
						try {
								let assignmentValue = try expression(13)
								_localctx.castdown(BinaryExprContext.self).rht = assignmentValue
						     }()


						break
					case 3:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						(_localctx as! BinaryExprContext).lft = _prevctx
						try pushNewRecursionContext(_localctx, _startState, MiniParser.RULE_expression)
						setState(220)
						if (!(precpred(_ctx, 11))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 11)"))
						}
						setState(221)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, MiniParser.Tokens.T__26.rawValue,MiniParser.Tokens.T__27.rawValue,MiniParser.Tokens.T__28.rawValue,MiniParser.Tokens.T__29.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(222)
						try {
								let assignmentValue = try expression(12)
								_localctx.castdown(BinaryExprContext.self).rht = assignmentValue
						     }()


						break
					case 4:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						(_localctx as! BinaryExprContext).lft = _prevctx
						try pushNewRecursionContext(_localctx, _startState, MiniParser.RULE_expression)
						setState(223)
						if (!(precpred(_ctx, 10))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 10)"))
						}
						setState(224)
						_localctx.castdown(BinaryExprContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == MiniParser.Tokens.T__30.rawValue || _la == MiniParser.Tokens.T__31.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(BinaryExprContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(225)
						try {
								let assignmentValue = try expression(11)
								_localctx.castdown(BinaryExprContext.self).rht = assignmentValue
						     }()


						break
					case 5:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						(_localctx as! BinaryExprContext).lft = _prevctx
						try pushNewRecursionContext(_localctx, _startState, MiniParser.RULE_expression)
						setState(226)
						if (!(precpred(_ctx, 9))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 9)"))
						}
						setState(227)
						try {
								let assignmentValue = try match(MiniParser.Tokens.T__32.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(228)
						try {
								let assignmentValue = try expression(10)
								_localctx.castdown(BinaryExprContext.self).rht = assignmentValue
						     }()


						break
					case 6:
						_localctx = BinaryExprContext(  ExpressionContext(_parentctx, _parentState))
						(_localctx as! BinaryExprContext).lft = _prevctx
						try pushNewRecursionContext(_localctx, _startState, MiniParser.RULE_expression)
						setState(229)
						if (!(precpred(_ctx, 8))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 8)"))
						}
						setState(230)
						try {
								let assignmentValue = try match(MiniParser.Tokens.T__33.rawValue)
								_localctx.castdown(BinaryExprContext.self).op = assignmentValue
						     }()

						setState(231)
						try {
								let assignmentValue = try expression(9)
								_localctx.castdown(BinaryExprContext.self).rht = assignmentValue
						     }()


						break
					case 7:
						_localctx = DotExprContext(  ExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, MiniParser.RULE_expression)
						setState(232)
						if (!(precpred(_ctx, 15))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 15)"))
						}

						setState(233)
						try match(MiniParser.Tokens.T__20.rawValue)
						setState(234)
						try match(MiniParser.Tokens.ID.rawValue)


						break
					default: break
					}
			 
				}
				setState(239)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,18,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	public class ArgumentsContext: ParserRuleContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return MiniParser.RULE_arguments
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.enterArguments(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? MiniListener {
				listener.exitArguments(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? MiniVisitor {
			    return visitor.visitArguments(self)
			}
			else if let visitor = visitor as? MiniBaseVisitor {
			    return visitor.visitArguments(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arguments() throws -> ArgumentsContext {
        let _localctx: ArgumentsContext = ArgumentsContext(_ctx, getState())
		try enterRule(_localctx, 34, MiniParser.RULE_arguments)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(248)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, MiniParser.Tokens.T__8.rawValue,MiniParser.Tokens.T__21.rawValue,MiniParser.Tokens.T__22.rawValue,MiniParser.Tokens.T__34.rawValue,MiniParser.Tokens.T__35.rawValue,MiniParser.Tokens.T__36.rawValue,MiniParser.Tokens.T__37.rawValue,MiniParser.Tokens.ID.rawValue,MiniParser.Tokens.INTEGER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(240)
		 		try expression(0)
		 		setState(245)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == MiniParser.Tokens.T__6.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(241)
		 			try match(MiniParser.Tokens.T__6.rawValue)
		 			setState(242)
		 			try expression(0)


		 			setState(247)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	override open
	func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int,  _ predIndex: Int)throws -> Bool {
		switch (ruleIndex) {
		case  15:
			return try lvalue_sempred(_localctx?.castdown(LvalueContext.self), predIndex)
		case  16:
			return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
	    default: return true
		}
	}
	private func lvalue_sempred(_ _localctx: LvalueContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return precpred(_ctx, 1)
		    default: return true
		}
	}
	private func expression_sempred(_ _localctx: ExpressionContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 1:return precpred(_ctx, 13)
		    case 2:return precpred(_ctx, 12)
		    case 3:return precpred(_ctx, 11)
		    case 4:return precpred(_ctx, 10)
		    case 5:return precpred(_ctx, 9)
		    case 6:return precpred(_ctx, 8)
		    case 7:return precpred(_ctx, 15)
		    default: return true
		}
	}


	public
	static let _serializedATN = MiniParserATN().jsonString

	public
	static let _ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}
