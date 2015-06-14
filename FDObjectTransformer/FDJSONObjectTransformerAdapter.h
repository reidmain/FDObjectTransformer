@import Foundation;


#pragma mark Constants


#pragma mark - Enumerations

typedef NS_ENUM(NSUInteger, FDJSONObjectTransformerAdapterPropertyNamingPolicy)
{
	// No changes will be made to the name of the property. It will be used verbatim.
	FDJSONObjectTransformerAdapterPropertyNamingPolicyIdentity,
	
	// The property name will be converted to to all lowercase and each word will be separated with underscores.
	FDJSONObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores,
};


#pragma mark - Class Interface

@interface FDJSONObjectTransformerAdapter : NSObject


#pragma mark - Properties

@property (nonatomic, copy) Class modelClass;
@property (nonatomic, assign) FDJSONObjectTransformerAdapterPropertyNamingPolicy propertyNamingPolicy;


#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (void)registerRemoteKey: (NSString *)remoteKey forLocalKey: (NSString *)localKey;
- (NSString *)remoteKeyForLocalKey: (NSString *)localKey;

- (void)registerCollectionType: (Class)collectionType 
	forPropertyName: (NSString *)propertyName;


@end