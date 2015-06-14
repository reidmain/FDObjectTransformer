#import "FDObjectTransformer.h"
#import "FDColor+Creation.h"
#import "NSObject+DeclaredProperty.h"
#import "FDThreadSafeMutableDictionary.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDObjectTransformer ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDObjectTransformer
{
	@private __strong FDThreadSafeMutableDictionary *_adaptersGoingToClass;
	@private __strong NSNumberFormatter *_numberFormatter;
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
	_adaptersGoingToClass = [FDThreadSafeMutableDictionary new];
	_numberFormatter = [NSNumberFormatter new];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods

- (id)objectOfClass: (Class)objectClass from:(id)from
{
	 // If the object is a NSNull return nil to prevent the inevitable crash caused by NSNull getting sent a message.
    if (from == [NSNull null])
	{
        return nil;
    }
	
	// If either the object class or the object are nil there is nothing that can be done and nil should be returned.
	if (objectClass == nil 
		|| from == nil)
	{
		return nil;
	}
	
	// If the object is a kind of a the object class there is nothing to do and simply return the object.
	if ([from isKindOfClass: objectClass] == YES)
	{
		return from;
	}
	
	id transformedObject = nil;
	
	NSString *toClassString = NSStringFromClass(objectClass);
	FDThreadSafeMutableDictionary *adaptersGoingFromClass = [_adaptersGoingToClass objectForKey: toClassString];
	if ([adaptersGoingFromClass count] > 0)
	{
		Class fromClass = [from class];
		while (fromClass)
		{
			NSString *fromClassString = NSStringFromClass(fromClass);
			id<FDObjectTransformerAdapter> adapter = [adaptersGoingFromClass objectForKey: fromClassString];
			if (adapter)
			{
				transformedObject = [adapter transformObject:from intoClass:objectClass];
				
				return transformedObject;
			}
			
			fromClass = [fromClass superclass];
		}
	}
	
	if ([from isKindOfClass: [NSArray class]] == YES)
	{
		Class arrayClass = [from class];
		NSMutableArray *mutableArray = [NSMutableArray array];
		
		[from enumerateObjectsUsingBlock: ^(id objectInArray, NSUInteger index, BOOL *stop)
			{
				id transformedObjectInArray = [self objectOfClass: objectClass 
					from: objectInArray];
				
				if (transformedObjectInArray != nil)
				{
					[mutableArray addObject: transformedObjectInArray];
				}
			}];
		
		transformedObject = [arrayClass arrayWithArray: mutableArray];
	}
	else if (objectClass == [NSString class])
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
			transformedObject = [_numberFormatter numberFromString: from];
		}
	}
	else if (objectClass == [NSDate class])
	{
		if ([from isKindOfClass: [NSString class]] == YES)
		{
			transformedObject = [_dateFormatter dateFromString: from];
		}
	}
	else if (objectClass == [NSURL class])
	{
		if ([from isKindOfClass: [NSString class]] == YES)
		{
			transformedObject = [NSURL URLWithString: from];
		}
	}
	else if (objectClass == [FDColor class])
	{
		if ([from isKindOfClass: [NSNumber class]] == YES)
		{
			transformedObject = [FDColor fd_colorFromRGBANumber: from];
		}
		else if ([from isKindOfClass: [NSString class]] == YES)
		{
			transformedObject = [FDColor fd_colorFromHexString: from];
		}
	}
	else if (objectClass == [NSDictionary class])
	{
		NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
		
		NSArray *declaredProperties = [[from class] fd_declaredPropertiesUntilSuperclass: [NSObject class]];
		[declaredProperties enumerateObjectsUsingBlock: ^(FDDeclaredProperty *declaredProperty, NSUInteger index, BOOL *stop)
			{
				id propertyValue = [from valueForKey: declaredProperty.name];
				
				[mutableDictionary setValue: propertyValue 
					forKey: declaredProperty.name];
			}];
		
		transformedObject = mutableDictionary;
	}
	else
	{
		if ([from isKindOfClass: [NSDictionary class]] == YES)
		{
			id object = [objectClass new];
			
			NSArray *declaredProperties = [objectClass fd_declaredPropertiesUntilSuperclass: [NSObject class]];
			[declaredProperties enumerateObjectsUsingBlock: ^(FDDeclaredProperty *declaredProperty, NSUInteger index, BOOL *stop)
				{
					// If the property being set is a read-only property with no backing instance variable setValue:forKey: will always throw an exception so ignore the property. This is indicative of a computed property so it does not need to be set anyway.
					if (declaredProperty.isReadOnly == YES 
						&& declaredProperty.backingInstanceVariableName == nil)
					{
						return;
					}
					
					id dictionaryObject = [from objectForKey: declaredProperty.name];
					
					// If the declared property's name does not exist in the dictionary ignore it and move onto the next property. There is no point in dealing with a property that does not exist because it could only delete data that currently exists.
					if (dictionaryObject == nil)
					{
						return;
					}
					
					id transformedDictionaryObject = nil;
					
					// If the dictionary object is not NSNull attempt to transform it into the object class. If the dictionary object is NSNull do nothing and allow the property being set to be cleared.
					if (dictionaryObject != [NSNull null])
					{
						// If the declared property is not a scalar type attempt to transform the dictionary object into an instance of the property type.
						if (declaredProperty.objectClass != nil)
						{
							transformedDictionaryObject = [self objectOfClass: declaredProperty.objectClass 
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
					
					[object setValue: transformedDictionaryObject 
						forKey: declaredProperty.name];
				}];
			
			transformedObject = object;
		}
	}
	
	return transformedObject;
}

- (void)registerAdapter:(id<FDObjectTransformerAdapter>)adapter fromClass:(Class)fromClass toClass:(Class)toClass
{
	NSString *toClassString = NSStringFromClass(toClass);
	FDThreadSafeMutableDictionary *adaptersGoingFromClass = [_adaptersGoingToClass objectForKey: toClassString];
	if (adaptersGoingFromClass == nil)
	{
		adaptersGoingFromClass = [FDThreadSafeMutableDictionary new];
		[_adaptersGoingToClass setObject: adaptersGoingFromClass 
			forKey: toClassString];
	}
	
	NSString *fromClassString = NSStringFromClass(fromClass);
	[adaptersGoingFromClass setValue: adapter 
		forKey: fromClassString];
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end