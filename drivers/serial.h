#if !defined(SERIAL_H)
#define SERIAL_H

void serial_initialize(void);
void serial_writechar(char c);
void serial_writestring(const char* data);

#endif // SERIAL_H