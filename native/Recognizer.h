#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

// TODO
// 2 layers of callbacks (Delegate => self.callback)
// 3 layers of access (c wrappers => Recognizer methods => NSSpeechRecognizer methods)

void test_NSSpeechRecognizer(void(*f)(const char*), const char* s);

void beginRunLoop();

////////////////////////////////////////////////////////////////////////////////

// CallbackRecognizer, only fields

@interface Recognizer : NSObject <NSSpeechRecognizerDelegate>

@property (retain, atomic) NSSpeechRecognizer* recognizer;
@property void(*handler)(const char*); // void(NSString*)

- (id) init;

- (void) speechRecognizer:(NSSpeechRecognizer *)recognizer didRecognizeCommand:(NSString *)_recognition;

@end

////////////////////////////////////////////////////////////////////////////////

Recognizer* init_NSSpeechRecognizer();

void free_NSSpeechRecognizer(Recognizer*);

void start_NSSpeechRecognizer(Recognizer*);

void stop_NSSpeechRecognizer(Recognizer*);

void setExclusivity_NSSpeechRecognizer(Recognizer*, BOOL);

void setForegroundOnly_NSSpeechRecognizer(Recognizer*, BOOL);

void setCommands_NSSpeechRecognizer(Recognizer*, const char* [], int length);

void registerHandler_NSSpeechRecognizer(Recognizer* this, void(*handler)(const char*));

////////////////////////////////////////////////////////////////////////////////
