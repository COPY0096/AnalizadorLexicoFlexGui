%{
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

void enviar_token_a_gui(const char* tipo, const char* valor);
int yywrap(void);
int yylex(void);

#ifdef __cplusplus
}
#endif

int num_linea = 1;
%}


DIGITO          [0-9]
ID_LETRA        [a-zA-Z_]
NUMERO          {DIGITO}+(\.{DIGITO}+)?
IDENTIFICADOR   {ID_LETRA}({ID_LETRA}|{DIGITO})*

%%

"if"            { enviar_token_a_gui("IF", yytext); }
"else"          { enviar_token_a_gui("ELSE", yytext); }
"while"         { enviar_token_a_gui("WHILE", yytext); }
"for"           { enviar_token_a_gui("FOR", yytext); }
"int"           { enviar_token_a_gui("INT", yytext); }
"float"         { enviar_token_a_gui("FLOAT", yytext); }
"return"        { enviar_token_a_gui("RETURN", yytext); }

{NUMERO}        { enviar_token_a_gui("NUMERO", yytext); }
{IDENTIFICADOR} { enviar_token_a_gui("IDENTIFICADOR", yytext); }

"=="            { enviar_token_a_gui("OPERADOR RELACIONAL", yytext); }
"!="            { enviar_token_a_gui("OPERADOR RELACIONAL", yytext); }
"<="            { enviar_token_a_gui("OPERADOR RELACIONAL", yytext); }
">="            { enviar_token_a_gui("OPERADOR RELACIONAL", yytext); }

[+\-*/=<>]      { enviar_token_a_gui("OPERADOR", yytext); }
[{}();,]        { enviar_token_a_gui("SIMBOLO", yytext); }
[ \t]+          ;
\n              { num_linea++; }

"//".*          { enviar_token_a_gui("COMENTARIO", yytext); }
"/*"([^*]|\*+[^*/])*"*/" { enviar_token_a_gui("COMENTARIO MULTILINEA", yytext); }

.               { enviar_token_a_gui("TOKEN NO RECONOCIDO", yytext); }

%%

int yywrap(void) { return 1; }
