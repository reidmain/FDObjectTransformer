#import "FDDictionaryToObjectAdapter.h"

#import "FDObjectTransformer.h"
#import "NSObject+DeclaredProperty.h"


#pragma mark - Class Definition

@implementation FDDictionaryToObjectAdapter


#pragma mark - FDObjectTransformerAdapter Methods

- (id)transformObject:(id)object intoClass:(Class)targetClass fromObjectTransformer: (FDObjectTransformer *)objectTransformer
{
	id transformedObject = nil;
	
	if ([object isKindOfClass: [NSDictionary class]] == YES)
	{
		FDObjectDescriptor *descriptor = [objectTransformer descriptorForClass: [object class]];
		
		if (descriptor.instanceBlock != nil)
		{
			transformedObject = descriptor.instanceBlock(object, targetClass);
		}
		else
		{
			transformedObject = [targetClass new];
		}
		
		// TODO: Verify that the transformed object is not nil.
		
		// TODO: Get the FDDictionaryObjectTransformerAdapter for the transformed object's class because it could be different then the current adapter you are in.
		
		NSArray *declaredProperties = [[transformedObject class] fd_declaredPropertiesUntilSuperclass: [NSObject class]];
		[declaredProperties enumerateObjectsUsingBlock: ^(FDDeclaredProperty *declaredProperty, NSUInteger index, BOOL *stop)
			{
				// If the property being set is a read-only property with no backing instance variable setValue:forKey: will always throw an exception so ignore the property. This is indicative of a computed property so it does not need to be set anyway.
				if (declaredProperty.isReadOnly == YES 
					&& declaredProperty.backingInstanceVariableName == nil)
				{
					return;
				}
				
				NSString *remoteKeyPath = [descriptor remoteKeyPathForLocalKey: declaredProperty.name];
				// TODO: Figure out if this is the right remote key path or not. In theory a adapter for one of the superclasses of this could be returning something custom.
				
				id dictionaryObject = [object valueForKeyPath: remoteKeyPath];
				
				// If the declared property's name does not exist in the dictionary ignore it and move onto the next property. There is no point in dealing with a property that does not exist because it could only delete data that currently exists.
				if (dictionaryObject == nil)
				{
					return;
				}
				
				id transformedDictionaryObject = nil;
				
				// If the dictionary object is not NSNull attempt to transform it otherwise do nothing and allow the property being set to be cleared.
				if (dictionaryObject != [NSNull null])
				{
					transformedDictionaryObject = dictionaryObject;
					
					// TODO: Don't use the value transformer instance variable. Instead check to see if this adapter or any of the adapters for superclasses define any value transformers and use the first one.
					NSValueTransformer *valueTransformer = [descriptor valueTransformerForPropertyName: declaredProperty.name];
					if (valueTransformer != nil)
					{
						transformedDictionaryObject = [valueTransformer transformedValue: dictionaryObject];
					}
					else if ([dictionaryObject isKindOfClass: [NSArray class]] == YES 
						&& declaredProperty.objectClass == [NSArray class])
					{
						// TODO: Don't use the collection types instance variable. Instead check to see if this adapter or any of the adapters for superclasses define any collection types and use the first one.
						Class collectionType = [descriptor collectionTypeForPropertyName: declaredProperty.name];
						if (collectionType != nil)
						{
							transformedDictionaryObject = [objectTransformer objectOfClass: collectionType 
								from: dictionaryObject];
						}
					}
					else if ([dictionaryObject isKindOfClass: [NSString class]] == YES 
						&& declaredProperty.typeEncoding != FDDeclaredPropertyTypeEncodingObject)
					{
						// TODO: Don't use the enum transformers instance variable. Instead check to see if this adapter or any of the adapters for superclasses define any enum transformers and use the first one.
						FDEnumTransformer *enumTransformer = [descriptor enumTransformerForLocalKey: declaredProperty.name];
						if (enumTransformer != nil)
						{
							transformedDictionaryObject = [enumTransformer enumForString: dictionaryObject];
						}
					}
					// If the declared property is not a scalar type attempt to transform the dictionary object into an instance of the property type.
					else if (declaredProperty.objectClass != nil)
					{
						transformedDictionaryObject = [objectTransformer objectOfClass: declaredProperty.objectClass 
							from: dictionaryObject];
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
					
				@try
				{
					[transformedObject setValue: transformedDictionaryObject 
						forKeyPath: declaredProperty.name];
				}
				// If the key path on the local model does not exist an exception will most likely be thrown. Catch this exeception and log it so that any incorrect mappings will not crash the application.
				@catch (NSException *exception)
				{
//					FDLog(FDLogLevelInfo, @"Could not set %@ property on %@ because %@", localKeyPath, [model class], [exception reason]);
				}
			}];
	}
	
	return transformedObject;
}


@end