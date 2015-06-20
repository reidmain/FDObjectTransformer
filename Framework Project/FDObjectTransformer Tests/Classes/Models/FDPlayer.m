#import "FDPlayer.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDPlayer ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDPlayer


#pragma mark - Properties

- (NSString *)fullName
{
	NSString *fullName = [NSString stringWithFormat: @"%@ %@", 
		_firstName, 
		_lastName];
	
	return fullName;
}


#pragma mark - Constructors

- (id)init
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end