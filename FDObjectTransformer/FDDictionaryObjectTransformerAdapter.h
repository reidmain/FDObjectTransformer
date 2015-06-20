@import Foundation;

#import "FDObjectTransformerAdapter.h"


#pragma mark Constants


#pragma mark - Enumerations

typedef NS_ENUM(NSUInteger, FDDictionaryObjectTransformerAdapterPropertyNamingPolicy)
{
	// No changes will be made to the name of the property. It will be used verbatim.
	FDDictionaryObjectTransformerAdapterPropertyNamingPolicyIdentity,
	
	// The property name will be converted to to all lowercase and each word will be separated with underscores.
	FDDictionaryObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores,
};

#pragma mark - Class Interface

@interface FDDictionaryObjectTransformerAdapter : NSObject
<
	FDObjectTransformerAdapter
>


#pragma mark - Properties

@property (nonatomic, assign) FDDictionaryObjectTransformerAdapterPropertyNamingPolicy propertyNamingPolicy;


#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (void)registerRemoteKey: (NSString *)remoteKey 
	forLocalKey: (NSString *)localKey;
- (NSString *)remoteKeyForLocalKey: (NSString *)localKey;

- (void)registerCollectionType: (Class)collectionType 
	forPropertyName: (NSString *)propertyName;

- (void)registerValueTransformer: (NSValueTransformer *)valueTransformer 
	forPropertyName: (NSString *)propertyName;


@end