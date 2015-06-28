@import QuartzCore;

#import "FDFeedItem.h"


#pragma mark - Class Interface

@interface FDFeedPhoto : FDFeedItem


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;


@end