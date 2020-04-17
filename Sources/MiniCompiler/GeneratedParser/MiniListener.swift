// Generated from Mini.g4 by ANTLR 4.8

   /* package declaration here */

import Antlr4

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link MiniParser}.
 */
public protocol MiniListener: ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link MiniParser#program}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterProgram(_ ctx: MiniParser.ProgramContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#program}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitProgram(_ ctx: MiniParser.ProgramContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#types}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypes(_ ctx: MiniParser.TypesContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#types}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypes(_ ctx: MiniParser.TypesContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#typeDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTypeDeclaration(_ ctx: MiniParser.TypeDeclarationContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#typeDeclaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTypeDeclaration(_ ctx: MiniParser.TypeDeclarationContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#nestedDecl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNestedDecl(_ ctx: MiniParser.NestedDeclContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#nestedDecl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNestedDecl(_ ctx: MiniParser.NestedDeclContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDecl(_ ctx: MiniParser.DeclContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#decl}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDecl(_ ctx: MiniParser.DeclContext)
	/**
	 * Enter a parse tree produced by the {@code IntType}
	 * labeled alternative in {@link MiniParser#type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIntType(_ ctx: MiniParser.IntTypeContext)
	/**
	 * Exit a parse tree produced by the {@code IntType}
	 * labeled alternative in {@link MiniParser#type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIntType(_ ctx: MiniParser.IntTypeContext)
	/**
	 * Enter a parse tree produced by the {@code BoolType}
	 * labeled alternative in {@link MiniParser#type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBoolType(_ ctx: MiniParser.BoolTypeContext)
	/**
	 * Exit a parse tree produced by the {@code BoolType}
	 * labeled alternative in {@link MiniParser#type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBoolType(_ ctx: MiniParser.BoolTypeContext)
	/**
	 * Enter a parse tree produced by the {@code StructType}
	 * labeled alternative in {@link MiniParser#type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStructType(_ ctx: MiniParser.StructTypeContext)
	/**
	 * Exit a parse tree produced by the {@code StructType}
	 * labeled alternative in {@link MiniParser#type}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStructType(_ ctx: MiniParser.StructTypeContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#declarations}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclarations(_ ctx: MiniParser.DeclarationsContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#declarations}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclarations(_ ctx: MiniParser.DeclarationsContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#declaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDeclaration(_ ctx: MiniParser.DeclarationContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#declaration}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDeclaration(_ ctx: MiniParser.DeclarationContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#functions}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunctions(_ ctx: MiniParser.FunctionsContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#functions}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunctions(_ ctx: MiniParser.FunctionsContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#function}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFunction(_ ctx: MiniParser.FunctionContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#function}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFunction(_ ctx: MiniParser.FunctionContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#parameters}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterParameters(_ ctx: MiniParser.ParametersContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#parameters}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitParameters(_ ctx: MiniParser.ParametersContext)
	/**
	 * Enter a parse tree produced by the {@code ReturnTypeReal}
	 * labeled alternative in {@link MiniParser#returnType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterReturnTypeReal(_ ctx: MiniParser.ReturnTypeRealContext)
	/**
	 * Exit a parse tree produced by the {@code ReturnTypeReal}
	 * labeled alternative in {@link MiniParser#returnType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitReturnTypeReal(_ ctx: MiniParser.ReturnTypeRealContext)
	/**
	 * Enter a parse tree produced by the {@code ReturnTypeVoid}
	 * labeled alternative in {@link MiniParser#returnType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterReturnTypeVoid(_ ctx: MiniParser.ReturnTypeVoidContext)
	/**
	 * Exit a parse tree produced by the {@code ReturnTypeVoid}
	 * labeled alternative in {@link MiniParser#returnType}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitReturnTypeVoid(_ ctx: MiniParser.ReturnTypeVoidContext)
	/**
	 * Enter a parse tree produced by the {@code NestedBlock}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNestedBlock(_ ctx: MiniParser.NestedBlockContext)
	/**
	 * Exit a parse tree produced by the {@code NestedBlock}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNestedBlock(_ ctx: MiniParser.NestedBlockContext)
	/**
	 * Enter a parse tree produced by the {@code Assignment}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterAssignment(_ ctx: MiniParser.AssignmentContext)
	/**
	 * Exit a parse tree produced by the {@code Assignment}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitAssignment(_ ctx: MiniParser.AssignmentContext)
	/**
	 * Enter a parse tree produced by the {@code Print}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPrint(_ ctx: MiniParser.PrintContext)
	/**
	 * Exit a parse tree produced by the {@code Print}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPrint(_ ctx: MiniParser.PrintContext)
	/**
	 * Enter a parse tree produced by the {@code PrintLn}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterPrintLn(_ ctx: MiniParser.PrintLnContext)
	/**
	 * Exit a parse tree produced by the {@code PrintLn}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitPrintLn(_ ctx: MiniParser.PrintLnContext)
	/**
	 * Enter a parse tree produced by the {@code Conditional}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterConditional(_ ctx: MiniParser.ConditionalContext)
	/**
	 * Exit a parse tree produced by the {@code Conditional}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitConditional(_ ctx: MiniParser.ConditionalContext)
	/**
	 * Enter a parse tree produced by the {@code While}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterWhile(_ ctx: MiniParser.WhileContext)
	/**
	 * Exit a parse tree produced by the {@code While}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitWhile(_ ctx: MiniParser.WhileContext)
	/**
	 * Enter a parse tree produced by the {@code Delete}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDelete(_ ctx: MiniParser.DeleteContext)
	/**
	 * Exit a parse tree produced by the {@code Delete}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDelete(_ ctx: MiniParser.DeleteContext)
	/**
	 * Enter a parse tree produced by the {@code Return}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterReturn(_ ctx: MiniParser.ReturnContext)
	/**
	 * Exit a parse tree produced by the {@code Return}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitReturn(_ ctx: MiniParser.ReturnContext)
	/**
	 * Enter a parse tree produced by the {@code Invocation}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInvocation(_ ctx: MiniParser.InvocationContext)
	/**
	 * Exit a parse tree produced by the {@code Invocation}
	 * labeled alternative in {@link MiniParser#statement}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInvocation(_ ctx: MiniParser.InvocationContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#block}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBlock(_ ctx: MiniParser.BlockContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#block}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBlock(_ ctx: MiniParser.BlockContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#statementList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterStatementList(_ ctx: MiniParser.StatementListContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#statementList}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitStatementList(_ ctx: MiniParser.StatementListContext)
	/**
	 * Enter a parse tree produced by the {@code LvalueId}
	 * labeled alternative in {@link MiniParser#lvalue}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLvalueId(_ ctx: MiniParser.LvalueIdContext)
	/**
	 * Exit a parse tree produced by the {@code LvalueId}
	 * labeled alternative in {@link MiniParser#lvalue}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLvalueId(_ ctx: MiniParser.LvalueIdContext)
	/**
	 * Enter a parse tree produced by the {@code LvalueDot}
	 * labeled alternative in {@link MiniParser#lvalue}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterLvalueDot(_ ctx: MiniParser.LvalueDotContext)
	/**
	 * Exit a parse tree produced by the {@code LvalueDot}
	 * labeled alternative in {@link MiniParser#lvalue}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitLvalueDot(_ ctx: MiniParser.LvalueDotContext)
	/**
	 * Enter a parse tree produced by the {@code IntegerExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIntegerExpr(_ ctx: MiniParser.IntegerExprContext)
	/**
	 * Exit a parse tree produced by the {@code IntegerExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIntegerExpr(_ ctx: MiniParser.IntegerExprContext)
	/**
	 * Enter a parse tree produced by the {@code TrueExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterTrueExpr(_ ctx: MiniParser.TrueExprContext)
	/**
	 * Exit a parse tree produced by the {@code TrueExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitTrueExpr(_ ctx: MiniParser.TrueExprContext)
	/**
	 * Enter a parse tree produced by the {@code IdentifierExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterIdentifierExpr(_ ctx: MiniParser.IdentifierExprContext)
	/**
	 * Exit a parse tree produced by the {@code IdentifierExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitIdentifierExpr(_ ctx: MiniParser.IdentifierExprContext)
	/**
	 * Enter a parse tree produced by the {@code BinaryExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterBinaryExpr(_ ctx: MiniParser.BinaryExprContext)
	/**
	 * Exit a parse tree produced by the {@code BinaryExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitBinaryExpr(_ ctx: MiniParser.BinaryExprContext)
	/**
	 * Enter a parse tree produced by the {@code NewExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNewExpr(_ ctx: MiniParser.NewExprContext)
	/**
	 * Exit a parse tree produced by the {@code NewExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNewExpr(_ ctx: MiniParser.NewExprContext)
	/**
	 * Enter a parse tree produced by the {@code NestedExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNestedExpr(_ ctx: MiniParser.NestedExprContext)
	/**
	 * Exit a parse tree produced by the {@code NestedExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNestedExpr(_ ctx: MiniParser.NestedExprContext)
	/**
	 * Enter a parse tree produced by the {@code DotExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterDotExpr(_ ctx: MiniParser.DotExprContext)
	/**
	 * Exit a parse tree produced by the {@code DotExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitDotExpr(_ ctx: MiniParser.DotExprContext)
	/**
	 * Enter a parse tree produced by the {@code UnaryExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterUnaryExpr(_ ctx: MiniParser.UnaryExprContext)
	/**
	 * Exit a parse tree produced by the {@code UnaryExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitUnaryExpr(_ ctx: MiniParser.UnaryExprContext)
	/**
	 * Enter a parse tree produced by the {@code InvocationExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterInvocationExpr(_ ctx: MiniParser.InvocationExprContext)
	/**
	 * Exit a parse tree produced by the {@code InvocationExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitInvocationExpr(_ ctx: MiniParser.InvocationExprContext)
	/**
	 * Enter a parse tree produced by the {@code FalseExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterFalseExpr(_ ctx: MiniParser.FalseExprContext)
	/**
	 * Exit a parse tree produced by the {@code FalseExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitFalseExpr(_ ctx: MiniParser.FalseExprContext)
	/**
	 * Enter a parse tree produced by the {@code NullExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterNullExpr(_ ctx: MiniParser.NullExprContext)
	/**
	 * Exit a parse tree produced by the {@code NullExpr}
	 * labeled alternative in {@link MiniParser#expression}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitNullExpr(_ ctx: MiniParser.NullExprContext)
	/**
	 * Enter a parse tree produced by {@link MiniParser#arguments}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func enterArguments(_ ctx: MiniParser.ArgumentsContext)
	/**
	 * Exit a parse tree produced by {@link MiniParser#arguments}.
	 - Parameters:
	   - ctx: the parse tree
	 */
	func exitArguments(_ ctx: MiniParser.ArgumentsContext)
}