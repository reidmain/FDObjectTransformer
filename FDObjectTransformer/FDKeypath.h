// Inspiration for this macro taken from https://github.com/jspahrsummers/libextobjc
// The idea is in the long term to add some mechanism for checking if two parameters are passed into the keypath macro or one so you don't need to use keypathForObject or keypathForClass.
#if !defined(keypath)
	#define keypath(...) \
		keypathForClass(__VA_ARGS__)
#endif

#if !defined(keypathForObject)
	#define keypathForObject(PATH) \
		(((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))
#endif

#if !defined(keypathForClass)
	#define keypathForClass(CLASS, PATH) \
		(((void)(NO && ((void)((CLASS *)nil).PATH, NO)), # PATH))
#endif