#include <stddef.h>
#include "string.h"

size_t string_length(const char *str) {
    size_t length = 0;
    while (str[length] != '\0') {
        length++;
    }
    return length;
}