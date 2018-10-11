/***************************************************************
 * File Name    : hash.c
 * Description
 *      This is an implementation file for the open hash table.
 *
 ****************************************************************/
#define  HASH_TABLE_SIZE   101
#include "subc.h"
#include "stdlib.h"
#include "stdio.h"
#include "string.h"
typedef struct nlist {
	struct nlist *next;
	id *data;
} nlist;

static nlist *hashTable[HASH_TABLE_SIZE];

id *enter(int tokenType, char *name, int length);
id *enter(int tokenType, char *name, int length) {
	if(name == NULL || length ==0)
		return NULL;
	int i;
	unsigned int key=0;
	struct nlist* toInsert =(struct nlist *)malloc(sizeof(struct nlist));//동적할당
	struct id* toInsertID = (struct id *)malloc(sizeof(struct id));
	toInsertID->name=(char*)malloc(sizeof(char)*100);
	toInsert->next=NULL;
	toInsert->data=toInsertID;
	toInsert->data->tokenType = tokenType;
	strcpy(toInsert->data->name,name);
	toInsert->data->count=0;
	for(i=0;i<length;i++)//문자열 ascii값을 다 더해서 key값생성
	{
		key+=name[i];
	}
	key%=HASH_TABLE_SIZE;
	
	if(hashTable[key]==NULL)//key값이 가르키는 위치가 비어있다면 그곳에 token을 저장한다.
	{	
		hashTable[key]=toInsert;
		return hashTable[key]->data;
	}
	else
	{
		struct nlist ** tmp = &hashTable[key];
		if(strcmp((*tmp)->data->name,name)==0)//token이 이미 들어있었다면 주소를 return해준다.
		{	
			free(toInsertID->name);
			free(toInsertID);
			toInsertID=NULL;
			free(toInsert);
			toInsert=NULL;

			return (*tmp)->data;
		}
		while((*tmp)->next!=NULL)//token이 저장되어있는 위치를 찾거나 hashTable list의 끝에 도달했을때까지 다음 list의 원소를 탐색한다.
		{
			if(strcmp((*tmp)->data->name,name)==0)
			{
				free(toInsertID->name);
				free(toInsertID);
				toInsertID=NULL;
				free(toInsert);
				toInsert=NULL;

				return (*tmp)->data;
			}
			tmp=&((*tmp)->next);
		}
		if(strcmp((*tmp)->data->name,name)==0)//token이 list에 마지막에 있었을 경우에 대한 처리이다.
		{
			free(toInsertID->name);
			free(toInsertID);
			toInsertID=NULL;
			free(toInsert);
			toInsert=NULL;
		
			return (*tmp)->data;
		}
		//token이 hashTable에 없었을 경우 새로 저장하고 그 주소를 return해준다.
		(*tmp)->next=toInsert;
	
		return (*tmp)->next->data;
	}
}
