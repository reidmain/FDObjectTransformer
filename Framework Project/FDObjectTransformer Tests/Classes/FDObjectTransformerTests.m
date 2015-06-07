@import XCTest;

@import FDObjectTransformer;

#import "FDRandomModel.h"
#import "FDKeypath.h"

#define FDAssertIsKindOfClass(object, objectClass, ...) \
	XCTAssertTrue([object isKindOfClass: objectClass], __VA_ARGS__)

@interface FDObjectTransformerTests : XCTestCase

@end

@implementation FDObjectTransformerTests
{
}

- (void)setUp
{
    [super setUp];
}

- (void)testBaseCases
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	id nilObjectClass = [transformer objectOfClass: nil 
		from: @"Reid"];
	XCTAssertNil(nilObjectClass);
	
	id nilObject = [transformer objectOfClass: [NSString class] 
		from: nil];
	XCTAssertNil(nilObject);
}

- (void)testTransformationToNSString
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	transformer.dateFormatter = [NSDateFormatter new];
	transformer.dateFormatter.dateFormat = @"MM/dd/yyyy";
	
	// Test transformation from NSString to NSString.
	NSString *name = @"Reid";
	NSString *transformedName = [transformer objectOfClass: [NSString class] 
		from: name];
	XCTAssertEqualObjects(name, transformedName);
	
	// Test transformation from NSNumber to NSString.
	NSNumber *number = [NSNumber numberWithBool: YES];
	NSString *transformedNumber = [transformer objectOfClass: [NSString class] 
		from: number];
	XCTAssertEqualObjects([number stringValue], transformedNumber);
	
	// Test transformation from NSDate to NSString.
	NSString *dateString = @"01/15/2013";
	NSDate *date = [transformer.dateFormatter dateFromString: dateString];
	NSString *transformedDate = [transformer objectOfClass: [NSString class] 
		from: date];
	XCTAssertEqualObjects(dateString, transformedDate);
	
	// Test transformation from NSURL to NSString.
	NSURL *baseURL = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *url = [NSURL URLWithString: @"about" 
		relativeToURL: baseURL];
	NSString *transformedURL = [transformer objectOfClass: [NSString class] 
		from: url];
	XCTAssertEqualObjects([url absoluteString], transformedURL);
}

- (void)testTransformationToNSNumber
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	// Test transformation from NSNumber to NSNumber.
	NSNumber *number = @(21);
	NSNumber *transformedNumber = [transformer objectOfClass: [NSNumber class] 
		from: number];
	XCTAssertEqualObjects(number, transformedNumber);
	
	// Test transformation from NSString to NSSNumber.
	NSString *string = @"21";
	NSNumber *transformedString = [transformer objectOfClass: [NSNumber class] 
		from: number];
	XCTAssertEqualObjects(@([string longLongValue]), transformedString);
	
	// Test transformation from NSURL to NSNumber.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSString *transformedURL = [transformer objectOfClass: [NSNumber class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}

- (void)testTransformationToNSDate
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	transformer.dateFormatter = [NSDateFormatter new];
	transformer.dateFormatter.dateFormat = @"MM/dd/yyyy";
	
	// Test transformation from NSDate to NSDate.
	NSDate *date = [NSDate date];
	NSDate *transformedDate = [transformer objectOfClass: [NSDate class] 
		from: date];
	XCTAssertEqualObjects(date, transformedDate);
	
	// Test transformation from NSString to NSDate.
	NSString *dateString = @"01/15/2013";
	NSDate *dateFromString = [transformer.dateFormatter dateFromString: dateString];
	NSDate *transformedDateString = [transformer objectOfClass: [NSDate class] 
		from: dateString];
	XCTAssertEqualObjects(dateFromString, transformedDateString);
	
	// Test transformation from NSNumber to NSDate.
	NSNumber *number = @(21);
	NSDate *transformedNumber = [transformer objectOfClass: [NSDate class] 
		from: number];
	XCTAssertNotEqualObjects(number, transformedNumber);
	XCTAssertNil(transformedNumber);
	
	// Test transformation from NSURL to NSDate.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *transformedURL = [transformer objectOfClass: [NSDate class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}

- (void)testTransformationToNSURL
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	// Test transformation from NSURL to NSURL.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *transformedURL = [transformer objectOfClass: [NSURL class] 
		from: url];
	XCTAssertEqualObjects(url, transformedURL);
	
	// Test transformation from NSString to NSURL.
	NSString *urlString = @"http://www.reidmain.com";
	NSURL *transformedURLString = [transformer objectOfClass: [NSURL class] 
		from: urlString];
	XCTAssertEqualObjects([NSURL URLWithString: urlString], transformedURLString);
	
	// Test transformation from NSNumber to NSURL.
	NSNumber *number = @(21);
	NSURL *transformedNumber = [transformer objectOfClass: [NSURL class] 
		from: number];
	XCTAssertNotEqualObjects(number, transformedNumber);
	XCTAssertNil(transformedNumber);
}

- (void)testTransformationToFDColor
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	// Test transformation from FDColor to FDColor.
	FDColor *color = [FDColor redColor];
	FDColor *transformedColor = [transformer objectOfClass: [FDColor class] 
		from: color];
	XCTAssertEqualObjects(color, transformedColor);
	
	// Test transformation from NSNumber to FDColor.
	NSNumber *number = @(342);
	FDColor *numberAsColor = [FDColor fd_colorFromRGBANumber: number];
	FDColor *transformedNumber = [transformer objectOfClass: [FDColor class] 
		from: number];
	XCTAssertEqualObjects(numberAsColor, transformedNumber);
	
	// Test transformation from NSString to FDColor.
	NSString *string = @"#342";
	FDColor *stringAsColor = [FDColor fd_colorFromHexString: string];
	FDColor *transformedString = [transformer objectOfClass: [FDColor class] 
		from: string];
	XCTAssertEqualObjects(stringAsColor, transformedString);
	
	// Test transformation from NSURL to FDColor.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	FDColor *transformedURL = [transformer objectOfClass: [FDColor class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}

- (void)testTransformationToNSDictionary
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	// Test transformation from NSDictionary to NSDictionary.
	NSDictionary *dictionary = @{ @"key" : @"value" };
	NSDictionary *transformedDictionary = [transformer objectOfClass: [NSDictionary class] 
		from: dictionary];
	XCTAssertEqualObjects(dictionary, transformedDictionary);
	
	// Test transformation from FDRandomModel to NSDictionary.
	FDRandomModel *randomModel = ({
		FDRandomModel *randomModel = [FDRandomModel new];
		randomModel.string = @"Monster Hunter";
		randomModel.number = @(21);
		randomModel.integer = -666;
		randomModel.date = [NSDate date];
		randomModel.url = [NSURL URLWithString: @"http://www.reidmain.com"];
		randomModel.dictionary = dictionary;
		randomModel.array = @[ @(1), @(2), @(3) ];
		
		randomModel;
	});
	NSDictionary *transformedRandomModel = [transformer objectOfClass: [NSDictionary class] 
		from: randomModel];
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, string)], randomModel.string);
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, number)], randomModel.number);
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, integer)], @(randomModel.integer));
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, date)], randomModel.date);
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, url)], randomModel.url);
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, dictionary)], randomModel.dictionary);
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, array)], randomModel.array);
}

- (void)testTransformationFromNSArray
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	NSArray *arrayOfStrings = @[ @"1", @"2", @"3", @"4", @"5" ];
	NSArray *arrayOfNumbers = @[ @(1), @(2), @(3), @(4), @(5) ];
	
	// Test transforming an array of strings.
	NSArray *transformedStringsToStrings = [transformer objectOfClass: [NSString class] 
		from: arrayOfStrings];
	XCTAssertEqualObjects(arrayOfStrings, transformedStringsToStrings);
	
	NSArray *transformedStringsToNumbers = [transformer objectOfClass: [NSNumber class] 
		from: arrayOfStrings];
	XCTAssertEqualObjects(arrayOfNumbers, transformedStringsToNumbers);
	
	// Test transforming an array of numbers.
	NSArray *transformedNumbersToNumbers = [transformer objectOfClass: [NSNumber class] 
		from: arrayOfNumbers];
	XCTAssertEqualObjects(arrayOfNumbers, transformedNumbersToNumbers);
	
	NSArray *transformedNumbersToStrings = [transformer objectOfClass: [NSString class] 
		from: arrayOfNumbers];
	XCTAssertEqualObjects(arrayOfStrings, transformedNumbersToStrings);
}

- (void)testTransformationFromJSONToModel
{
	NSBundle *bundle = [NSBundle bundleForClass: [self class]];
	 [bundle pathForResource: @"" 
		ofType: @"json"];
}

- (void)testPerformance
{
    [self measureBlock: ^
		{
		}];
}

@end