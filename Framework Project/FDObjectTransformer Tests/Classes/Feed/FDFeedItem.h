@import Foundation;


#pragma mark - Class Interface

@interface FDFeedItem : NSObject


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSString *itemID;
@property (nonatomic, copy, readonly) NSString *creator;
@property (nonatomic, copy, readonly) NSDate *createdAt;


@end