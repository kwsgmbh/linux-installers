/*****************************************************************
 * Project BridgEth-Base Productiontool
 * (c) copyright 2024
 * Company KWS Computersysteme Gmbh
 * All rights reserved
 *****************************************************************/
/**
 * @file tool.c
  * @author Frank Bintakies
 * A interface to show the EEPROM content.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 1024
#define MAX_KEYS 10
#define MAX_KEY_LENGTH 50
#define MAX_VALUE_LENGTH 100

#define MAX_PATH_LENGTH 100
#define MAX_LINE_LENGTH 100

typedef struct {
    char key[MAX_KEYS][MAX_KEY_LENGTH];
    char value[MAX_KEYS][MAX_VALUE_LENGTH];
    int count;
} JSON;

char* add_colon_every_two_chars(const char *input) {
    int input_length = strlen(input);
    // Allocate memory for the new string
    char *output = (char*)malloc((2 * input_length) + 1); // Add 1 for the null terminator
    if (output == NULL) {
        printf("Memory allocation failed.\n");
        exit(1);
    }

    int j = 0;
    for (int i = 0; i < input_length; i++) {
        // Copy character from input
        output[j++] = input[i];
        // Add colon after every two characters, except for the last character
        if (i % 2 == 1 && i != input_length - 1) {
            output[j++] = ':';
        }
    }
    // Add null terminator
    output[j] = '\0';

    return output;
}

// Function to replace single quotes with double quotes
void replace_quotes(char *str) {
    for (char *p = str; *p != '\0'; ++p) {
        if (*p == '\'') {
            *p = '"';
        }
    }
}

void parse_json(const char *json_string, JSON *json) {
    char *token, *rest;
    char *mutable_json_string = strdup(json_string);
    token = strtok_r(mutable_json_string, "{}\":,", &rest);
    json->count = 0;

    while (token != NULL) {
        if (json->count % 2 == 0) {
            strncpy(json->key[json->count / 2], token, MAX_KEY_LENGTH);
        } else {
            strncpy(json->value[json->count / 2], token, MAX_VALUE_LENGTH);
        }
        json->count++;
        token = strtok_r(NULL, "{}\":,", &rest);
    }

    free(mutable_json_string);
}


int main() {
    JSON json;
    FILE *fp;
    char line[MAX_LINE_LENGTH];
    char buffer[BUFFER_SIZE];
    char command[] = "cat /proc/device-tree/hat/product";
    char modified_product[BUFFER_SIZE];

    const char *file_path = "/proc/device-tree/hat/vendor";

    fp = fopen(file_path, "r");
    if (fp == NULL) {
        fprintf(stderr, "Failed to open file: %s\n", file_path);
        return 1;
    }

    // Read and print each line from the file
    while (fgets(line, MAX_LINE_LENGTH, fp) != NULL) {
        printf("%s \n\n", line);
    }

    // Close the file
    fclose(fp);

    // Open the /proc/device-tree/hat/product file for reading
    fp = popen(command, "r");
    if (fp == NULL) {
        fprintf(stderr, "Failed to run command\n");
        return 1;
    }

    // Read the contents of the file
    if (fgets(buffer, BUFFER_SIZE, fp) != NULL) {
        // Replace single quotes with double quotes
        replace_quotes(buffer);
        // Copy modified product to another buffer
        strcpy(modified_product, buffer);
    }

    // Close the file pointer
    pclose(fp);
    // Parse and print the modified product as decoded JSON
    parse_json(modified_product, &json);

    for (int i = 0; i < json.count / 2; i++) {
	if(strcmp(json.key[i],"MAC1") == 0 || strcmp(json.key[i],"MAC2") == 0 || strcmp(json.key[i],"MAC3") == 0)
	{
		char *modstring = add_colon_every_two_chars(json.value[i]);
		printf("%s: %s\n",json.key[i], modstring);
	}
	else
	{
        	printf("%s: %s\n", json.key[i], json.value[i]);
	}
    }

    return 0;
}
