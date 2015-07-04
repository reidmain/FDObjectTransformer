@import Foundation;

#import "FDEnumTransformer.h"


#pragma mark Constants


#pragma mark - Enumerations

typedef NS_ENUM(NSUInteger, FDObjectDescriptorPropertyNamingPolicy)
{
	// No changes will be made to the name of the property. It will be used verbatim.
	FDObjectDescriptorPropertyNamingPolicyIdentity,
	
	// The property name will be converted to to all lowercase and each word will be separated with underscores.
	FDObjectDescriptorPropertyNamingPolicyLowerCaseWithUnderscores,
};


#pragma mark - Type Definitions

typedef Class (^FDDictionaryObjectTransformerAdapterClassClusterBlock)(id from, Class targetClass);
typedef id (^FDDictionaryObjectTransformerAdapterInstanceCreatorBlock)(id from, Class targetClass);
typedef void (^FDDictionaryObjectTransformerAdapterPreTransformBlock)(id object, id from);
typedef void (^FDDictionaryObjectTransformerAdapterPostTransformBlock)(id object, id from);


#pragma mark - Class Interface

@interface FDObjectDescriptor : NSObject


#pragma mark - Properties

@property (nonatomic, assign) FDObjectDescriptorPropertyNamingPolicy propertyNamingPolicy;
@property (nonatomic, copy) FDDictionaryObjectTransformerAdapterClassClusterBlock classClusterBlock;
@property (nonatomic, copy) FDDictionaryObjectTransformerAdapterInstanceCreatorBlock instanceCreatorBlock;
@property (nonatomic, copy) FDDictionaryObjectTransformerAdapterPreTransformBlock preTransformBlock;
@property (nonatomic, copy) FDDictionaryObjectTransformerAdapterPostTransformBlock postTransformBlock;


#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (void)registerRemoteKeyPath: (NSString *)remoteKeyPath 
	forLocalKey: (NSString *)localKey;
- (BOOL)isRemoteKeyPathOverriddenForLocalKey: (NSString *)localKey;
- (NSString *)remoteKeyPathForLocalKey: (NSString *)localKey;

- (void)registerCollectionType: (Class)collectionType 
	forPropertyName: (NSString *)propertyName;
- (Class)collectionTypeForPropertyName: (NSString *)propertyName;

- (void)registerEnumDictionary: (NSDictionary *)dictionary 
	forLocalKey: (NSString *)localKey;
- (FDEnumTransformer *)enumTransformerForLocalKey: (NSString *)localKey;

- (void)registerValueTransformer: (NSValueTransformer *)valueTransformer 
	forPropertyName: (NSString *)propertyName;
- (NSValueTransformer *)valueTransformerForPropertyName: (NSString *)propertyName;


@end