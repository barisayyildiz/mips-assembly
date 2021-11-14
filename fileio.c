#include <stdio.h>
#include <stdlib.h>

void strToInt(char *str, int counter, int *num){
	int temp = 0;
	int digit;
	int times = 1;
	for(int i=0; i<counter; i++){
		// calculate times
		for(int j=0; j<counter-i-1; j++){
			times *= 10;
		}
		digit = (int)(str[i]-48);
		temp += (digit*times);
		times = 1;
	}
	*num = temp;
}

int main(){
	char ch;
	char *str = (char*)malloc(sizeof(char)*5);
	int counter = 0;
	int num;

	FILE *fp;
	fp = fopen("input.txt", "r");

	while((ch = fgetc(fp)) != EOF){
		if(ch == ' '){
			// str to int
			strToInt(str, counter, &num);
			printf("num : %d\n", num);
			counter = 0;
		}else{
			str[counter++] = ch;
		}
	}
	return 0;
}

