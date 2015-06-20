#import "FDJSONObjectTransformerAdapter.h"
#import "FDObjectTransformerAdapter.h"
#import "NSObject+DeclaredProperty.h"
#import "FDObjectTransformer.h"
#import "FDJSONObject.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDJSONObjectTransformerAdapter ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDJSONObjectTransformerAdapter
{
}


#pragma mark - Properties


#pragma mark - Constructors

+ (instancetype)adapterForClass: (Class)modelClass
{
	FDJSONObjectTransformerAdapter *adapter = [[self alloc] 
		initWithClass: modelClass];
	
	return adapter;
}

- (instancetype)initWithClass: (Class)modelClass
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	_modelClass = modelClass;
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods



#pragma mark - Overridden Methods


#pragma mark - Private Methods


#pragma mark - FDObjectTransformerAdapter Methods

- (id)transformObject:(id)object intoClass:(Class)targetClass fromObjectTransformer: (FDObjectTransformer *)objectTransformer
{
	id transformedObject = nil;
	
	if ([targetClass isSubclassOfClass: [FDJSONObject class]] == YES)
	{
		NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
		
		NSArray *declaredProperties = [[object class] fd_declaredPropertiesUntilSuperclass: [NSObject class]];
		[declaredProperties enumerateObjectsUsingBlock: ^(FDDeclaredProperty *declaredProperty, NSUInteger index, BOOL *stop)
			{
				// If the property being read is a read-only property with no backing instance variable this is indicative of a computed property so it does not need to be converted to JSON.
				if (declaredProperty.isReadOnly == YES 
					&& declaredProperty.backingInstanceVariableName == nil)
				{
					return;
				}
				
				id value = [object valueForKey: declaredProperty.name];
				id transformedValue = nil;
				
				FDEnumTransformer *enumTransformer = [self enumTransformerForLocalKey: declaredProperty.name];
				if (enumTransformer != nil)
				{
					transformedValue = [enumTransformer stringForEnum: value];
				}
				else
				{
					transformedValue = [self _jsonObjectFrom: value 
						fromObjectTransformer: objectTransformer];
				}
				
				if (transformedValue != nil)
				{
					NSString *remoteKey = [self remoteKeyForLocalKey: declaredProperty.name];
					[mutableDictionary setValue: transformedValue 
						forKey: remoteKey];
				}
			}];
		
		transformedObject = [mutableDictionary copy];
	}
	else
	{
		transformedObject = [super transformObject: object 
			intoClass: targetClass 
			fromObjectTransformer: objectTransformer];
	}
	
	return transformedObject;
}


#pragma mark - Private Methods

- (id)_jsonObjectFrom: (id)from  fromObjectTransformer: (FDObjectTransformer *)objectTransformer
{
	if (from == nil)
	{
		return nil;
	}
	
	id jsonObject = nil;
	
	if ([from isKindOfClass: [NSArray class]] == YES)
	{
		NSMutableArray *mutableArray = [NSMutableArray new];
		
		[from enumerateObjectsUsingBlock: ^(id objectInArray, NSUInteger index, BOOL *stop)
			{
				id transformedObject = [self _jsonObjectFrom: objectInArray 
					fromObjectTransformer: objectTransformer];
				
				if (transformedObject != nil) {
					[mutableArray addObject: transformedObject];
				}
			}];
		
		jsonObject = [mutableArray copy];
	}
	else if ([from isKindOfClass: [NSString class]] == YES 
		|| [from isKindOfClass: [NSNumber class]] == YES 
		|| [from isKindOfClass: [NSNull class]] == YES)
	{
		jsonObject = from;
	}
	else if ([from isKindOfClass: [NSDate class]] == YES 
		|| [from isKindOfClass:[NSURL class]])
	{
        jsonObject = [objectTransformer objectOfClass: [NSString class] 
			from: from];
    }
	else
	{
		jsonObject = [objectTransformer jsonObjectFrom: from];
	}
	
	return jsonObject;
}


@end