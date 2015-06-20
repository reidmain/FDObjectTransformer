@import Foundation;
#import "FDTwitchStream.h"


#pragma mark - Class Interface

@interface FDTwitchStreamSearchResults : NSObject


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSArray *streams;
@property (nonatomic, assign, readonly) NSUInteger total;
@property (nonatomic, copy, readonly) NSURL *next; 


@end
