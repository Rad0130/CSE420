%{
#include "symbol_info.h"
#include <bits/stdc++.h>

#define YYSTYPE symbol_info*

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern ofstream outlog;
extern int lines;

using namespace std;

int lines;
ofstream outlog;

void yyerror(char *s) {
    cerr << "Error at line " << lines << ": " << s << endl;
}
%}

/* Token Declarations */
%token DECOP
%token IF ELSE FOR WHILE DO BREAK
%token INT FLOAT VOID CHAR DOUBLE
%token RETURN SWITCH CASE DEFAULT CONTINUE GOTO PRINTF
%token ADDOP MULOP INCOP RELOP ASSIGNOP LOGICOP NOT
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD
%token COMMA COLON SEMICOLON
%token CONST_INT CONST_FLOAT ID

/* Handle if-else ambiguity */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

start
    : program { outlog<<"At line no: "<<lines<<" start : program "<<endl<<endl; }
    ;

program
    : program unit
        { 
            outlog<<"At line no: "<<lines<<" program : program unit "<<endl<<endl;
            $$ = new symbol_info($1->getname()+"\n"+$2->getname(),"program"); 
        }
    | unit
        { $$ = $1; }
    ;

unit
    : var_declaration
        { $$ = $1; }
    | func_definition
        { $$ = $1; }
    ;

func_definition
    : type_specifier ID LPAREN parameter_list RPAREN compound_statement
        {
            outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement "<<endl<<endl;
            outlog<<$1->getname()<<" "<<$2->getname()<<"()\n"<<$5->getname()<<endl<<endl;
            $$ = new symbol_info($1->getname()+" "+$2->getname()+"()\n"+$5->getname(),"func_def");
        }
    | type_specifier ID LPAREN RPAREN compound_statement
        {
            outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement "<<endl<<endl;
            outlog<<$1->getname()<<" "<<$2->getname()<<"()\n"<<$5->getname()<<endl<<endl;
            $$ = new symbol_info($1->getname()+" "+$2->getname()+"()\n"+$5->getname(),"func_def");
        }
    ;

parameter_list
    : parameter_list COMMA type_specifier ID
        { $$ = new symbol_info($1->getname()+", "+$3->getname()+" "+$4->getname(),"param_list"); }
    | parameter_list COMMA type_specifier
        { $$ = new symbol_info($1->getname()+", "+$3->getname(),"param_list"); }
    | type_specifier ID
        { $$ = new symbol_info($1->getname()+" "+$2->getname(),"param_list"); }
    | type_specifier
        { $$ = new symbol_info($1->getname(),"param_list"); }
    ;

compound_statement
    : LCURL statements RCURL
        { $$ = new symbol_info("{\n"+$2->getname()+"}\n","compound_stmt"); }
    | LCURL RCURL
        { $$ = new symbol_info("{}","compound_stmt"); }
    ;

var_declaration
    : type_specifier declaration_list SEMICOLON
        { $$ = new symbol_info($1->getname()+" "+$2->getname()+";","var_decl"); }
    ;

type_specifier
    : INT    { $$ = new symbol_info("int","type"); }
    | FLOAT  { $$ = new symbol_info("float","type"); }
    | VOID   { $$ = new symbol_info("void","type"); }
    | CHAR   { $$ = new symbol_info("char","type"); }
    | DOUBLE { $$ = new symbol_info("double","type"); }
    ;

declaration_list
    : declaration_list COMMA ID
        { $$ = new symbol_info($1->getname()+", "+$3->getname(),"decl_list"); }
    | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
        { $$ = new symbol_info($1->getname()+", "+$3->getname()+"["+ $5->getname() +"]","decl_list"); }
    | ID
        { $$ = new symbol_info($1->getname(),"decl_list"); }
    | ID LTHIRD CONST_INT RTHIRD
        { $$ = new symbol_info($1->getname()+"["+ $3->getname() +"]","decl_list"); }
    ;

statements
    : statement
        { $$ = $1; }
    | statements statement
        { $$ = new symbol_info($1->getname()+"\n"+$2->getname(),"stmnts"); }
    ;

statement
    : var_declaration
        { $$ = $1; }
    | expression_statement
        { $$ = $1; }
    | compound_statement
        { $$ = $1; }
    | FOR LPAREN expression_statement expression_statement expression RPAREN statement
        {
            outlog<<"At line no: "<<lines<<" statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement "<<endl<<endl;
            outlog<<"for("<<$3->getname()<<$4->getname()<<$5->getname()<<")\n"<<$7->getname()<<endl<<endl;
            $$ = new symbol_info("for("+$3->getname()+$4->getname()+$5->getname()+")\n"+$7->getname(),"stmnt");
        }
    | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
        { $$ = new symbol_info("if("+$3->getname()+")\n"+$5->getname(),"stmnt"); }
    | IF LPAREN expression RPAREN statement ELSE statement
        { $$ = new symbol_info("if("+$3->getname()+")\n"+$5->getname()+"else\n"+$7->getname(),"stmnt"); }
    | WHILE LPAREN expression RPAREN statement
        { $$ = new symbol_info("while("+$3->getname()+")\n"+$5->getname(),"stmnt"); }
    | PRINTF LPAREN ID RPAREN SEMICOLON
        { $$ = new symbol_info("printf("+$3->getname()+");","stmnt"); }
    | RETURN SEMICOLON
        { $$ = new symbol_info("return;","stmnt"); }

    | RETURN expression SEMICOLON
        { $$ = new symbol_info("return "+$2->getname()+";","stmnt"); }
    ;

expression_statement
    : SEMICOLON
        { $$ = new symbol_info(";","expr_stmt"); }
    | expression SEMICOLON
        { $$ = new symbol_info($1->getname()+";","expr_stmt"); }
    ;

variable
    : ID
        { $$ = $1; }
    | ID LTHIRD expression RTHIRD
        { $$ = new symbol_info($1->getname()+"["+ $3->getname() +"]","var"); }
    ;

expression
    : logic_expression
        { $$ = $1; }
    | variable ASSIGNOP logic_expression
        { $$ = new symbol_info($1->getname()+" = "+$3->getname(),"expr"); }
    ;

logic_expression
    : rel_expression
        { $$ = $1; }
    | rel_expression LOGICOP rel_expression
        { $$ = new symbol_info($1->getname()+" "+$2->getname()+" "+$3->getname(),"logic_expr"); }
    ;

rel_expression
    : simple_expression
        { $$ = $1; }
    | simple_expression RELOP simple_expression
        { $$ = new symbol_info($1->getname()+" "+$2->getname()+" "+$3->getname(),"rel_expr"); }
    ;

simple_expression
    : term
        { $$ = $1; }
    | simple_expression ADDOP term
        { $$ = new symbol_info($1->getname()+" "+$2->getname()+" "+$3->getname(),"simple_expr"); }
    ;

term
    : unary_expression
        { $$ = $1; }
    | term MULOP unary_expression
        { $$ = new symbol_info($1->getname()+" "+$2->getname()+" "+$3->getname(),"term"); }
    ;

unary_expression
    : ADDOP unary_expression
        { $$ = new symbol_info($1->getname()+$2->getname(),"unary_expr"); }
    | NOT unary_expression
        { $$ = new symbol_info("!"+$2->getname(),"unary_expr"); }
    | factor
        { $$ = $1; }
    ;

factor
    : variable
        { $$ = $1; }
    | ID LPAREN argument_list RPAREN
        { $$ = new symbol_info($1->getname()+"("+$3->getname()+")","func_call"); }
    | LPAREN expression RPAREN
        { $$ = new symbol_info("("+$2->getname()+")","factor"); }
    | CONST_INT
        { $$ = $1; }
    | CONST_FLOAT
        { $$ = $1; }
    | variable INCOP
        { $$ = new symbol_info($1->getname()+"++","factor"); }
    | variable DECOP
        { $$ = new symbol_info($1->getname()+"--","factor"); }
    ;

argument_list
    : arguments
        { $$ = $1; }
    | /* empty */
        { $$ = new symbol_info("","arg_list"); }
    ;

arguments
    : arguments COMMA logic_expression
        { $$ = new symbol_info($1->getname()+", "+$3->getname(),"args"); }
    | logic_expression
        { $$ = $1; }
    ;


%%

int main(int argc, char *argv[])
{
    if(argc != 2) {
        cout<<"Usage: ./a.out <source_file.c>"<<endl;
        return 1;
    }

    yyin = fopen(argv[1],"r");
    if(!yyin) {
        cout<<"Cannot open file "<<argv[1]<<endl;
        return 1;
    }

    outlog.open("my_log.txt", ios::trunc);
    lines = 1;

    yyparse();

    outlog<<"Total lines: "<<lines<<endl;
    outlog.close();
    fclose(yyin);

    return 0;
}