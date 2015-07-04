#import "FDObjectDescriptor.h"

#import "FDThreadSafeMutableDictionary.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDObjectDescriptor ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDObjectDescriptor
{
	@private __strong FDThreadSafeMutableDictionary *_remoteKeyPathsForLocalKeys;
	@private __strong FDThreadSafeMutableDictionary *_collectionTypes;
	@private __strong FDThreadSafeMutableDictionary *_enumTransformers;
	@private __strong FDThreadSafeMutableDictionary *_valueTransformers;
}


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
	_remoteKeyPathsForLocalKeys = [FDThreadSafeMutableDictionary new];
	_collectionTypes = [FDThreadSafeMutableDictionary new];
	_enumTransformers = [FDThreadSafeMutableDictionary new];
	_valueTransformers = [FDThreadSafeMutableDictionary new];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods

- (void)registerRemoteKeyPath: (NSString *)remoteKeyPath 
	forLocalKey: (NSString *)localKey
{
	[_remoteKeyPathsForLocalKeys setValue: remoteKeyPath 
		forKey: localKey];
}

- (NSString *)remoteKeyPathForLocalKey: (NSString *)localKey
{
	NSString *remoteKeyPath = [_remoteKeyPathsForLocalKeys objectForKey: localKey];
	
	if (remoteKeyPath == nil)
	{
		switch (_propertyNamingPolicy)
		{
			case FDObjectDescriptorPropertyNamingPolicyIdentity:
			{
				remoteKeyPath = localKey;
				
				break;
			}
			
			case FDObjectDescriptorPropertyNamingPolicyLowerCaseWithUnderscores:
			{
				NSMutableString *lowercaseRemoteKeyPath = [NSMutableString new];
				
				NSScanner *scanner = [NSScanner scannerWithString: localKey];
				while ([scanner isAtEnd] == NO)
				{
					NSString *uppercaseCharacters = nil;
					[scanner scanCharactersFromSet: [NSCharacterSet uppercaseLetterCharacterSet] 
						intoString: &uppercaseCharacters];
					if (uppercaseCharacters != nil)
					{
						if ([lowercaseRemoteKeyPath length] > 0)
						{
							[lowercaseRemoteKeyPath appendString:@"_"];
						}
						[lowercaseRemoteKeyPath appendString: [uppercaseCharacters lowercaseString]];
					}
					
					NSString *lowercaseCharacters = nil;
					[scanner scanCharactersFromSet: [NSCharacterSet lowercaseLetterCharacterSet] 
						intoString: &lowercaseCharacters];
					if (lowercaseCharacters != nil)
					{
						[lowercaseRemoteKeyPath appendString: [lowercaseCharacters lowercaseString]];
					}
				}
				
				remoteKeyPath = [lowercaseRemoteKeyPath copy];
			}
		}
	}
	
	return remoteKeyPath;
}

- (void)registerCollectionType: (Class)collectionType 
	forPropertyName: (NSString *)propertyName
{
	[_collectionTypes setValue: collectionType 
		forKey: propertyName];
}

- (Class)collectionTypeForPropertyName: (NSString *)propertyName
{
	Class collectionType = [_collectionTypes objectForKey: propertyName];
	
	return collectionType;
}

- (void)registerEnumDictionary: (NSDictionary *)dictionary 
	forLocalKey: (NSString *)localKey
{
	FDEnumTransformer *enumTransformer = [FDEnumTransformer enumTransformerWithDictionary: dictionary];
	[_enumTransformers setValue: enumTransformer 
		forKey: localKey];
}

- (FDEnumTransformer *)enumTransformerForLocalKey: (NSString *)localKey
{
	FDEnumTransformer *enumTransformer = [_enumTransformers objectForKey: localKey];
	
	return enumTransformer;
}

- (void)registerValueTransformer: (NSValueTransformer *)valueTransformer 
	forPropertyName: (NSString *)propertyName
{
	[_valueTransformers setValue: valueTransformer 
		forKey: propertyName];
}

- (NSValueTransformer *)valueTransformerForPropertyName: (NSString *)propertyName
{
	NSValueTransformer *valueTransformer = [_valueTransformers objectForKey: propertyName];
	
	return valueTransformer;
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end