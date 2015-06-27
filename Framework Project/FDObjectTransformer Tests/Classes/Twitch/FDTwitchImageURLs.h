@import Foundation;
@import QuartzCore;


#pragma mark - Class Interface

@interface FDTwitchImageURLs : NSObject


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSURL *small;
@property (nonatomic, copy, readonly) NSURL *medium;
@property (nonatomic, copy, readonly) NSURL *large;


#pragma mark - Instance Methods

- (NSURL *)templateImageURLForWidth: (CGFloat)width 
	height: (CGFloat)height;


@end
