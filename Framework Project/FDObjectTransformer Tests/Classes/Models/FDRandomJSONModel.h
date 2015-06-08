#import "FDColor+Creation.h"


#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

@interface FDRandomJSONModel : NSObject


#pragma mark - Properties

@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSNumber *number;
@property (nonatomic, readonly) NSString *stringFromNumber;
@property (nonatomic, readonly) NSNumber *numberFromString;
@property (nonatomic, readonly) NSUInteger integerFromString;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) FDColor *colorFromNumber;
@property (nonatomic, readonly) FDColor *colorFromString;
@property (nonatomic, readonly) NSDictionary *dictionary;
@property (nonatomic, readonly) NSArray *array;



#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods


@end