%{
#include <stdio.h>
#include <stdlib.h>

int num_linea = 1;  // Contador de líneas
%}


DIGITO      [0-9]
ID_LETRA    [a-zA-Z_]
NUMERO      {DIGITO}+(\.{DIGITO}+)?
IDENTIFICADOR {ID_LETRA}({ID_LETRA}|{DIGITO})*

%%


"if"            { printf("TOKEN: IF\n"); }
"else"          { printf("TOKEN: ELSE\n"); }
"while"         { printf("TOKEN: WHILE\n"); }
"for"           { printf("TOKEN: FOR\n"); }
"int"           { printf("TOKEN: INT\n"); }
"float"         { printf("TOKEN: FLOAT\n"); }
"return"        { printf("TOKEN: RETURN\n"); }


{NUMERO}        { printf("TOKEN: NUMERO (%s)\n", yytext); }
{IDENTIFICADOR} { printf("TOKEN: IDENTIFICADOR (%s)\n", yytext); }


"=="            { printf("TOKEN: OPERADOR RELACIONAL (%s)\n", yytext); }
"!="            { printf("TOKEN: OPERADOR RELACIONAL (%s)\n", yytext); }
"<="            { printf("TOKEN: OPERADOR RELACIONAL (%s)\n", yytext); }
">="            { printf("TOKEN: OPERADOR RELACIONAL (%s)\n", yytext); }

[+\-*/=<>]      { printf("TOKEN: OPERADOR (%s)\n", yytext); }


[{}();,]        { printf("TOKEN: SIMBOLO (%s)\n", yytext); }


[ \t]+          ;


\n              { num_linea++; }



"//".*          { printf("COMENTARIO (%s)\n", yytext); }


"/*"([^*]|\*+[^*/])*"*/" { printf("COMENTARIO MULTILINEA\n"); }


.               { printf("TOKEN NO RECONOCIDO (%s)\n", yytext); }

%%


int yywrap(void) {
    return 1;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *archivo = fopen(argv[1], "r");
        if (!archivo) {
            perror("No se pudo abrir el archivo de entrada");
            return 1;
        }
        yyin = archivo;
    }

    printf("=== ANALIZADOR LÉXICO ===\n\n");
    yylex();
    printf("\n=== FIN DEL ANÁLISIS ===\n");
    printf("Líneas analizadas: %d\n", num_linea);
    return 0;
}
