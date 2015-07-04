#import "FDObjectToDictionaryAdapter.h"

#import "FDObjectTransformer.h"
#import "NSObject+DeclaredProperty.h"


#pragma mark - Class Definition

@implementation FDObjectToDictionaryAdapter


#pragma mark - FDObjectTransformerAdapter Methods

- (id)transformObject:(id)object intoClass:(Class)targetClass fromObjectTransformer: (FDObjectTransformer *)objectTransformer
{
	id transformedObject = nil;
	
	if (targetClass == [NSDictionary class])
	{
		NSArray *descriptors = [objectTransformer descriptorsForClass: targetClass];
		
		NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
		
		NSArray *declaredProperties = [[object class] fd_declaredPropertiesUntilSuperclass: [NSObject class]];
		[declaredProperties enumerateObjectsUsingBlock: ^(FDDeclaredProperty *declaredProperty, NSUInteger index, BOOL *stop)
			{
				id propertyValue = [object valueForKey: declaredProperty.name];
				
				if ([propertyValue isKindOfClass: [NSNumber class]] == YES)
				{
					for (FDObjectDescriptor *descriptor in descriptors)
					{
						FDEnumTransformer *enumTransformer = [descriptor enumTransformerForLocalKey: declaredProperty.name];
						if (enumTransformer != nil)
						{
							propertyValue = [enumTransformer stringForEnum: propertyValue];
							
							break;
						}
					}
				}
				
				[mutableDictionary setValue: propertyValue 
					forKey: declaredProperty.name];
			}];
		
		transformedObject = mutableDictionary;
	}
	
	return transformedObject;
}


@end