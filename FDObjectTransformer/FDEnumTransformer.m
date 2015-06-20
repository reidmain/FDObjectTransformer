#import "FDEnumTransformer.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDEnumTransformer ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDEnumTransformer
{
	@private __strong NSMutableDictionary *_enumForString;
	@private __strong NSMutableDictionary *_stringForEnum;
}


#pragma mark - Properties


#pragma mark - Constructors

+ (instancetype)enumTransformerWithDictionary: (NSDictionary *)dictionary
{
	FDEnumTransformer *enumTransformer = [[self alloc] 
		initWithDictionary: dictionary];
	
	return enumTransformer;
}

- (instancetype)initWithDictionary: (NSDictionary *)dictionary
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	_enumForString = [NSMutableDictionary new];
	_stringForEnum = [NSMutableDictionary new];
	
	[dictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id value, BOOL *stop)
		{
			if ([key isKindOfClass: [NSNumber class]] == YES 
				&& [value isKindOfClass: [NSString class]] == YES)
			{
				[_enumForString setObject: key 
					forKey: value];
				[_stringForEnum setObject: value 
					forKey: key];
			}
			else if ([key isKindOfClass: [NSString class]] == YES 
				&& [value isKindOfClass: [NSNumber class]] == YES)
			{
				[_enumForString setObject: value 
					forKey: key];
				[_stringForEnum setObject: key 
					forKey: value];
			}
			else
			{
				[NSException raise: NSInternalInconsistencyException 
					format: @"Every key/value pair in the dictionary must be a string and a number. A %@ and %@ was attempting to be entered.", 
						[key class], 
						[value class]];
			}
		}];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods

- (NSNumber *)enumForString: (NSString *)string
{
	NSNumber *number = [_enumForString objectForKey: string];
	
	return number;
}

- (NSString *)stringForEnum: (NSNumber *)number
{
	NSString *string = [_stringForEnum objectForKey: number];
	
	return string;
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end