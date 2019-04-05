/* Definition section 111111111111*/
%{
	#include <stdio.h>
	#include <stdlib.h>
	void C_comment();
	void CPP_comment();
	void str_const();
	int line_cnt=0;
	int comm_cnt=0;
%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
number {digit}+

/* Rules section */
%%

"+" 	{ printf("\r%s \t ADD\n", yytext); }
"-"		{ printf("\r%s \t SUB\n", yytext); }
"*"		{ printf("\r%s \t MUL\n", yytext); }
"/"		{ printf("\r%s \t DIV\n", yytext); }
"%"		{ printf("\r%s \t MOD\n", yytext); }
"++"		{ printf("\r%s \t INC\n", yytext); }
"--"		{ printf("\r%s \t DEC\n", yytext); }
">"		{ printf("\r%s \t MT\n", yytext); }
"<"		{ printf("\r%s \t LT\n", yytext); }
">="		{ printf("\r%s \t MTE\n", yytext); }
"=="		{ printf("\r%s \t EQ\n", yytext); }
"!="		{ printf("\r%s \t NE\n", yytext); }
"="		{ printf("\r%s \t ASGN\n", yytext); }
"+="		{ printf("\r%s \t ADDASGN\n", yytext); }
"-="		{ printf("\r%s \t SUBASGN\n", yytext); }
"*="		{ printf("\r%s \t MULASGN\n", yytext); }
"/="		{ printf("\r%s \t DIVASGN\n", yytext); }
"%="		{ printf("\r%s \t MODASGN\n", yytext); }
"&&"		{ printf("\r%s \t AND\n", yytext); }
"||"		{ printf("\r%s \t OR\n", yytext); }
"!"		{ printf("\r%s \t NOT\n", yytext); }
"("		{ printf("\r%s \t LB\n", yytext); }
")"		{ printf("\r%s \t RB\n", yytext); }
"{"		{ printf("\r%s \t LCB\n", yytext);}
"}"		{ printf("\r%s \t RCB\n", yytext); }
"["		{ printf("\r%s \t LSB\n", yytext); }
"]"		{ printf("\r%s \t RSB\n", yytext); }
","		{ printf("\r%s \t COMMA\n", yytext); }
";"		{ printf("\r%s \t SEMICOLON\n", yytext); }
"\""		{ str_const(); }
"print"		{ printf("\r%s \t PRINT\n", yytext); }
"if"		{ printf("\r%s \t IF\n", yytext); }
"else"		{ printf("\r%s \t ELSE\n", yytext); }
"for"		{ printf("\r%s \t FOR\n", yytext); }
"while"		{ printf("\r%s \t WHILE\n", yytext); }
"string"		{ printf("\r%s \t STRING\n", yytext); }
"int"		{ printf("\r%s \t INT\n", yytext); }
"float"		{ printf("\r%s \t FLOAT\n", yytext); }
"void"		{ printf("\r%s \t VOID\n", yytext); }
"bool"		{ printf("\r%s \t BOOL\n", yytext); }
"true"		{ printf("\r%s \t TRUE\n", yytext); }
"false"		{ printf("\r%s \t FALSE\n", yytext); }
"return"		{ printf("\r%s \t RET\n", yytext); }
"continue"		{ printf("\r%s \t CONT\n", yytext); }
"break"		{ printf("\r%s \t BREAK\n", yytext); }
{number}		{ printf("\r%s \t I_CONST\n", yytext); }
{number}"."{number}		{ printf("\r%s \t F_CONST\n", yytext); }

"/*"		{ C_comment(); }
"//"		{ CPP_comment(); }

{id}	{ printf("\r%s \t ID\n", yytext); }
\n			{ line_cnt++; } 

%%

/* C Code section */
void C_comment()
{
	char c, c1;
	printf("/*");

loop:
	while ((c = input()) != '*' && c != 0)
	{
		putchar(c);
		if(c=='\n')
		{
			comm_cnt++;
		}
	}

	if ((c1 = input()) != '/' && c != 0) /*	註解內部的星號 */
	{
		unput(c1);
		putchar(c);
		goto loop;
	}

	if (c != 0)
	{
		printf("*/ \t C Comment\n");
		comm_cnt++;
		line_cnt--;
	}
}

void CPP_comment()
{
	char c;
	printf("\r//");
	while ((c = input()) != '\n' && c != 0)
	{
		putchar(c);
	}
	comm_cnt++;

	printf(" \t C++ Comment\n");
}

void str_const()
{
	printf("\r\" \t QUOTA\n");

	char c;
	while ((c = input()) != '\"' && c != 0)
	{
		putchar(c);
	}
	printf(" \t STR_CONST\n");

	printf("\r\" \t QUOTA\n");
}

int yywrap(void)
{
    return 1;
}

int main(int argc,char *argv[])
{
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\nParse over, the line number is %d.\n\n",comm_cnt+line_cnt);
	printf("comment: %d lines\n\n",comm_cnt);

	return 0;
}