@import XCTest;

@import FDObjectTransformer.FDColor_Creation;


@interface FDColorCreationTests : XCTestCase

@end

@implementation FDColorCreationTests


#pragma mark - Tests

- (void)testEquality
{
	FDColor *randomColor = [FDColor colorWithRed: 0.8f 
		green: 0.6f 
		blue: 0.2f 
		alpha: 0.4f];
	FDColor *randomColorFromHexStringWithAlpha = [FDColor fd_colorFromHexString: @"#CC993366"];
	FDColor *randomColorFromShortHexStringWithAlpha = [FDColor fd_colorFromHexString: @"C936"];
	FDColor *randomColorFromHexStringWithoutAlpha = [FDColor fd_colorFromHexString: @"0xC93" 
		alpha: 0.4f];
	FDColor *randomColorFromShortHexStringWithoutAlpha = [FDColor fd_colorFromHexString: @"0XCC9933" 
		alpha: 0.4f];
	FDColor *randomColorFromRGBNumber = [FDColor fd_colorFromRGBNumber: @(13408563) 
		alpha: 0.4f];
	FDColor *randomColorFromRGBANumber = [FDColor fd_colorFromRGBANumber: @(3432592230)];
	
	XCTAssertTrue([self _isColor: randomColor equalTo: randomColorFromHexStringWithAlpha]);
	XCTAssertTrue([self _isColor: randomColor equalTo: randomColorFromShortHexStringWithAlpha]);
	XCTAssertTrue([self _isColor: randomColor equalTo: randomColorFromHexStringWithoutAlpha]);
	XCTAssertTrue([self _isColor: randomColor equalTo: randomColorFromShortHexStringWithoutAlpha]);
	XCTAssertTrue([self _isColor: randomColor equalTo: randomColorFromRGBNumber]);
	XCTAssertTrue([self _isColor: randomColor equalTo: randomColorFromRGBANumber]);
}


#pragma mark - Private Methods

- (BOOL)_isColor: (FDColor *)color1 
	equalTo: (FDColor *)color2
{
	unsigned int color1RGBAValue = [self _rgbaValueForColor: color1];
	unsigned int color2RGBAValue = [self _rgbaValueForColor: color2];
	
	BOOL colorsAreEqual = (color1RGBAValue == color2RGBAValue);
	
	return colorsAreEqual;
}

- (unsigned int)_rgbaValueForColor: (FDColor *)color
{
	CGFloat redComponent = 0.0f;
	CGFloat greenComponent = 0.0f;
	CGFloat blueComponent = 0.0f;
	CGFloat alphaComponent = 0.0f;
	
	[color getRed: &redComponent 
		green: &greenComponent 
		blue: &blueComponent 
		alpha: &alphaComponent];
	
	unsigned int redValue = redComponent * 255;
	unsigned int greenValue = greenComponent * 255;
	unsigned int blueValue = blueComponent * 255;
	unsigned int alphaValue = alphaComponent * 255;
	
	unsigned int rgbaValue = (redValue << 24) + (greenValue << 16) + (blueValue << 8) + alphaValue;
	
	return rgbaValue;
}

@end
