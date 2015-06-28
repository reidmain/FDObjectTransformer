@import Foundation;

#import "FDFeedAd.h"
#import "FDFeedLink.h"
#import "FDFeedPhoto.h"
#import "FDFeedStatus.h"


#pragma mark - Class Interface

@interface FDFeedPage : NSObject


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSArray *items;
@property (nonatomic, assign, readonly) NSUInteger page;
@property (nonatomic, copy, readonly) NSString *nextIdentifier;


@end