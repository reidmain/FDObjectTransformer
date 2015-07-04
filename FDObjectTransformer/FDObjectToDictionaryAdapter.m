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
		FDObjectDescriptor *descriptor = [objectTransformer descriptorForClass: targetClass];
		
		NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
		
		NSArray *declaredProperties = [[object class] fd_declaredPropertiesUntilSuperclass: [NSObject class]];
		[declaredProperties enumerateObjectsUsingBlock: ^(FDDeclaredProperty *declaredProperty, NSUInteger index, BOOL *stop)
			{
				id propertyValue = [object valueForKey: declaredProperty.name];
				
				if ([propertyValue isKindOfClass: [NSNumber class]] == YES)
				{
					// TODO: Don't use the enum transformers instance variable. Instead check to see if this adapter or any of the adapters for superclasses define any enum transformers and use the first one.
					FDEnumTransformer *enumTransformer = [descriptor enumTransformerForLocalKey: declaredProperty.name];
					if (enumTransformer != nil)
					{
						propertyValue = [enumTransformer stringForEnum: propertyValue];
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