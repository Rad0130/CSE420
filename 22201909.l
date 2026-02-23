%option noyywrap

%{
#include<bits/stdc++.h>

#include"symbol_info.h"

#define YYSTYPE symbol_info*

#include "y.tab.h"

extern YYSTYPE yylval;

using namespace std;

void yyerror(char *);


string loglist;

extern int lines;

extern ofstream outlog;

%}

/* Regular Definitions */

delim	 [ \t\v\r]
newline     \n+

/* write regular expressions for whitespace and newline */

letter_     [A-Za-z_]
digit       [0-9]

ws          [ \t\v\r]+
id          {letter_}({letter_}|{digit})*
int_const   {digit}+
float_const ({digit}+"."{digit}*([Ee][+-]?{digit}+)?|"."{digit}+([Ee][+-]?{digit}+)?|{digit}+[Ee][+-]?{digit}+)

/* write regular expressions for id, float and integers */
%%

{ws}		{ /* ignore whitespace */ }
{newline} {
    lines += yyleng;
}

if          { 
                loglist="Line no "+to_string(lines)+": Token <IF> Lexeme "+yytext+" found"+"\n"+"\n";
			    outlog<<loglist;
                return IF; }

else        { outlog<<"Line no "<<lines<<": Token <ELSE> Lexeme "<<yytext<<" found\n\n"; return 
              ELSE; }

for         { outlog<<"Line no "<<lines<<": Token <FOR> Lexeme "<<yytext<<" found\n\n"; return FOR; }

while       { 
                loglist="Line no "+to_string(lines)+": Token <WHILE> Lexeme "+yytext+" found"+"\n"+"\n";
			    outlog<<loglist; 
                return WHILE; }

do          { outlog<<"Line no "<<lines<<": Token <DO> Lexeme "<<yytext<<" found\n\n"; return DO; }

break       { outlog<<"Line no "<<lines<<": Token <BREAK> Lexeme "<<yytext<<" found\n\n"; return 
              BREAK; }

int         { outlog<<"Line no "<<lines<<": Token <INT> Lexeme "<<yytext<<" found\n\n"; return INT; }

char        { outlog<<"Line no "<<lines<<": Token <CHAR> Lexeme "<<yytext<<" found\n\n"; return
              CHAR; }

float       { outlog<<"Line no "<<lines<<": Token <FLOAT> Lexeme "<<yytext<<" found\n\n"; return 
              FLOAT; }

double      { outlog<<"Line no "<<lines<<": Token <DOUBLE> Lexeme "<<yytext<<" found\n\n"; return 
              DOUBLE; }

void        { outlog<<"Line no "<<lines<<": Token <VOID> Lexeme "<<yytext<<" found\n\n"; return 
              VOID; }

return      { outlog<<"Line no "<<lines<<": Token <RETURN> Lexeme "<<yytext<<" found\n\n"; return 
              RETURN; }

switch      { outlog<<"Line no "<<lines<<": Token <SWITCH> Lexeme "<<yytext<<" found\n\n"; return 
              SWITCH; }

case        { outlog<<"Line no "<<lines<<": Token <CASE> Lexeme "<<yytext<<" found\n\n"; return 
              CASE; }

default     { outlog<<"Line no "<<lines<<": Token <DEFAULT> Lexeme "<<yytext<<" found\n\n"; return 
              DEFAULT; }

continue    { outlog<<"Line no "<<lines<<": Token <CONTINUE> Lexeme "<<yytext<<" found\n\n"; return 
              CONTINUE; }

goto        { outlog<<"Line no "<<lines<<": Token <GOTO> Lexeme "<<yytext<<" found\n\n"; return 
              GOTO; }

printf      { outlog<<"Line no "<<lines<<": Token <PRINTF> Lexeme "<<yytext<<" found\n\n"; return 
              PRINTF; }

{float_const} {
    symbol_info *s = new symbol_info(yytext,"CONST_FLOAT");
    yylval = s;
    outlog<<"Line no "<<lines<<": Token <CONST_FLOAT> Lexeme "<<yytext<<" found\n\n";
    return CONST_FLOAT;
}

{int_const} {
    symbol_info *s = new symbol_info(yytext,"CONST_INT");
    yylval = s;
    outlog<<"Line no "<<lines<<": Token <CONST_INT> Lexeme "<<yytext<<" found\n\n";
    return CONST_INT;
}

"++"    {
            symbol_info *s = new symbol_info((string)yytext,"INCOP");
            yylval = (YYSTYPE)s;
            loglist="Line no "+to_string(lines)+": Token <INCOP> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return INCOP;
        }

"--"    {
            symbol_info *s = new symbol_info((string)yytext,"DECOP");
            yylval = s;
            return DECOP;
        }

"+"|"-"	    {
                symbol_info *s = new symbol_info((string)yytext,"ADDOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(lines)+": Token <ADDOP> Lexeme "+yytext+" found"+"\n"+"\n";
			    outlog<<loglist;
                return ADDOP;
		    }

","        { 
                loglist="Line no "+to_string(lines)+": Token <COMMA> Lexeme "+yytext+" found"+"\n"+"\n";
			    outlog<<loglist;               
                return COMMA; }

"*"|"/"|"%"  {
                symbol_info *s = new symbol_info((string)yytext,"MULOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(lines)+": Token <MULOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return MULOP;
             }

"=="|"<="|">="|"!="  {
                        symbol_info *s = new symbol_info((string)yytext,"RELOP");
                        yylval = (YYSTYPE)s;
                        loglist="Line no "+to_string(lines)+": Token <RELOP> Lexeme "+yytext+" found\n\n";
                        outlog<<loglist;
                        return RELOP;
                     }

"<"|">"  {
            symbol_info *s = new symbol_info((string)yytext,"RELOP");
            yylval = (YYSTYPE)s;
            loglist="Line no "+to_string(lines)+": Token <RELOP> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return RELOP;
          }

"="     {
            symbol_info *s = new symbol_info((string)yytext,"ASSIGNOP");
            yylval = (YYSTYPE)s;
            loglist="Line no "+to_string(lines)+": Token <ASSIGNOP> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return ASSIGNOP;
        }

"&&"|"||"   {
                symbol_info *s = new symbol_info((string)yytext,"LOGICOP");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(lines)+": Token <LOGICOP> Lexeme "+yytext+" found\n\n";
                outlog<<loglist;
                return LOGICOP;
             }

"!"     {
            symbol_info *s = new symbol_info((string)yytext,"NOT");
            yylval = (YYSTYPE)s;
            loglist="Line no "+to_string(lines)+": Token <NOT> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return NOT;
        }

"("     {
            loglist="Line no "+to_string(lines)+": Token <LPAREN> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return LPAREN;
        }

")"     {
            loglist="Line no "+to_string(lines)+": Token <RPAREN> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return RPAREN;
        }

"{"     {
            loglist="Line no "+to_string(lines)+": Token <LCURL> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return LCURL;
        }

"}"     {
            loglist="Line no "+to_string(lines)+": Token <RCURL> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return RCURL;
        }

"["     {
            loglist="Line no "+to_string(lines)+": Token <LTHIRD> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return LTHIRD;
        }

"]"     {
            loglist="Line no "+to_string(lines)+": Token <RTHIRD> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return RTHIRD;
        }

":"     {
            loglist="Line no "+to_string(lines)+": Token <COLON> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return COLON;
        }

";"     {
            loglist="Line no "+to_string(lines)+": Token <SEMICOLON> Lexeme "+yytext+" found\n\n";
            outlog<<loglist;
            return SEMICOLON;
        }

{id}       {
                symbol_info *s = new symbol_info((string)yytext,"ID");
                yylval = (YYSTYPE)s;
                loglist="Line no "+to_string(lines)+": Token <ID> Lexeme "+yytext+" found"+"\n"+"\n";
			    outlog<<loglist;
                return ID;
            }

. {
    outlog<<"Line no "<<lines<<": Unrecognized character "<<yytext<<"\n\n";
}

%%