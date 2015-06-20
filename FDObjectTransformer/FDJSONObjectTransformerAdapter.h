#import "FDDictionaryObjectTransformerAdapter.h"


#pragma mark Constants


#pragma mark - Enumerations



#pragma mark - Class Interface

@interface FDJSONObjectTransformerAdapter : FDDictionaryObjectTransformerAdapter


#pragma mark - Properties

@property (nonatomic, readonly) Class modelClass;


#pragma mark - Constructors

+ (instancetype)adapterForClass: (Class)modelClass;

- (instancetype)initWithClass: (Class)modelClass;


#pragma mark - Static Methods


#pragma mark - Instance Methods


@end