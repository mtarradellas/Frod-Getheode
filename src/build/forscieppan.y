%{
  void yyerror (char *s);
  int yylex();
  #include <stdio.h> 
  #include <stdlib.h>
  #include <ctype.h>
  #include <string.h>
  #include "./include/node.h"
  char buff[30];
%}

%start program

%union {
  char *str;
  struct Node *node;
}

%token MAIN RETURN IF WHILE AND OR PRINT
%token READ TRUE_VAL FALSE_VAL T_INT T_STRING T_BOOL
%token EQUAL IS_EQUAL NOT_EQUAL NOT L_THAN LE_THAN
%token G_THAN GE_THAN PLUS MINUS MULT DIV MOD
%token L_PAREN R_PAREN L_BRACK R_BRACK END_LINE
%token COMMA EXIT

%token <str> STRING ID NUM

%type <node> program functions main baby_function type bool args params baby_param
%type <node> call_args call_params call_baby_param body sentences baby_sentence 
%type <node> assignment expression declaration call return if while condition
%type <node> cond_term cmp 

%left PLUS MINUS
%left MULTIPLY DIVIDE MOD
%left IS_EQUAL NOT_EQUAL G_THAN GE_THAN L_THAN LE_THAN
%left OR AND

%%    /* descriptions of expected inputs  -  corresponding actions */

program       : functions                                               {   $$ = $1;
                                                                            printHeaders();
                                                                            printTree($$);
                                                                        }
              ;

functions     : baby_function functions                                 {   $$ = nodeNew("functions");
                                                                            nodeAppend($$, $1); nodeAppend($$, $2);
                                                                        }

              | main                                                    {   $$ = nodeNew("functions");
                                                                            nodeAppend($$, $1);
                                                                        }
              ;

main          : MAIN L_PAREN R_PAREN L_BRACK body EXIT R_BRACK          {   $$ = nodeNew("main");
                                                                            nodeAppend($$, nodeTypeNew(NULL, main_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, lparen_)); nodeAppend($$, nodeTypeNew(NULL, rparen_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, lbrack_)); nodeAppend($$, $5); 
                                                                            nodeAppend($$, nodeTypeNew(NULL, exit_));nodeAppend($$, nodeTypeNew(NULL, rbrack_));
                                                                        }

              ;

baby_function : type ID L_PAREN args R_PAREN L_BRACK body R_BRACK       {   $$ = nodeNew("baby_function");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew($2, id_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, lparen_)); nodeAppend($$, $4);
                                                                            nodeAppend($$, nodeTypeNew(NULL, rparen_)); nodeAppend($$, nodeTypeNew(NULL, lbrack_));
                                                                            nodeAppend($$, $7); nodeAppend($$, nodeTypeNew(NULL, rbrack_));
                                                                        }
              ;

type          : T_INT                                                   {   $$ = nodeTypeNew(NULL, int_t_);}
              | T_BOOL                                                  {   $$ = nodeTypeNew(NULL, bool_t_);}
              | T_STRING                                                {   $$ = nodeTypeNew(NULL, string_t_);}
              ;

bool          : TRUE_VAL                                                {   $$ = nodeTypeNew(NULL, true_);}
              | FALSE_VAL                                               {   $$ = nodeTypeNew(NULL, false_);}
              ;

args          : params                                                  {   $$ = nodeNew("args");
                                                                            nodeAppend($$, $1);
                                                                        }

              |                                                         {   $$ = NULL;}
              ;

params        : baby_param COMMA params                                 {   $$ = nodeNew("params");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, comma_)); nodeAppend($$, $3);
                                                                        }

              | baby_param                                              {   $$ = nodeNew("params");
                                                                            nodeAppend($$, $1);
                                                                        }
              ;

baby_param    : type ID                                                 {   $$ = nodeNew("baby_param");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew($2, id_));
                                                                        }
              ;

call_args     : call_params                                             {   $$ = nodeNew("call_args");
                                                                            nodeAppend($$, $1); 
                                                                        }

              |                                                         {   $$ = NULL;}
              ;

call_params   : call_baby_param COMMA call_params                       {   $$ = nodeNew("call_params");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, comma_)); nodeAppend($$, $3);
                                                                        }

              | call_baby_param                                         {   $$ = nodeNew("call_params");
                                                                            nodeAppend($$, $1);
                                                                        }
              ;

call_baby_param: expression                                             {   $$ = nodeNew("call_baby_param");
                                                                            nodeAppend($$, $1);
                                                                        }

              | bool                                                    {   $$ = nodeNew("call_baby_param");
                                                                            nodeAppend($$, $1);
                                                                        }

              | STRING                                                  {   $$ = nodeTypeNew($1, string_);}
              ;

body          : sentences                                               {   $$ = nodeNew("body");
                                                                            nodeAppend($$, $1);
                                                                        }

              |                                                         {   $$ = NULL;}
              ;

sentences     : baby_sentence sentences                                 {   $$ = nodeNew("sentences");
                                                                            nodeAppend($$, $1); nodeAppend($$, $2);
                                                                        }

              | baby_sentence                                           {   $$ = nodeNew("sentences");
                                                                            nodeAppend($$, $1);
                                                                        }
              ;

baby_sentence : assignment END_LINE                                     {   $$ = nodeNew("baby_sentence");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, semicolon_));
                                                                        }

              | declaration END_LINE                                    {   $$ = nodeNew("baby_sentence");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, semicolon_));
                                                                        }

              | call END_LINE                                           {   $$ = nodeNew("baby_sentence");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, semicolon_));
                                                                        }

              | return END_LINE                                         {   $$ = nodeNew("baby_sentence");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, semicolon_));
                                                                        }

              | if                                                      {   $$ = nodeNew("baby_sentence");
                                                                            nodeAppend($$, $1);
                                                                        }

              | while                                                   {   $$ = nodeNew("baby_sentence");
                                                                            nodeAppend($$, $1);
                                                                        }

assignment    : ID EQUAL expression                                     {   $$ = nodeNew("assignment");
                                                                            nodeAppend($$, nodeTypeNew($1, id_)); nodeAppend($$, nodeTypeNew(NULL, equal_));
                                                                            nodeAppend($$, $3);
                                                                        }

              | ID EQUAL STRING                                         {   $$ = nodeNew("assignment");
                                                                            nodeAppend($$, nodeTypeNew($1, id_)); nodeAppend($$, nodeTypeNew(NULL, equal_));
                                                                            nodeAppend($$, nodeTypeNew($3, string_));
                                                                        }
              | ID EQUAL bool                                           {   $$ = nodeNew("assignment");
                                                                            nodeAppend($$, nodeTypeNew($1, id_)); nodeAppend($$, nodeTypeNew(NULL, equal_));
                                                                            nodeAppend($$, $3);
                                                                        }
              ;

expression    : ID                                                      {   $$ = nodeTypeNew($1, id_);}
              | NUM                                                     {   $$ = nodeTypeNew($1, int_); 
                                                                        } 

              | call                                                    {   $$ = nodeNew("expression");
                                                                            nodeAppend($$, $1);
                                                                        }

              | expression PLUS expression                              {   $$ = nodeNew("expression");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, plus_));
                                                                            nodeAppend($$, $3);
                                                                        }

              | expression MINUS expression                             {   $$ = nodeNew("expression");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, minus_));
                                                                            nodeAppend($$, $3);
                                                                        }

              | expression MULT expression                              {   $$ = nodeNew("expression");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, mult_));
                                                                            nodeAppend($$, $3);
                                                                        }

              | expression DIV expression                               {   $$ = nodeNew("expression");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, div_));
                                                                            nodeAppend($$, $3);
                                                                        }

              | expression MOD expression                               {   $$ = nodeNew("expression");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, mod_));
                                                                            nodeAppend($$, $3);
                                                                        }
              ;

declaration   : T_INT ID EQUAL expression                               {   $$ = nodeNew("declaration");
                                                                            nodeAppend($$, nodeTypeNew(NULL, int_t_)); nodeAppend($$, nodeTypeNew($2, id_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, equal_)); nodeAppend($$, $4);
                                                                        }

              | T_BOOL ID EQUAL bool                                    {   $$ = nodeNew("declaration");
                                                                            nodeAppend($$, nodeTypeNew(NULL, bool_t_)); nodeAppend($$, nodeTypeNew($2, id_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, equal_)); nodeAppend($$, $4);
                                                                        }

              | T_BOOL ID EQUAL call                                    {   $$ = nodeNew("declaration");
                                                                            nodeAppend($$, nodeTypeNew(NULL, bool_t_)); nodeAppend($$, nodeTypeNew($2, id_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, equal_)); nodeAppend($$, $4);
                                                                        }

              | T_STRING ID EQUAL STRING                                {   $$ = nodeNew("declaration");
                                                                            nodeAppend($$, nodeTypeNew(NULL, string_t_)); nodeAppend($$, nodeTypeNew($2, id_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, equal_)); nodeAppend($$, nodeTypeNew($4, string_));
                                                                        }

              | T_STRING ID EQUAL call                                  {   $$ = nodeNew("declaration");
                                                                            nodeAppend($$, nodeTypeNew(NULL, string_t_)); nodeAppend($$, nodeTypeNew($2, id_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, equal_)); nodeAppend($$, $4);
                                                                        }

              | type ID EQUAL ID                                        {   $$ = nodeNew("declaration");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew($2, id_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, equal_)); nodeAppend($$, nodeTypeNew($4, id_));
                                                                        }
              ;

call          : ID L_PAREN call_args R_PAREN                            {   $$ = nodeNew("call");
                                                                            nodeAppend($$, nodeTypeNew($1, id_)); nodeAppend($$, nodeTypeNew(NULL, lparen_));
                                                                            nodeAppend($$, $3); nodeAppend($$, nodeTypeNew(NULL, rparen_));
                                                                        }

              | PRINT L_PAREN call_args R_PAREN                         {   $$ = nodeNew("call");
                                                                            nodeAppend($$, nodeTypeNew(NULL, print_)); nodeAppend($$, nodeTypeNew(NULL, lparen_));
                                                                            nodeAppend($$, $3); nodeAppend($$, nodeTypeNew(NULL, rparen_));
                                                                        }

              | READ L_PAREN call_args R_PAREN                          {   $$ = nodeNew("call");
                                                                            nodeAppend($$, nodeTypeNew(NULL, scan_)); nodeAppend($$, nodeTypeNew(NULL, lparen_));
                                                                            nodeAppend($$, $3); nodeAppend($$, nodeTypeNew(NULL, rparen_));
                                                                        }
              ;

return        : RETURN expression                                       {   $$ = nodeNew("return");
                                                                            nodeAppend($$, nodeTypeNew(NULL, return_)); nodeAppend($$, $2);
                                                                        }

              | RETURN STRING                                           {   $$ = nodeNew("return");
                                                                            nodeAppend($$, nodeTypeNew(NULL, return_)); nodeAppend($$, nodeTypeNew($2, string_));
                                                                        }

              | RETURN condition                                        {   $$ = nodeNew("return");
                                                                            nodeAppend($$, nodeTypeNew(NULL, return_)); nodeAppend($$, $2);
                                                                        }
              ; 

if            : IF L_PAREN condition R_PAREN L_BRACK body R_BRACK       {   $$ = nodeNew("if");
                                                                            nodeAppend($$, nodeTypeNew(NULL, if_)); nodeAppend($$, nodeTypeNew(NULL, lparen_));
                                                                            nodeAppend($$, $3); nodeAppend($$, nodeTypeNew(NULL, rparen_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, lbrack_)); nodeAppend($$, $6);
                                                                            nodeAppend($$, nodeTypeNew(NULL, rbrack_));
                                                                        }
              ;

while         : WHILE L_PAREN condition R_PAREN L_BRACK body R_BRACK    {   $$ = nodeNew("while");
                                                                            nodeAppend($$, nodeTypeNew(NULL, while_)); nodeAppend($$, nodeTypeNew(NULL, lparen_));
                                                                            nodeAppend($$, $3); nodeAppend($$, nodeTypeNew(NULL, rparen_));
                                                                            nodeAppend($$, nodeTypeNew(NULL, lbrack_)); nodeAppend($$, $6);
                                                                            nodeAppend($$, nodeTypeNew(NULL, rbrack_));
                                                                        }
              ;

condition     : cond_term                                               {   $$ = nodeNew("condition");
                                                                            nodeAppend($$, $1);
                                                                        }

              | condition AND condition                                 {   $$ = nodeNew("condition");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, and_));
                                                                            nodeAppend($$, $3);
                                                                        }

              | condition OR condition                                  {   $$ = nodeNew("condition");
                                                                            nodeAppend($$, $1); nodeAppend($$, nodeTypeNew(NULL, or_));
                                                                            nodeAppend($$, $3);
                                                                        }

              | NOT condition                                           {   $$ = nodeNew("condition");
                                                                            nodeAppend($$, nodeTypeNew(NULL, not_)); nodeAppend($$, $2);
                                                                        }
              ;

cond_term     : bool                                                    {   $$ = nodeNew("cond_term");
                                                                            nodeAppend($$, $1);
                                                                        }

              | expression cmp expression                               {   $$ = nodeNew("cond_term");
                                                                            nodeAppend($$, $1); nodeAppend($$, $2);
                                                                            nodeAppend($$, $3);
                                                                        }

              | call                                                    {   $$ = nodeNew("cond_term");
                                                                            nodeAppend($$, $1);
                                                                        }

              | ID                                                      {   $$ = nodeNew("cond_term");
                                                                            nodeAppend($$, nodeTypeNew($1, id_));
                                                                        }
              ;

cmp           : IS_EQUAL                                                {   $$ = nodeNew("cmp");
                                                                            nodeAppend($$, nodeTypeNew(NULL, isequal_));
                                                                        }

              | NOT_EQUAL                                               {   $$ = nodeNew("cmp");
                                                                            nodeAppend($$, nodeTypeNew(NULL, diff_));
                                                                        }

              | G_THAN                                                  {   $$ = nodeNew("cmp");
                                                                            nodeAppend($$, nodeTypeNew(NULL, gthan_));
                                                                        }

              | GE_THAN                                                 {   $$ = nodeNew("cmp");
                                                                            nodeAppend($$, nodeTypeNew(NULL, gethan_));
                                                                        }

              | L_THAN                                                  {   $$ = nodeNew("cmp");
                                                                            nodeAppend($$, nodeTypeNew(NULL, lthan_));
                                                                        }

              | LE_THAN                                                 {   $$ = nodeNew("cmp");
                                                                            nodeAppend($$, nodeTypeNew(NULL, lethan_));
                                                                        }
              ;

%%

int main() {
  yyparse();
  return 0;
}

void yyerror(char * s) {
  fprintf(stderr, "%s\n", s);
  return;
}
