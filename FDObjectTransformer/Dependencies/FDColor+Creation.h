#import "TargetConditionals.h"
#if TARGET_OS_IPHONE
@import UIKit.UIColor;

#define FDColor UIColor
#else
@import AppKit.NSColor;

#define FDColor NSColor
#endif


#pragma mark Class Interface

@interface FDColor (Creation)


#pragma mark - Static Methods

+ (FDColor *)fd_colorFromRGBANumber: (NSNumber *)rgbaNumber;

+ (FDColor *)fd_colorFromRGBNumber: (NSNumber *)rgbNumber 
	alpha: (CGFloat)alpha;

+ (FDColor *)fd_colorFromHexString: (NSString *)hexString;

+ (FDColor *)fd_colorFromHexString: (NSString *)hexString 
	alpha: (CGFloat)alpha;


@end