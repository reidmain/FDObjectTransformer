@import Foundation;


#pragma mark - Class Interface

@interface FDRandomModel : NSObject


#pragma mark - Properties

@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSNumber *number;
@property (nonatomic, assign) NSInteger integer;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSDictionary *dictionary;
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, readonly) NSDate *createdAt;
@property (nonatomic, readonly) NSString *className;


@end