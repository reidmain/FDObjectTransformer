#import "FDJSONObjectTransformerAdapter.h"
#import "FDObjectTransformerAdapter.h"
#import "NSObject+DeclaredProperty.h"
#import "FDObjectTransformer.h"
#import "FDThreadSafeMutableDictionary.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDJSONObjectTransformerAdapter ()
<
	FDObjectTransformerAdapter
>

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDJSONObjectTransformerAdapter
{
	@private __strong FDThreadSafeMutableDictionary *_remoteKeysForLocalKeys;
	@private __strong FDThreadSafeMutableDictionary *_collectionTypes;
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
	_remoteKeysForLocalKeys = [FDThreadSafeMutableDictionary new];
	_collectionTypes = [FDThreadSafeMutableDictionary new];
	_valueTransformers = [FDThreadSafeMutableDictionary new];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods

- (void)registerRemoteKey: (NSString *)remoteKey forLocalKey: (NSString *)localKey
{
	[_remoteKeysForLocalKeys setValue: remoteKey 
		forKey: localKey];
}

- (NSString *)remoteKeyForLocalKey: (NSString *)localKey
{
	NSString *remoteKey = [_remoteKeysForLocalKeys objectForKey: localKey];
	
	if (remoteKey == nil)
	{
		switch (_propertyNamingPolicy)
		{
			case FDJSONObjectTransformerAdapterPropertyNamingPolicyIdentity:
			{
				remoteKey = localKey;
				
				break;
			}
			
			case FDJSONObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores:
			{
				NSMutableString *lowercaseRemoteKey = [NSMutableString new];
				
				NSScanner *scanner = [NSScanner scannerWithString: localKey];
				while ([scanner isAtEnd] == NO)
				{
					NSString *uppercaseCharacters = nil;
					[scanner scanCharactersFromSet: [NSCharacterSet uppercaseLetterCharacterSet] 
						intoString: &uppercaseCharacters];
					if (uppercaseCharacters != nil)
					{
						if ([lowercaseRemoteKey length] > 0)
						{
							[lowercaseRemoteKey appendString:@"_"];
						}
						[lowercaseRemoteKey appendString: [uppercaseCharacters lowercaseString]];
					}
					
					NSString *lowercaseCharacters = nil;
					[scanner scanCharactersFromSet: [NSCharacterSet lowercaseLetterCharacterSet] 
						intoString: &lowercaseCharacters];
					if (lowercaseCharacters != nil)
					{
						[lowercaseRemoteKey appendString: [lowercaseCharacters lowercaseString]];
					}
				}
				
				remoteKey = [lowercaseRemoteKey copy];
			}
		}
	}
	
	return remoteKey;
}

- (void)registerCollectionType: (Class)collectionType 
	forPropertyName: (NSString *)propertyName
{
	[_collectionTypes setValue: collectionType 
		forKey: propertyName];
}

- (void)registerValueTransformer: (NSValueTransformer *)valueTransformer 
	forPropertyName: (NSString *)propertyName
{
	[_valueTransformers setValue: valueTransformer 
		forKey: propertyName];
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods


#pragma mark - FDObjectTransformerAdapter Methods

- (id)transformObject:(id)object intoClass:(Class)targetClass fromObjectTransformer: (FDObjectTransformer *)objectTransformer;
{
	id transformedObject = nil;
	
	if ([object isKindOfClass: [NSDictionary class]] == YES)
	{
		transformedObject = [targetClass new];
		
		NSArray *declaredProperties = [targetClass fd_declaredPropertiesUntilSuperclass: [NSObject class]];
		[declaredProperties enumerateObjectsUsingBlock: ^(FDDeclaredProperty *declaredProperty, NSUInteger index, BOOL *stop)
			{
				// If the property being set is a read-only property with no backing instance variable setValue:forKey: will always throw an exception so ignore the property. This is indicative of a computed property so it does not need to be set anyway.
				if (declaredProperty.isReadOnly == YES 
					&& declaredProperty.backingInstanceVariableName == nil)
				{
					return;
				}
				
				NSString *remoteKey = [self remoteKeyForLocalKey: declaredProperty.name];
				id dictionaryObject = [object objectForKey: remoteKey];
				
				// If the declared property's name does not exist in the dictionary ignore it and move onto the next property. There is no point in dealing with a property that does not exist because it could only delete data that currently exists.
				if (dictionaryObject == nil)
				{
					return;
				}
				
				id transformedDictionaryObject = nil;
				
				// If the dictionary object is not NSNull attempt to transform it otherwise do nothing and allow the property being set to be cleared.
				if (dictionaryObject != [NSNull null])
				{
					NSValueTransformer *valueTransformer = [_valueTransformers objectForKey: declaredProperty.name];
					if (valueTransformer != nil)
					{
						transformedDictionaryObject = [valueTransformer transformedValue: dictionaryObject];
					}
					else if ([dictionaryObject isKindOfClass: [NSArray class]] == YES 
						&& declaredProperty.objectClass == [NSArray class])
					{
						Class collectionType = [_collectionTypes objectForKey: declaredProperty.name];
						if (collectionType)
						{
							transformedDictionaryObject = [objectTransformer objectOfClass: collectionType 
								from: dictionaryObject];
						}
					}
					// If the declared property is not a scalar type attempt to transform the dictionary object into an instance of the property type.
					else if (declaredProperty.objectClass != nil)
					{
						transformedDictionaryObject = [objectTransformer objectOfClass: declaredProperty.objectClass 
							from: dictionaryObject];
					}
					else
					{
						transformedDictionaryObject = dictionaryObject;
					}
				}
				
				// If the transformed object is not the same type as the property that is being set stop parsing and move onto the next item because there is no point in attempting to set it since it will always result in nil.
				if (declaredProperty.objectClass != nil 
					&& transformedDictionaryObject != nil 
					&& [transformedDictionaryObject isKindOfClass: declaredProperty.objectClass] == NO)
				{
					return;
				}
				// If the transformed object is nil and the declared property is a scalar type do not bother trying to set the property because it will only result in an exception.
				else if (transformedDictionaryObject == nil 
					&& declaredProperty.typeEncoding != FDDeclaredPropertyTypeEncodingObject)
				{
					return;
				}
				
				[transformedObject setValue: transformedDictionaryObject 
					forKey: declaredProperty.name];
			}];
	}
	
	return transformedObject;
}


@end