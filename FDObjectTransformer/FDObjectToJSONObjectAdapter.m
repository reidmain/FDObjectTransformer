#import "FDObjectToJSONObjectAdapter.h"

#import "FDJSONObject.h"
#import "FDObjectTransformer.h"
#import "NSObject+DeclaredProperty.h"


#pragma mark - Class Definition

@implementation FDObjectToJSONObjectAdapter


#pragma mark - FDObjectTransformerAdapter Methods

- (id)transformObject:(id)object intoClass:(Class)targetClass fromObjectTransformer: (FDObjectTransformer *)objectTransformer
{
	id transformedObject = nil;
	
	if ([targetClass isSubclassOfClass: [FDJSONObject class]] == YES)
	{
		Class objectClass = [object class];
		NSArray *descriptors = [objectTransformer descriptorsForClass: objectClass];
		
		transformedObject = [NSMutableDictionary new];
		
		NSArray *declaredProperties = [objectClass fd_declaredPropertiesUntilSuperclass: [NSObject class]];
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
				
				if ([value isKindOfClass: [NSNumber class]] == YES)
				{
					for (FDObjectDescriptor *descriptor in descriptors)
					{
						FDEnumTransformer *enumTransformer = [descriptor enumTransformerForLocalKey: declaredProperty.name];
						if (enumTransformer != nil)
						{
							transformedValue = [enumTransformer stringForEnum: value];
							
							break;
						}
					}
				}
				
				if (transformedValue == nil)
				{
					transformedValue = [self _jsonObjectFrom: value 
						fromObjectTransformer: objectTransformer];
				}
				
				if (transformedValue != nil)
				{
					NSString *remoteKeyPath = nil;
					for (FDObjectDescriptor *descriptor in descriptors)
					{
						remoteKeyPath = [descriptor remoteKeyPathForLocalKey: declaredProperty.name];
						
						if ([descriptor isRemoteKeyPathOverriddenForLocalKey: declaredProperty.name] == YES)
						{
							break;
						}
					}
					
					if (remoteKeyPath == nil)
					{
						remoteKeyPath = [[descriptors firstObject] remoteKeyPathForLocalKey: declaredProperty.name];
					}
					
					NSArray *keys = [remoteKeyPath componentsSeparatedByString: @"."];
					__block NSDictionary *currentDictionary = transformedObject;
					for (NSUInteger i = 0; i < [keys count] - 1; i++)
					{
						NSString *key = keys[i];
						
						NSMutableDictionary *dictionary = [NSMutableDictionary new];
						[currentDictionary setValue:dictionary forKey:key];
						
						currentDictionary = dictionary;
					};
					
					[transformedObject setValue: transformedValue 
						forKeyPath: remoteKeyPath];
				}
			}];
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