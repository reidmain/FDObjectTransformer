@import Foundation;


#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

@interface FDEnumTransformer : NSObject


#pragma mark - Properties


#pragma mark - Constructors

+ (instancetype)enumTransformerWithDictionary: (NSDictionary *)dictionary;

- (instancetype)initWithDictionary: (NSDictionary *)dictionary;


#pragma mark - Static Methods


#pragma mark - Instance Methods

- (NSNumber *)enumForString: (NSString *)string;

- (NSString *)stringForEnum: (NSNumber *)number;



@end