#import "FDRandomModel.h"


#pragma mark - Class Definition

@implementation FDRandomModel


#pragma mark - Properties

- (NSString *)className
{
	NSString *className = NSStringFromClass([self class]);
	
	return className;
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
	_createdAt = [NSDate date];
	
	// Return initialized instance.
	return self;
}


@end