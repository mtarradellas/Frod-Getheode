%{
  #include <stdio.h>
  #include "./y.tab.h"
  void yyerror (char *s);
  int yylex();
%}

word      [a-zA-Z][_a-zA-Z0-9]*
number    [0-9][0-9]*
space     [ \t\n]
ws        {space}+

%%

"beginnan".*"ablinnan"  /* comment */;
{ws}                    /* white space */;
"aernan"                return MAIN;
"ut"                    return RETURN;
"gif"                   return IF;
"hwil"                  return WHILE;
"andac"                 return AND;
"othe"                  return OR;
"writan"                return PRINT;
"araedan"               return READ;
"soth"                  return TRUE_VAL;
"nasoth"                return FALSE_VAL;
"rim"                   return T_INT;
"irenbend"              return T_STRING;
"cunnan"                return T_BOOL;
"beon"                  return EQUAL;
"ilca"                  return IS_EQUAL;
"nailca"                return NOT_EQUAL;
"na"                    return NOT;
"laes"                  return L_THAN;
"laesilca"              return LE_THAN;
"mara"                  return G_THAN;
"marailca"              return GE_THAN;
"aegther"               return PLUS;
"butan"                 return MINUS;
"eacen"                 return MULT;
"dael"                  return DIV;
"laf"                   return MOD;
"ende"                  return EXIT;
"("                     return L_PAREN;
")"                     return R_PAREN;
"{"                     return L_BRACK;
"}"                     return R_BRACK;
";"                     return END_LINE;
","                     return COMMA;

\"[^\"]*\"              {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return STRING;
                        }  

{number}                {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return NUM;
                        }

{word}                  {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return ID;
                        }

.                       {yyerror("Unexpected character");}

%%

int yywrap(void) {
  return 1;
}
