@import Foundation;

#import "FDObjectTransformerAdapter.h"
#import "FDEnumTransformer.h"


#pragma mark - Enumerations

typedef NS_ENUM(NSUInteger, FDDictionaryObjectTransformerAdapterPropertyNamingPolicy)
{
	// No changes will be made to the name of the property. It will be used verbatim.
	FDDictionaryObjectTransformerAdapterPropertyNamingPolicyIdentity,
	
	// The property name will be converted to to all lowercase and each word will be separated with underscores.
	FDDictionaryObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores,
};


#pragma mark - Type Definitions

typedef id (^FDDictionaryObjectTransformerAdapterInstanceBLock)(id object, Class targetClass);


#pragma mark - Class Interface

@interface FDDictionaryObjectTransformerAdapter : NSObject
<
	FDObjectTransformerAdapter
>


#pragma mark - Properties

@property (nonatomic, assign) FDDictionaryObjectTransformerAdapterPropertyNamingPolicy propertyNamingPolicy;
@property (nonatomic, copy) FDDictionaryObjectTransformerAdapterInstanceBLock instanceBlock;


#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (void)registerRemoteKeyPath: (NSString *)remoteKeyPath 
	forLocalKey: (NSString *)localKey;
- (NSString *)remoteKeyPathForLocalKey: (NSString *)localKey;

- (void)registerCollectionType: (Class)collectionType 
	forPropertyName: (NSString *)propertyName;

- (void)registerEnumDictionary: (NSDictionary *)dictionary 
	forLocalKey: (NSString *)localKey;
- (FDEnumTransformer *)enumTransformerForLocalKey: (NSString *)localKey;

- (void)registerValueTransformer: (NSValueTransformer *)valueTransformer 
	forPropertyName: (NSString *)propertyName;


@end