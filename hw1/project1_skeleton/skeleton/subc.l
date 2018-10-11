%{
/**************************************************************
* File Name   : subc.l
*
* Description
*	This is a skeleton input file to lex.
*
* Which tool to use
*	The GNU lex-clone, flex/flex++ is recommended to use.
*	It supports a C++ mode.
*	For any information about flex, refer to flex.man.
*
*	Good Luck!
*
***************************************************************/

/**************************************************************/
/* This section will appear at the head of lex.yy.c/lex.yy.cc */
/**************************************************************/
#include "string.h"
#include "subc.h"
#define ID 0
#define KEYWORD 1
/***************************************************************
{Other useful code segments can be here.}
***************************************************************/
int commentdepth=0;

%}

letter		[A-Za-z_]
alnum		[A-Za-z0-9_]
digit		[0-9]
whitespace	[ \t\n]*
intc		([1-9]+{digit}*)|0
floatc		{digit}+\.{digit}*([eE][+-]?{digit}+)?
%start normal comment

%%
<normal>{whitespace}		{;}
<normal>{intc}			{printf("INT	%s\n",yytext);}
<normal>{intc}/".."		{printf("INT	%s\n",yytext);}
<normal>".."			{printf("OP	%s\n",yytext);}
<normal>{floatc}		{printf("F	%s\n",yytext);}
<normal>{letter}({letter}|{digit})*	{	
						struct id* tmp=enter(ID,yytext,strlen(yytext));//발견한 token을 집어넣어본다.
						if(tmp==NULL)//enter의 return값은 hashTable에 저장된 token에 대한 정보를 담고있는는 주소이다.
						{
							printf("empty string!\n");
							exit(1);
						}
						(tmp->count)++;//tmp가 NULL이 아니면 hashTable에 token이 들어있다는 것이므로 count를 1올려준다.
						if(tmp->tokenType == ID)
							printf("ID	%s	%d\n",yytext,tmp->count);
						else
							printf("KEYWORD	%s	%d\n",yytext,tmp->count);
					 }
<normal>"("			{printf("OP	%s\n",yytext);}
<normal>")"			{printf("OP	%s\n",yytext);}
<normal>"["			{printf("OP 	%s\n",yytext);}
<normal>"]"			{printf("OP 	%s\n",yytext);}
<normal>"{"			{printf("OP 	%s\n",yytext);}
<normal>"}"			{printf("OP 	%s\n",yytext);}
<normal>->			{printf("OP 	%s\n",yytext);}
<normal>,			{printf("OP 	%s\n",yytext);}
<normal>!			{printf("OP 	%s\n",yytext);}
<normal>"."			{printf("OP 	%s\n",yytext);}
<normal>~			{printf("OP 	%s\n",yytext);}
<normal>"++"			{printf("OP 	%s\n",yytext);}
<normal>--			{printf("OP 	%s\n",yytext);}
<normal>"*"			{printf("OP 	%s\n",yytext);}
<normal>"/"			{printf("OP 	%s\n",yytext);}
<normal>%			{printf("OP 	%s\n",yytext);}
<normal>"+"			{printf("OP 	%s\n",yytext);}
<normal>-			{printf("OP 	%s\n",yytext);}
<normal><<			{printf("OP 	%s\n",yytext);}
<normal>>>			{printf("OP 	%s\n",yytext);}
<normal><			{printf("OP 	%s\n",yytext);}
<normal><=			{printf("OP 	%s\n",yytext);}
<normal>>			{printf("OP 	%s\n",yytext);}
<normal>>=			{printf("OP 	%s\n",yytext);}
<normal>==			{printf("OP 	%s\n",yytext);}
<normal>!=			{printf("OP 	%s\n",yytext);}
<normal>&			{printf("OP 	%s\n",yytext);}
<normal>"^"			{printf("OP 	%s\n",yytext);}
<normal>"|"			{printf("OP 	%s\n",yytext);}
<normal>&&			{printf("OP 	%s\n",yytext);}
<normal>"||"			{printf("OP 	%s\n",yytext);}
<normal>"?"			{printf("OP 	%s\n",yytext);}
<normal>:			{printf("OP 	%s\n",yytext);}
<normal>;			{printf("OP 	%s\n",yytext);}
<normal>=			{printf("OP 	%s\n",yytext);}
<normal>"+="			{printf("OP 	%s\n",yytext);}
<normal>-=			{printf("OP 	%s\n",yytext);}
<normal>"*="			{printf("OP 	%s\n",yytext);}
<normal>"/="			{printf("OP 	%s\n",yytext);}
<normal>%=			{printf("OP 	%s\n",yytext);}
<normal>&=			{printf("OP	%s\n",yytext);}
<normal>"^="			{printf("OP 	%s\n",yytext);}
<normal>"|="			{printf("OP 	%s\n",yytext);}
<normal><<=			{printf("OP 	%s\n",yytext);}
<normal>>>=			{printf("OP 	%s\n",yytext);}
<normal>.			{;}
<normal>"*/"			{/*printf("COM	%s\n",yytext)*/;}
<normal>"/*"			{
				//	printf("COM	%s\n",yytext);
					commentdepth++;
					BEGIN comment;				
				}
<comment>"*/"			{//	printf("COM	%s\n",yytext);
					commentdepth--;
					if(commentdepth==0)
						BEGIN normal;			
				}
<comment>"/*"			{
				//	printf("COM	%s\n",yytext);
					commentdepth++;
				}
<comment>.			{;}
%%
extern id*enter(int,char*,int);
void initHash() 
{
	int i;

	char* keyWord[]={
		"auto","break","case","char","continue","default","do","double","else", "extern","float","for","goto","if","int","long","register","return","short", "sizeof","static","struct","switch","typedef","union","unsigned","void","while","\0"
	};

	/* Initilize Hash Tabel with Keywords */
	for (i = 0; strcmp(keyWord[i], "\0") !=0; i++) {
		enter(KEYWORD, keyWord[i],strlen(keyWord[i]));
	}
}

int main(int argc, char** argv)
{
	id* temp;

	++argv;
	--argc;

	if (argc > 0) {
		yyin = fopen(argv[0], "r");
	} else {
		yyin = stdin;
	}

	initHash();

	BEGIN normal;
	yylex ();

	return 0;
}
