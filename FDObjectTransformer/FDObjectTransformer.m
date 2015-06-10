#import "FDObjectTransformer.h"
#import "FDColor+Creation.h"
#import "NSObject+DeclaredProperty.h"


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
			transformedObject = @([from longLongValue]);
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
					// TODO: Add some way for the remote key to not be exactly the same as the property name.
					id remoteObject = [from objectForKey: declaredProperty.name];
					
					id bah = remoteObject;
					
					if (declaredProperty.objectClass != nil)
					{
						bah = [self objectOfClass: declaredProperty.objectClass 
							from: remoteObject];
					}
					
					[object setValue: bah 
						forKey: declaredProperty.name];
				}];
			
			transformedObject = object;
		}
	}
	
	return transformedObject;
}


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end