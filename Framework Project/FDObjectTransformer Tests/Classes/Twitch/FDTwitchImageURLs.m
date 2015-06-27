#import "FDTwitchImageURLs.h"


#pragma mark - Class Extension

@interface FDTwitchImageURLs ()

@property (nonatomic, copy, readonly) NSString *template;

@end


#pragma mark - Class Definition

@implementation FDTwitchImageURLs


#pragma mark - Public Methods

- (NSURL *)templateImageURLForWidth: (CGFloat)width 
	height: (CGFloat)height
{
	NSString *widthAsString = [NSString stringWithFormat: @"%.0f", width];
	NSString *heightAsString = [NSString stringWithFormat: @"%.0f", height];
	
	NSString *templateURLAsString = [self.template stringByReplacingOccurrencesOfString: @"{width}" 
		withString: widthAsString];
	templateURLAsString = [templateURLAsString stringByReplacingOccurrencesOfString: @"{height}" 
		withString: heightAsString];
	
	NSURL *templateURL = [NSURL URLWithString: templateURLAsString];
	
	return templateURL;
}

@end
