#import "FDObjectTransformer.h"

#import "FDColor+Creation.h"
#import "NSObject+DeclaredProperty.h"
#import "FDThreadSafeMutableDictionary.h"
#import "FDJSONObject.h"
#import "FDDictionaryToObjectAdapter.h"
#import "FDObjectToDictionaryAdapter.h"
#import "FDObjectToJSONObjectAdapter.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDObjectTransformer ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDObjectTransformer
{
	@private __strong NSNumberFormatter *_numberFormatter;
	@private __strong FDThreadSafeMutableDictionary *_adaptersGoingToClass;
	@private __strong FDThreadSafeMutableDictionary *_descriptorsForClass;
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
	_numberFormatter = [NSNumberFormatter new];
	_adaptersGoingToClass = [FDThreadSafeMutableDictionary new];
	_descriptorsForClass = [FDThreadSafeMutableDictionary new];
	
	// TODO: Evaluate if this actually should be done here. I'm starting to think that a FDJSONObjectTransformerAdapter shouldn't store a model class with it because it is really only used as a way to simplify the registering of it with a transformer.
	[self registerAdapter: [FDDictionaryToObjectAdapter new] 
		fromClass: [NSDictionary class] 
		toClass: [NSObject class]];
	
	[self registerAdapter: [FDObjectToDictionaryAdapter new] 
		fromClass: [NSObject class] 
		toClass: [NSDictionary class]];
		
	[self registerAdapter: [FDObjectToJSONObjectAdapter new] 
		fromClass: [NSObject class] 
		toClass: [FDJSONObject class]];
	
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
	else
	{
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

- (void)registerDescriptor: (FDObjectDescriptor *)descriptor forClass: (Class)objectClass
{
	NSString *toClassString = NSStringFromClass(objectClass);
	[_descriptorsForClass setValue: descriptor 
		forKey: toClassString];
}

- (NSArray *)descriptorsForClass: (Class)objectClass
{
	NSMutableArray *descriptors = [NSMutableArray new];
	
	while (objectClass != nil)
	{
		NSString *objectClassString = NSStringFromClass(objectClass);
		FDObjectDescriptor *descriptor = [_descriptorsForClass objectForKey: objectClassString];
		if (descriptor != nil)
		{
			[descriptors addObject: descriptor];
		}
		
		objectClass = [objectClass superclass];
	}
	
	if ([descriptors count] == 0)
	{
		FDObjectDescriptor *descriptor = [FDObjectDescriptor new];
		
		[descriptors addObject: descriptor];
	}
	
	return descriptors;
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end