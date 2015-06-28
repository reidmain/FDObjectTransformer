#import "FDFeedItem.h"


#pragma mark - Class Interface

@interface FDFeedAd : FDFeedItem


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSString *unitID;
@property (nonatomic, copy, readonly) NSURL *imageURL;
@property (nonatomic, copy, readonly) NSURL *actionURL;


@end