@import Foundation;
@import QuartzCore;
#import "FDTwitchChannel.h"
#import "FDTwitchImageURLs.h"


#pragma mark - Class Interface

@interface FDTwitchStream : NSObject


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSString *game;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, assign, readonly) NSUInteger viewers;
@property (nonatomic, assign, readonly) CGFloat videoHeight;
@property (nonatomic, assign, readonly) double averageFps;
@property (nonatomic, strong, readonly) FDTwitchChannel *channel;
@property (nonatomic, strong, readonly) FDTwitchImageURLs *preview;


@end
