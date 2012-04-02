// Macros

#define NSDICT(...) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil]
#define NSARRAY(...) [NSArray arrayWithObjects: __VA_ARGS__, nil]
#define NSSET(...) [NSSet setWithObjects: __VA_ARGS__, nil]
#define NSURL(s) [NSURL URLWithString:s]
