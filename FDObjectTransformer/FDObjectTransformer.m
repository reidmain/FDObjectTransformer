#import "FDObjectTransformer.h"
#import "FDColor+Creation.h"
#import "NSObject+DeclaredProperty.h"
#import "FDThreadSafeMutableDictionary.h"
#import "FDJSONObject.h"


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
	
	Class toClass = objectClass;
	while (toClass != nil)
	{
		NSString *toClassString = NSStringFromClass(toClass);
		FDThreadSafeMutableDictionary *adaptersGoingFromClass = [_adaptersGoingToClass objectForKey: toClassString];
		if ([adaptersGoingFromClass count] > 0)
		{
			Class fromClass = [from class];
			while (fromClass != nil)
			{
				NSString *fromClassString = NSStringFromClass(fromClass);
				id<FDObjectTransformerAdapter> adapter = [adaptersGoingFromClass objectForKey: fromClassString];
				if (adapter != nil)
				{
					transformedObject = [adapter transformObject:from intoClass:objectClass fromObjectTransformer: self];
					
					return transformedObject;
				}
				
				fromClass = [fromClass superclass];
			}
		}
		
		toClass = [toClass superclass];
	}
	
	if ([from isKindOfClass: [NSArray class]] == YES)
	{
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
		
		// TODO: Create an instance of the array class instead of always returning a NSArray.
		transformedObject = [NSArray arrayWithArray: mutableArray];
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
		FDDictionaryObjectTransformerAdapter *adapter = [FDDictionaryObjectTransformerAdapter new];
		
		transformedObject = [adapter transformObject: from 
				intoClass: objectClass 
				fromObjectTransformer: self];
	}
	else
	{
		if ([from isKindOfClass: [NSDictionary class]] == YES)
		{
			FDDictionaryObjectTransformerAdapter *adapter = [FDDictionaryObjectTransformerAdapter new];
			
			transformedObject = [adapter transformObject: from 
				intoClass: objectClass 
				fromObjectTransformer: self];
		}
	}
	
	return transformedObject;
}

- (id)jsonObjectFrom: (id)from
{
	id jsonObject = [self objectOfClass: [FDJSONObject class] 
		from: from];
	
	return jsonObject;
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

- (void)registerJSONAdapter:(FDJSONObjectTransformerAdapter *)adapter
{
	[self registerAdapter: adapter 
		fromClass: [NSDictionary class] 
		toClass: adapter.modelClass];
	
	[self registerAdapter: adapter 
		fromClass: adapter.modelClass 
		toClass: [FDJSONObject class]];
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end