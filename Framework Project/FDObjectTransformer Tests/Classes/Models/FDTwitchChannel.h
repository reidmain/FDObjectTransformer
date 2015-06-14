@import Foundation;
#import "FDColor+Creation.h"


#pragma mark - Class Interface

@interface FDTwitchChannel : NSObject


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, assign, readonly) BOOL mature;
@property (nonatomic, copy, readonly) UIColor *profileBannerBackgroundColor;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSDate *updatedAt;


@end
