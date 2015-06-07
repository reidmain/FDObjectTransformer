@import XCTest;

@import FDObjectTransformer;

#define FDAssertIsKindOfClass(object, objectClass, ...) \
	XCTAssertTrue([object isKindOfClass: objectClass], __VA_ARGS__)

@interface FDObjectTransformerTests : XCTestCase

@end

@implementation FDObjectTransformerTests
{
	@private __strong FDObjectTransformer *_transformer;
}

- (void)setUp
{
    [super setUp];
	
	_transformer = [FDObjectTransformer new];
	_transformer.dateFormatter = [NSDateFormatter new];
	_transformer.dateFormatter.dateFormat = @"MM/dd/yyyy";
}

- (void)testBaseCases
{
	id nilObjectClass = [_transformer objectOfClass: nil 
		from: @"Reid"];
	XCTAssertNil(nilObjectClass);
	
	id nilObject = [_transformer objectOfClass: [NSString class] 
		from: nil];
	XCTAssertNil(nilObject);
}

- (void)testTransformationToNSString
{
	// Test transformation from NSString to NSString.
	NSString *name = @"Reid";
	NSString *transformedName = [_transformer objectOfClass: [NSString class] 
		from: name];
	XCTAssertEqualObjects(name, transformedName);
	
	// Test transformation from NSNumber to NSString.
	NSNumber *number = [NSNumber numberWithBool: YES];
	NSString *transformedNumber = [_transformer objectOfClass: [NSString class] 
		from: number];
	XCTAssertEqualObjects([number stringValue], transformedNumber);
	
	// Test transformation from NSDate to NSString.
	NSString *dateString = @"01/15/2013";
	NSDate *date = [_transformer.dateFormatter dateFromString: dateString];
	NSString *transformedDate = [_transformer objectOfClass: [NSString class] 
		from: date];
	XCTAssertEqualObjects(dateString, transformedDate);
	
	// Test transformation from NSURL to NSString.
	NSURL *baseURL = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *url = [NSURL URLWithString: @"about" 
		relativeToURL: baseURL];
	NSString *transformedURL = [_transformer objectOfClass: [NSString class] 
		from: url];
	XCTAssertEqualObjects([url absoluteString], transformedURL);
}

- (void)testTransformationToNSNumber
{
	// Test transformation from NSNumber to NSNumber.
	NSNumber *number = @(21);
	NSNumber *transformedNumber = [_transformer objectOfClass: [NSNumber class] 
		from: number];
	XCTAssertEqualObjects(number, transformedNumber);
	
	// Test transformation from NSString to NSSNumber.
	NSString *string = @"21";
	NSNumber *transformedString = [_transformer objectOfClass: [NSNumber class] 
		from: number];
	XCTAssertEqualObjects(@([string longLongValue]), transformedString);
	
	// Test transformation from NSURL to NSNumber.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSString *transformedURL = [_transformer objectOfClass: [NSNumber class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}

- (void)testTransformationToNSDate
{
	// Test transformation from NSDate to NSDate.
	NSDate *date = [NSDate date];
	NSDate *transformedDate = [_transformer objectOfClass: [NSDate class] 
		from: date];
	XCTAssertEqualObjects(date, transformedDate);
	
	// Test transformation from NSString to NSDate.
	NSString *dateString = @"01/15/2013";
	NSDate *dateFromString = [_transformer.dateFormatter dateFromString: dateString];
	NSDate *transformedDateString = [_transformer objectOfClass: [NSDate class] 
		from: dateString];
	XCTAssertEqualObjects(dateFromString, transformedDateString);
	
	// Test transformation from NSNumber to NSDate.
	NSNumber *number = @(21);
	NSDate *transformedNumber = [_transformer objectOfClass: [NSDate class] 
		from: number];
	XCTAssertNotEqualObjects(number, transformedNumber);
	XCTAssertNil(transformedNumber);
	
	// Test transformation from NSURL to NSDate.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *transformedURL = [_transformer objectOfClass: [NSDate class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}

- (void)testTransformationToNSURL
{
	// Test transformation from NSURL to NSURL.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *transformedURL = [_transformer objectOfClass: [NSURL class] 
		from: url];
	XCTAssertEqualObjects(url, transformedURL);
	
	// Test transformation from NSString to NSURL.
	NSString *urlString = @"http://www.reidmain.com";
	NSURL *transformedURLString = [_transformer objectOfClass: [NSURL class] 
		from: urlString];
	XCTAssertEqualObjects([NSURL URLWithString: urlString], transformedURLString);
	
	// Test transformation from NSNumber to NSURL.
	NSNumber *number = @(21);
	NSURL *transformedNumber = [_transformer objectOfClass: [NSURL class] 
		from: number];
	XCTAssertNotEqualObjects(number, transformedNumber);
	XCTAssertNil(transformedNumber);
}

- (void)testTransformationsToFDColor
{
	// Test transformation from FDColor to FDColor.
	FDColor *color = [FDColor redColor];
	FDColor *transformedColor = [_transformer objectOfClass: [FDColor class] 
		from: color];
	XCTAssertEqualObjects(color, transformedColor);
	
	// Test transformation from NSNumber to FDColor.
	NSNumber *number = @(342);
	FDColor *numberAsColor = [FDColor fd_colorFromRGBANumber: number];
	FDColor *transformedNumber = [_transformer objectOfClass: [FDColor class] 
		from: number];
	XCTAssertEqualObjects(numberAsColor, transformedNumber);
	
	// Test transformation from NSString to FDColor.
	NSString *string = @"#342";
	FDColor *stringAsColor = [FDColor fd_colorFromHexString: string];
	FDColor *transformedString = [_transformer objectOfClass: [FDColor class] 
		from: string];
	XCTAssertEqualObjects(stringAsColor, transformedString);
	
	// Test transformation from NSURL to FDColor.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	FDColor *transformedURL = [_transformer objectOfClass: [FDColor class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}

- (void)testTransformationsFromNSArray
{
	NSArray *arrayOfStrings = @[ @"1", @"2", @"3", @"4", @"5" ];
	NSArray *arrayOfNumbers = @[ @(1), @(2), @(3), @(4), @(5) ];
	
	// Test transforming an array of strings.
	NSArray *transformedStringsToStrings = [_transformer objectOfClass: [NSString class] 
		from: arrayOfStrings];
	XCTAssertEqualObjects(arrayOfStrings, transformedStringsToStrings);
	
	NSArray *transformedStringsToNumbers = [_transformer objectOfClass: [NSNumber class] 
		from: arrayOfStrings];
	XCTAssertEqualObjects(arrayOfNumbers, transformedStringsToNumbers);
	
	// Test transforming an array of numbers.
	NSArray *transformedNumbersToNumbers = [_transformer objectOfClass: [NSNumber class] 
		from: arrayOfNumbers];
	XCTAssertEqualObjects(arrayOfNumbers, transformedNumbersToNumbers);
	
	NSArray *transformedNumbersToStrings = [_transformer objectOfClass: [NSString class] 
		from: arrayOfNumbers];
	XCTAssertEqualObjects(arrayOfStrings, transformedNumbersToStrings);
}

- (void)testPerformance
{
    [self measureBlock: ^
		{
		}];
}

@end
