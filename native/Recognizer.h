#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

// TODO
// 2 layers of callbacks (Delegate => self.callback)
// 3 layers of access (c wrappers => Recognizer methods => NSSpeechRecognizer methods)

void test_NSSpeechRecognizer(void(*f)(const char*), const char* s);

////////////////////////////////////////////////////////////////////////////////

// CallbackRecognizer, only fields

@interface Recognizer : NSObject <NSSpeechRecognizerDelegate>

@property (retain, atomic) NSSpeechRecognizer* recognizer;
@property void(*handler)(const char*); // void(NSString*)

- (id) init;

- (void) speechRecognizer:(NSSpeechRecognizer *)recognizer didRecognizeCommand:(NSString *)_recognition;

@end

////////////////////////////////////////////////////////////////////////////////

Recognizer* new_NSSpeechRecognizer();

void free_NSSpeechRecognizer(Recognizer*);

void start_NSSpeechRecognizer(Recognizer*);

void stop_NSSpeechRecognizer(Recognizer*);

void setCommands_NSSpeechRecognizer(Recognizer*, const char* [], int length);

void setHandler_NSSpeechRecognizer(Recognizer* this, void(*handler)(const char*));

////////////////////////////////////////////////////////////////////////////////
