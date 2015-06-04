#import "FDObjectTransformer.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDObjectTransformer ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDObjectTransformer


#pragma mark - Properties


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

- (id)objectOfClass: (Class)objectClass from:(id)from
{
	if (objectClass == nil 
		|| from == nil)
	{
		return nil;
	}
	
	if ([from isKindOfClass: objectClass] == YES)
	{
		return from;
	}
	
	id transformedObject = nil;
	
	if (objectClass == [NSString class])
	{
		if ([from isKindOfClass: [NSNumber class]] == YES)
		{
			transformedObject = [from stringValue];
		}
		else if ([from isKindOfClass: [NSURL class]] == YES)
		{
			transformedObject = [from absoluteString];
		}
		else if ([from isKindOfClass: [NSDate class]] == YES)
		{
			transformedObject = [_dateFormatter stringFromDate: from];
		}
		else
		{
			transformedObject = [from description];
		}
	}
	else if (objectClass == [NSNumber class])
	{
		if ([from isKindOfClass: [NSString class]] == YES)
		{
			transformedObject = @([from longLongValue]);
		}
	}
	else if (objectClass == [NSURL class])
	{
		if ([from isKindOfClass: [NSString class]] == YES)
		{
			transformedObject = [NSURL URLWithString: from];
		}
	}
	
	return transformedObject;
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end