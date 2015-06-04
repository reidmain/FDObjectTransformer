@import XCTest;

@import FDObjectTransformer;

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
	// Test the transformation from NSString to NSString.
	NSString *name = @"Reid";
	NSString *transformedName = [_transformer objectOfClass: [NSString class] 
		from: name];
	XCTAssertEqualObjects(name, transformedName);
	
	// Test the transformation from NSNumber to NSString.
	NSNumber *number = [NSNumber numberWithBool: YES];
	NSString *transformedNumber = [_transformer objectOfClass: [NSString class] 
		from: number];
	XCTAssertEqualObjects([number stringValue], transformedNumber);
	
	// Test the transformation from NSDate to NSString.
	NSString *dateString = @"01/15/2013";
	NSDate *date = [_transformer.dateFormatter dateFromString: dateString];
	NSString *transformedDate = [_transformer objectOfClass: [NSString class] 
		from: date];
	XCTAssertEqualObjects(dateString, transformedDate);
	
	// Test the transformation from NSURL to NSString.
	NSURL *baseURL = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *url = [NSURL URLWithString: @"about" 
		relativeToURL: baseURL];
	NSString *transformedURL = [_transformer objectOfClass: [NSString class] 
		from: url];
	XCTAssertEqualObjects([url absoluteString], transformedURL);
}

- (void)testTransformationToNSNumber
{
	// Test the transformation from NSNumber to NSNumber.
	NSNumber *number = @(21);
	NSNumber *transformedNumber = [_transformer objectOfClass: [NSNumber class] 
		from: number];
	XCTAssertEqualObjects(number, transformedNumber);
	
	// Test the transformation from NSString to NSSNumber.
	NSString *string = @"21";
	NSNumber *transformedString = [_transformer objectOfClass: [NSNumber class] 
		from: number];
	XCTAssertEqualObjects(@([string longLongValue]), transformedString);
	
	// Test the transformation from NSURL to NSNumber.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSString *transformedURL = [_transformer objectOfClass: [NSNumber class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}

- (void)testTransformationToNSURL
{
	// Test the transformation from NSURL to NSURL.
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *transformedURL = [_transformer objectOfClass: [NSURL class] 
		from: url];
	XCTAssertEqualObjects(url, transformedURL);
	
	// Test the transformation from NSString to NSURL.
	NSString *urlString = @"http://www.reidmain.com";
	NSURL *transformedURLString = [_transformer objectOfClass: [NSURL class] 
		from: urlString];
	XCTAssertEqualObjects([NSURL URLWithString: urlString], transformedURLString);
	
	// Test the transformation from NSNumber to NSURL.
	NSNumber *number = @(21);
	NSURL *transformedNumber = [_transformer objectOfClass: [NSURL class] 
		from: number];
	XCTAssertNotEqualObjects(number, transformedNumber);
	XCTAssertNil(transformedNumber);
}

- (void)testPerformanceExample
{
    [self measureBlock: ^
		{
		}];
}

@end
