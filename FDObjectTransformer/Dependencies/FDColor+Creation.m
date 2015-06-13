#import "FDColor+Creation.h"


#pragma mark Class Definition

@implementation FDColor (Creation)


#pragma mark - Properties


#pragma mark - Public Methods

+ (FDColor *)fd_colorFromRGBANumber: (NSNumber *)rgbaNumber
{
	// Break the RGBA number into its red, green, blue and alpha components and create a color object from it.
	unsigned int rgbaValue = [rgbaNumber unsignedIntValue];
	CGFloat redComponent = ((rgbaValue >> 24) & 0xFF) / 255.0f;
	CGFloat greenComponent = ((rgbaValue >> 16) & 0xFF) / 255.0f;
	CGFloat blueComponent = (rgbaValue >> 8 & 0xFF) / 255.0f;
	CGFloat alphaComponent = (rgbaValue & 0xFF) / 255.0f;
	
	FDColor *color = [self colorWithRed: redComponent 
		green: greenComponent 
		blue: blueComponent 
		alpha: alphaComponent];
	
	return color;
}

+ (FDColor *)fd_colorFromRGBNumber: (NSNumber *)rgbNumber 
	alpha: (CGFloat)alpha
{
	unsigned int alphaComponent = alpha * 255;
	
	unsigned int rgbaValue = ([rgbNumber unsignedIntValue] << 8) + alphaComponent;
	
	FDColor *color = [self fd_colorFromRGBANumber: @(rgbaValue)];
	
	return color;
}

+ (FDColor *)fd_colorFromHexString: (NSString *)hexString
{
	// If the hex string is empty return nil.
	if ([hexString length] == 0)
	{
		return nil;
	}
	
	NSString *normalizedHexString = hexString;
	
	// If the hex string starts with # move the scan location of the scanner past it.
	if ([hexString hasPrefix: @"#"] == YES)
	{
		normalizedHexString = [hexString substringFromIndex: 1];
	}
	// If the hex string starts with 0x or 0X move the scan location of the scanner past it.
	else if ([hexString hasPrefix: @"0x"] == YES 
		|| [hexString hasPrefix: @"0X"])
	{
		normalizedHexString = [hexString substringFromIndex: 2];
	}
	
	// If the normalized hex string is not 3, 4, 6, or 8 characters long it is invalid.
	NSUInteger normalizedHexStringLength = [normalizedHexString length];
	if (normalizedHexStringLength != 3 
		&& normalizedHexStringLength != 4 
		&& normalizedHexStringLength != 6 
		&& normalizedHexStringLength != 8)
	{
		return nil;
	}
	
	// If the normalized hex string is less than 6 characters it is a short form color string and must be doubled in length.
	if (normalizedHexStringLength < 6)
	{
		NSMutableString *mutableString = [NSMutableString new];
		
		for (NSUInteger i=0; i < [normalizedHexString length]; i++)
		{
			unichar character = [normalizedHexString characterAtIndex: i];
			[mutableString appendFormat: @"%C%C", 
				character, 
				character];
		}
		
		normalizedHexString = mutableString;
	}
	
	// Create a scanner from the normalized hex string.
	NSScanner *scanner = [NSScanner scannerWithString: normalizedHexString];
	
	// Extract the RGBA value from the normalized hex string.
	unsigned int rgbaValue = 0;
	[scanner scanHexInt: &rgbaValue];
	
	// Create a color from the RGBA value.
	FDColor *color = [self fd_colorFromRGBANumber: @(rgbaValue)];
	
	return color;
}

+ (FDColor *)fd_colorFromHexString: (NSString *)hexString 
	alpha: (CGFloat)alpha
{
	// If the hex string is empty return nil.
	if ([hexString length] == 0)
	{
		return nil;
	}
	
	// Convert the alpha value into a hexidecimal string.
	unsigned int alphaComponent = alpha * 255;
	
	NSString *alphaString = [NSString stringWithFormat: @"%02x", 
		alphaComponent];
	
	NSString *normalizedHexString = hexString;
	
	// If the hex string starts with # move the scan location of the scanner past it.
	if ([hexString hasPrefix: @"#"] == YES)
	{
		normalizedHexString = [hexString substringFromIndex: 1];
	}
	// If the hex string starts with 0x or 0X move the scan location of the scanner past it.
	else if ([hexString hasPrefix: @"0x"] == YES 
		|| [hexString hasPrefix: @"0X"])
	{
		normalizedHexString = [hexString substringFromIndex: 2];
	}
	
	// If the normalized hex string is not 3 or 6 characters long it is invalid.
	NSUInteger normalizedHexStringLength = [normalizedHexString length];
	if (normalizedHexStringLength != 3 
		&& normalizedHexStringLength != 6)
	{
		return nil;
	}
	
	// If the normalized hex string is less than 6 characters it is a short form color string and must be doubled in length.
	if (normalizedHexStringLength < 6)
	{
		NSMutableString *mutableString = [NSMutableString new];
		
		for (NSUInteger i=0; i < [normalizedHexString length]; i++)
		{
			unichar character = [normalizedHexString characterAtIndex: i];
			[mutableString appendFormat: @"%C%C", 
				character, 
				character];
		}
		
		normalizedHexString = mutableString;
	}
	
	// Append the alpha channel hex string to the existing hex string.
	normalizedHexString = [NSString stringWithFormat: @"%@%@", 
		normalizedHexString, 
		alphaString];
	
	// Create a color from the normalized hex string.
	FDColor *color = [self fd_colorFromHexString: normalizedHexString];
	
	return color;
}


@end