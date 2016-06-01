
/*
take a callback

{{ void(*f)(const char*) }} means {{ void f(const char*) }}
*/
void NSSpeechRecognizer(void(*f)(const char*), const char* s) {
  f(s);
}
