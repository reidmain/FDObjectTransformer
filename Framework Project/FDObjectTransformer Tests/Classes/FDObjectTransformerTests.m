@import XCTest;

@import FDObjectTransformer;

#import "FDRandomModel.h"
#import "FDKeypath.h"
#import "FDRandomJSONModel.h"
#import "NSObject+DeclaredProperty.h"
#import "FDColor+Creation.h"
#import "FDURLComponentsTransformerAdapter.h"
#import "FDTwitchStreamSearchResults.h"
#import "FDJSONObjectTransformerAdapter.h"
#import "FDValueTransformer.h"

#define FDAssertIsKindOfClass(object, objectClass, ...) \
	XCTAssertTrue([object isKindOfClass: objectClass], __VA_ARGS__)

@interface FDObjectTransformerTests : XCTestCase

@end

@implementation FDObjectTransformerTests


#pragma mark - Default Transformations

#pragma mark Invalid

- (void)testNils
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	id nilObjectClass = [transformer objectOfClass: nil 
		from: @"Reid"];
	XCTAssertNil(nilObjectClass);
	
	id nilObject = [transformer objectOfClass: [NSString class] 
		from: nil];
	XCTAssertNil(nilObject);
}


#pragma mark NSString

- (void)testNSStringToNSString
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSString *name = @"Reid";
	NSString *transformedName = [transformer objectOfClass: [NSString class] 
		from: name];
	XCTAssertEqualObjects(name, transformedName);
}

- (void)testNSNumberToNSString
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSNumber *number = [NSNumber numberWithBool: YES];
	NSString *transformedNumber = [transformer objectOfClass: [NSString class] 
		from: number];
	XCTAssertEqualObjects([number stringValue], transformedNumber);
}

- (void)testNSURLToNSString
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSURL *baseURL = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *url = [NSURL URLWithString: @"about" 
		relativeToURL: baseURL];
	NSString *transformedURL = [transformer objectOfClass: [NSString class] 
		from: url];
	XCTAssertEqualObjects([url absoluteString], transformedURL);
}

- (void)testNSDateToNSString
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	transformer.dateFormatter = [NSDateFormatter new];
	transformer.dateFormatter.dateFormat = @"MM/dd/yyyy";
	
	NSString *dateString = @"01/15/2013";
	NSDate *date = [transformer.dateFormatter dateFromString: dateString];
	NSString *transformedDate = [transformer objectOfClass: [NSString class] 
		from: date];
	XCTAssertEqualObjects(dateString, transformedDate);
}

- (void)testNSDateToNSStringWithNoDateFormatterSet
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSString *dateString = @"01/15/2013";
	NSDate *date = [transformer.dateFormatter dateFromString: dateString];
	NSString *transformedDate = [transformer objectOfClass: [NSString class] 
		from: date];
	XCTAssertNil(transformedDate);
}

- (void)testNSDictionaryToNSString
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSDictionary *dictionary = @{ @"name" : @"Reid" };
	NSString *transformedDictionary = [transformer objectOfClass: [NSString class] 
		from: dictionary];
	XCTAssertEqualObjects([dictionary description], transformedDictionary);
}


#pragma mark NSNumber

- (void)testNSNumberToNSNumber
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSNumber *number = @(21);
	NSNumber *transformedNumber = [transformer objectOfClass: [NSNumber class] 
		from: number];
	XCTAssertEqualObjects(number, transformedNumber);
}

- (void)testNSStringToNSNumber
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSString *string = @"21";
	NSNumber *transformedString = [transformer objectOfClass: [NSNumber class] 
		from: string];
	XCTAssertEqualObjects(@([string longLongValue]), transformedString);
}

- (void)testNSStringToNSNumberWithInvalidString
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSString *invalidString = @"Reid";
	NSNumber *transformedString = [transformer objectOfClass: [NSNumber class] 
		from: invalidString];
	XCTAssertNil(transformedString);
}

- (void)testNSURLToNSNumber
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSString *transformedURL = [transformer objectOfClass: [NSNumber class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}


#pragma mark NSDate

- (void)testNSDateToNSDate
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSDate *date = [NSDate date];
	NSDate *transformedDate = [transformer objectOfClass: [NSDate class] 
		from: date];
	XCTAssertEqualObjects(date, transformedDate);
}

- (void)testNSStringToNSDate
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	transformer.dateFormatter = [NSDateFormatter new];
	transformer.dateFormatter.dateFormat = @"MM/dd/yyyy";
	
	NSString *dateString = @"01/15/2013";
	NSDate *dateFromString = [transformer.dateFormatter dateFromString: dateString];
	NSDate *transformedDateString = [transformer objectOfClass: [NSDate class] 
		from: dateString];
	XCTAssertNotNil(transformedDateString);
	XCTAssertEqualObjects(dateFromString, transformedDateString);
}

- (void)testNSStringToNSDateWithNoDateFormatterSet
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSString *dateString = @"01/15/2013";
	NSDate *transformedDateString = [transformer objectOfClass: [NSDate class] 
		from: dateString];
	XCTAssertNil(transformedDateString);
}

- (void)testNSNumberToNSDate
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSNumber *number = @(21);
	NSDate *transformedNumber = [transformer objectOfClass: [NSDate class] 
		from: number];
	XCTAssertNotEqualObjects(number, transformedNumber);
	XCTAssertNil(transformedNumber);
}

- (void)testNSURLToNSDate
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *transformedURL = [transformer objectOfClass: [NSDate class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}


#pragma mark NSURL

- (void)testNSURLToNSURL
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	NSURL *transformedURL = [transformer objectOfClass: [NSURL class] 
		from: url];
	XCTAssertEqualObjects(url, transformedURL);
}

- (void)testNSStringToNSURL
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSString *urlString = @"http://www.reidmain.com";
	NSURL *transformedURLString = [transformer objectOfClass: [NSURL class] 
		from: urlString];
	XCTAssertEqualObjects([NSURL URLWithString: urlString], transformedURLString);
}

- (void)testNSNumberToNSURL
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSNumber *number = @(21);
	NSURL *transformedNumber = [transformer objectOfClass: [NSURL class] 
		from: number];
	XCTAssertNotEqualObjects(number, transformedNumber);
	XCTAssertNil(transformedNumber);
}


#pragma mark FDColor

- (void)testFDColorToFDColor
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	FDColor *color = [FDColor redColor];
	FDColor *transformedColor = [transformer objectOfClass: [FDColor class] 
		from: color];
	XCTAssertEqualObjects(color, transformedColor);
}

- (void)testNSNumberToFDColor
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSNumber *number = @(342);
	FDColor *numberAsColor = [FDColor fd_colorFromRGBANumber: number];
	FDColor *transformedNumber = [transformer objectOfClass: [FDColor class] 
		from: number];
	XCTAssertEqualObjects(numberAsColor, transformedNumber);
}

- (void)testNSStringToFDColor
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSString *string = @"#342342";
	FDColor *stringAsColor = [FDColor fd_colorFromHexString: string];
	FDColor *transformedString = [transformer objectOfClass: [FDColor class] 
		from: string];
	XCTAssertEqualObjects(stringAsColor, transformedString);
}

- (void)testNSURLToFDColor
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSURL *url = [NSURL URLWithString: @"http://www.reidmain.com"];
	FDColor *transformedURL = [transformer objectOfClass: [FDColor class] 
		from: url];
	XCTAssertNotEqualObjects(url, transformedURL);
	XCTAssertNil(transformedURL);
}


#pragma mark NSDictionary

- (void)testNSDictionaryToNSDictionary
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSDictionary *dictionary = @{ @"key" : @"value" };
	NSDictionary *transformedDictionary = [transformer objectOfClass: [NSDictionary class] 
		from: dictionary];
	XCTAssertEqualObjects(dictionary, transformedDictionary);
}

- (void)testFDRandomModelToNSDictionary
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	FDRandomModel *randomModel = ({
		FDRandomModel *randomModel = [FDRandomModel new];
		randomModel.string = @"Monster Hunter";
		randomModel.number = @(21);
		randomModel.integer = -666;
		randomModel.date = [NSDate date];
		randomModel.url = [NSURL URLWithString: @"http://www.reidmain.com"];
		randomModel.dictionary = @{ @"key" : @"value" };
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
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, createdAt)], randomModel.createdAt);
	XCTAssertEqualObjects(transformedRandomModel[@keypath(FDRandomModel, className)], randomModel.className);
}

- (void)testProperlyFormattedNSDictionaryToFDRandomModel
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSDictionary *dictionary = @{ 
		@keypath(FDRandomModel, string) : @"string", 
		@keypath(FDRandomModel, number) : @(21), 
		@keypath(FDRandomModel, integer) : @(81), 
		@keypath(FDRandomModel, date) : [NSDate date], 
		@keypath(FDRandomModel, url) : [NSURL URLWithString: @"http://www.reidmain.com"], 
		@keypath(FDRandomModel, dictionary) : @{ @"key" : @"value" }, 
		@keypath(FDRandomModel, array) : @[ @"1", @"2", @"3" ], 
		};
	
	FDRandomModel *randomModel = [transformer objectOfClass: [FDRandomModel class] 
		from: dictionary];
	
	XCTAssertEqualObjects(randomModel.string, dictionary[@keypath(FDRandomModel, string)]);
	XCTAssertEqualObjects(randomModel.number, dictionary[@keypath(FDRandomModel, number)]);
	XCTAssertEqualObjects(@(randomModel.integer), dictionary[@keypath(FDRandomModel, integer)]);
	XCTAssertEqualObjects(randomModel.date, dictionary[@keypath(FDRandomModel, date)]);
	XCTAssertEqualObjects(randomModel.url, dictionary[@keypath(FDRandomModel, url)]);
	XCTAssertEqualObjects(randomModel.dictionary, dictionary[@keypath(FDRandomModel, dictionary)]);
	XCTAssertEqualObjects(randomModel.array, dictionary[@keypath(FDRandomModel, array)]);
}

- (void)testPoorlyFormattedNSDictionaryToFDRandomModel
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSDictionary *dictionary = @{ 
		@keypath(FDRandomModel, string) : [NSObject new], 
		@keypath(FDRandomModel, number) : [NSURL URLWithString: @"http://www.reidmain.com"], 
		@keypath(FDRandomModel, integer) : [NSNull null], 
		@"Date" : [NSDate date], 
		@keypath(FDRandomModel, url) : @(1), 
		@keypath(FDRandomModel, dictionary) : @[ @"1", @"2", @"3" ], 
		@keypath(FDRandomModel, array) : @"string", 
		@keypath(FDRandomModel, createdAt) : [NSNull null], 
		@keypath(FDRandomModel, className) : @"Cooler class name", 
		};
	
	FDRandomModel *randomModel = [transformer objectOfClass: [FDRandomModel class] 
		from: dictionary];
	
	XCTAssertEqualObjects(randomModel.string, [dictionary[@keypath(FDRandomModel, string)] description]);
	XCTAssertNil(randomModel.number, @"\number\" property is a NSURL which cannot be parsed into a NSNumber so it should be nil.");
	XCTAssertEqual(randomModel.integer, 0, @"\"integer\" property is null which cannot be parsed into a NSInteger so it should remain zero.");
	XCTAssertNil(randomModel.date, @"\"date\" is not specified in the dictionary so this should be nil.");
	XCTAssertNil(randomModel.url, @"url specified in the dictionary is not a NSURL object so this should be nil.");
	XCTAssertNil(randomModel.dictionary, @"dictionary specified in the dictionary is not a NSDictionary object so this should be nil.");
	XCTAssertNil(randomModel.array, @"array specified in the dictionary is not a NSArray object so this should be nil.");
	XCTAssertNotEqualObjects(randomModel.className, dictionary[@keypath(FDRandomModel, className)]);
}

- (void)testNSDictionaryOfJSONToFDRandomJSONModel
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	transformer.dateFormatter = [NSDateFormatter new];
	transformer.dateFormatter.dateFormat = @"MM/dd/yyyy";
	
	NSDictionary *jsonObject = [self _jsonObjectFromFileNamed: @"random"];
	
	FDRandomJSONModel *randomJSONModel = [transformer objectOfClass: [FDRandomJSONModel class] 
		from: jsonObject];
	
	XCTAssertNotNil(randomJSONModel.string);
	XCTAssertNotNil(randomJSONModel.number);
	XCTAssertNotNil(randomJSONModel.stringFromNumber);
	XCTAssertNotNil(randomJSONModel.numberFromString);
	XCTAssertNotNil(randomJSONModel.date);
	XCTAssertNotNil(randomJSONModel.url);
	XCTAssertNotNil(randomJSONModel.colorFromNumber);
	XCTAssertNotNil(randomJSONModel.colorFromString);
	XCTAssertNotNil(randomJSONModel.dictionary);
	XCTAssertNotNil(randomJSONModel.array);
	XCTAssertNil(randomJSONModel.null);
	XCTAssertNotNil(randomJSONModel.initializedPropertyWithNoJSONField);
	XCTAssertNil(randomJSONModel.initializedPropertyToBeNullified);
	
	FDAssertIsKindOfClass(randomJSONModel.string, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.string)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.number, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.number)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.stringFromNumber, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.stringFromNumber)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.numberFromString, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.numberFromString)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.date, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.date)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.url, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.url)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.colorFromNumber, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.colorFromNumber)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.colorFromString, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.colorFromString)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.dictionary, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.dictionary)].objectClass);
	FDAssertIsKindOfClass(randomJSONModel.array, [[randomJSONModel class] fd_declaredPropertyForKeyPath:@keypath(randomJSONModel.array)].objectClass);
	
	XCTAssertEqualObjects(jsonObject[@"string"], randomJSONModel.string);
	XCTAssertEqualObjects(jsonObject[@"number"], randomJSONModel.number);
	XCTAssertEqualObjects([jsonObject[@"stringFromNumber"] stringValue], randomJSONModel.stringFromNumber);
	XCTAssertEqualObjects(@([jsonObject[@"numberFromString"] longLongValue]), randomJSONModel.numberFromString);
	XCTAssertEqual(-18, randomJSONModel.integerFromString);
	XCTAssertEqual(0, randomJSONModel.integerFromNull);
	XCTAssertEqualObjects([transformer.dateFormatter dateFromString: jsonObject[@"date"]], randomJSONModel.date);
	XCTAssertEqualObjects([NSURL URLWithString: jsonObject[@"url"]], randomJSONModel.url);
	XCTAssertEqualObjects([FDColor fd_colorFromRGBANumber: jsonObject[@"colorFromNumber"]], randomJSONModel.colorFromNumber);
	XCTAssertEqualObjects([FDColor fd_colorFromHexString: jsonObject[@"colorFromString"]], randomJSONModel.colorFromString);
	XCTAssertEqualObjects(jsonObject[@"dictionary"], randomJSONModel.dictionary);
	XCTAssertEqualObjects(jsonObject[@"array"], randomJSONModel.array);
}


#pragma mark NSArray

- (void)testNSArrayToNSArray
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSArray *array = @[ @(1), @(2), @(3), @(4), @(5) ];
	NSArray *transformedArray = [transformer objectOfClass: [NSArray class] 
		from: array];
	XCTAssertEqualObjects(array, transformedArray);
}

- (void)testNSArrayOfStringsToNSArrayOfStrings
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSArray *arrayOfStrings = @[ @"1", @"2", @"3", @"4", @"5" ];
	
	NSArray *transformedArrayOfStrings = [transformer objectOfClass: [NSString class] 
		from: arrayOfStrings];
	XCTAssertEqualObjects(arrayOfStrings, transformedArrayOfStrings);
}

- (void)testNSArrayOfStringsToNSArrayOfNumbers
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSArray *arrayOfStrings = @[ @"1", @"2", @"3", @"4", @"5" ];
	NSArray *arrayOfNumbers = @[ @(1), @(2), @(3), @(4), @(5) ];
	
	NSArray *transformedArrayOfNumbers = [transformer objectOfClass: [NSNumber class] 
		from: arrayOfStrings];
	XCTAssertEqualObjects(arrayOfNumbers, transformedArrayOfNumbers);
}

- (void)testNSArrayOfNumbersToNSArrayOfNumbers
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSArray *arrayOfNumbers = @[ @(1), @(2), @(3), @(4), @(5) ];
	
	NSArray *transformedArrayOfNumbers = [transformer objectOfClass: [NSNumber class] 
		from: arrayOfNumbers];
	XCTAssertEqualObjects(arrayOfNumbers, transformedArrayOfNumbers);
}

- (void)testNSArrayOfNumbersToNSArrayOfStrings
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSArray *arrayOfStrings = @[ @"1", @"2", @"3", @"4", @"5" ];
	NSArray *arrayOfNumbers = @[ @(1), @(2), @(3), @(4), @(5) ];
	
	NSArray *transformedArrayOfStrings = [transformer objectOfClass: [NSString class] 
		from: arrayOfNumbers];
	XCTAssertEqualObjects(arrayOfStrings, transformedArrayOfStrings);
}


#pragma mark - Custom Transformations

- (void)testNSURLToNSURLComponents
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	[transformer registerAdapter: [FDURLComponentsTransformerAdapter new] 
		fromClass: [NSURL class] 
		toClass: [NSURLComponents class]];
	
	NSString *urlString = @"http://www.reidmain.com";
	NSURLComponents *urlComponents = [[NSURLComponents alloc] 
		initWithString: urlString];
	NSURL *url = [NSURL URLWithString: urlString];
	NSURLComponents *transformedURLComponents = [transformer objectOfClass: [NSURLComponents class] 
		from: url];
	XCTAssertEqualObjects(urlComponents, transformedURLComponents);
}

- (void)testNSStringToNSURLComponents
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	[transformer registerAdapter: [FDURLComponentsTransformerAdapter new] 
		fromClass: [NSString class] 
		toClass: [NSURLComponents class]];
	
	NSString *urlString = @"http://www.reidmain.com";
	NSURLComponents *urlComponents = [NSURLComponents componentsWithString: urlString];
	NSURLComponents *transformedURLComponents = [transformer objectOfClass: [NSURLComponents class] 
		from: urlString];
	XCTAssertEqualObjects(urlComponents, transformedURLComponents);
}

- (void)testNSArrayOfJSONToFDTwitchStreamSearchResults
{
	FDObjectTransformer *transformer = [FDObjectTransformer new];
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.locale = [NSLocale localeWithLocaleIdentifier: @"en_US_POSIX"];
	dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
	dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ";
	transformer.dateFormatter = dateFormatter;
	
	FDJSONObjectTransformerAdapter *twitchStreamSearchResultsJSONAdapter = [FDJSONObjectTransformerAdapter new];
	twitchStreamSearchResultsJSONAdapter.modelClass = [FDTwitchStreamSearchResults class];
	twitchStreamSearchResultsJSONAdapter.propertyNamingPolicy = FDJSONObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores;
	[twitchStreamSearchResultsJSONAdapter registerRemoteKey: @"_total" 
		forLocalKey: @keypath(FDTwitchStreamSearchResults, total)];
	[twitchStreamSearchResultsJSONAdapter registerRemoteKey: @"_links" 
		forLocalKey: @keypath(FDTwitchStreamSearchResults, next)];
	[twitchStreamSearchResultsJSONAdapter registerCollectionType: [FDTwitchStream class] 
		forPropertyName: @keypath(FDTwitchStreamSearchResults, streams)];
	[twitchStreamSearchResultsJSONAdapter registerValueTransformer: [FDValueTransformer transformerWithBlock: ^id(id value)
		{
			id transformedValue = nil;
			
			if ([value isKindOfClass: [NSDictionary class]] == YES)
			{
				transformedValue = [NSURL URLWithString: value[@"next"]];
			}
			
			return transformedValue;
		}] 
		forPropertyName: @keypath(FDTwitchStreamSearchResults, next)];
	[transformer registerJSONAdapter: twitchStreamSearchResultsJSONAdapter];
	
	FDJSONObjectTransformerAdapter *twitchStreamJSONAdapter = [FDJSONObjectTransformerAdapter new];
	twitchStreamJSONAdapter.modelClass = [FDTwitchStream class];
	twitchStreamJSONAdapter.propertyNamingPolicy = FDJSONObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores;
	[twitchStreamJSONAdapter registerRemoteKey: @"_id" 
		forLocalKey: @keypath(FDTwitchStream, streamID)];
	[twitchStreamJSONAdapter registerRemoteKey: @"game" 
		forLocalKey: @keypath(FDTwitchStream, gameName)];
	[twitchStreamJSONAdapter registerRemoteKey: @"viewers" 
		forLocalKey: @keypath(FDTwitchStream, viewerCount)];
	[twitchStreamJSONAdapter registerRemoteKey: @"preview" 
		forLocalKey: @keypath(FDTwitchStream, previewImageURLs)];
	[transformer registerJSONAdapter: twitchStreamJSONAdapter];
	
	FDJSONObjectTransformerAdapter *twitchChannelJSONAdapter = [FDJSONObjectTransformerAdapter new];
	twitchChannelJSONAdapter.modelClass = [FDTwitchChannel class];
	twitchChannelJSONAdapter.propertyNamingPolicy = FDJSONObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores;
	[twitchChannelJSONAdapter registerRemoteKey: @"game" 
		forLocalKey: @keypath(FDTwitchChannel, gameName)];
	[twitchChannelJSONAdapter registerRemoteKey: @"mature" 
		forLocalKey: @keypath(FDTwitchChannel, isMature)];
	[twitchChannelJSONAdapter registerRemoteKey: @"partner" 
		forLocalKey: @keypath(FDTwitchChannel, isPartner)];
	[twitchChannelJSONAdapter registerRemoteKey: @"profile_banner" 
		forLocalKey: @keypath(FDTwitchChannel, profileBannerURL)];
	[twitchChannelJSONAdapter registerRemoteKey: @"views" 
		forLocalKey: @keypath(FDTwitchChannel, viewCount)];
	[twitchChannelJSONAdapter registerRemoteKey: @"followers" 
		forLocalKey: @keypath(FDTwitchChannel, followerCount)];
	[transformer registerJSONAdapter: twitchChannelJSONAdapter];
	
	FDJSONObjectTransformerAdapter *twitchImageURLsJSONAdapter = [FDJSONObjectTransformerAdapter new];
	twitchImageURLsJSONAdapter.modelClass = [FDTwitchImageURLs class];
	twitchImageURLsJSONAdapter.propertyNamingPolicy = FDJSONObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores;
	[transformer registerJSONAdapter: twitchImageURLsJSONAdapter];
	
	NSDictionary *jsonObject = [self _jsonObjectFromFileNamed: @"twitch_stream_search_results"];
	
	FDTwitchStreamSearchResults *twitchStreamSearchResults = [transformer objectOfClass: [FDTwitchStreamSearchResults class] 
		from: jsonObject];
	
	XCTAssertEqual(twitchStreamSearchResults.total, [jsonObject[@"_total"] unsignedIntegerValue]);
	XCTAssertNotNil(twitchStreamSearchResults.streams);
	XCTAssertNotNil(twitchStreamSearchResults.next);
	
	FDTwitchStream *twitchStream = twitchStreamSearchResults.streams[4];
	NSDictionary *twitchStreamJSON = jsonObject[@"streams"][4];
	
	XCTAssertEqual(twitchStream.streamID, [twitchStreamJSON[@"_id"] unsignedIntegerValue]);
	XCTAssertEqualObjects(twitchStream.gameName, twitchStreamJSON[@"game"]);
	XCTAssertEqualObjects(twitchStream.createdAt, [transformer.dateFormatter dateFromString: twitchStreamJSON[@"created_at"]]);
	XCTAssertEqual(twitchStream.viewerCount, [twitchStreamJSON[@"viewers"] unsignedIntegerValue]);
	XCTAssertEqual(twitchStream.videoHeight, [twitchStreamJSON[@"video_height"] floatValue]);
	XCTAssertEqual(twitchStream.averageFPS, [twitchStreamJSON[@"average_fps"] doubleValue]);
	XCTAssertNotNil(twitchStream.previewImageURLs);
	XCTAssertNotNil(twitchStream.channel);
	
	FDTwitchImageURLs *previewImageURLs = twitchStream.previewImageURLs;
	NSDictionary *previewImageURLsJSON = twitchStreamJSON[@"preview"];
	
	XCTAssertEqualObjects(previewImageURLs.small, [NSURL URLWithString: previewImageURLsJSON[@"small"]]);
	XCTAssertEqualObjects(previewImageURLs.medium, [NSURL URLWithString: previewImageURLsJSON[@"medium"]]);
	XCTAssertEqualObjects(previewImageURLs.large, [NSURL URLWithString: previewImageURLsJSON[@"large"]]);
	XCTAssertEqualObjects(previewImageURLs.template, previewImageURLsJSON[@"template"]);
	
	FDTwitchChannel *twitchChannel = twitchStream.channel;
	NSDictionary *twitchChannelJSON = twitchStreamJSON[@"channel"];

	XCTAssertEqualObjects(twitchChannel.name, twitchChannelJSON[@"name"]);	
	XCTAssertEqualObjects(twitchChannel.displayName, twitchChannelJSON[@"display_name"]);
	XCTAssertEqualObjects(twitchChannel.status, twitchChannelJSON[@"status"]);
	XCTAssertEqualObjects(twitchChannel.gameName, twitchChannelJSON[@"game"]);
	XCTAssertEqual(twitchChannel.isMature, [twitchChannelJSON[@"mature"] boolValue]);
	XCTAssertEqual(twitchChannel.isPartner, [twitchChannelJSON[@"partner"] boolValue]);
	XCTAssertEqualObjects(twitchChannel.profileBannerURL, [NSURL URLWithString: twitchChannelJSON[@"profile_banner"]]);
	XCTAssertEqualObjects(twitchChannel.profileBannerBackgroundColor, [FDColor fd_colorFromHexString: twitchChannelJSON[@"profile_banner_background_color"]]);
	XCTAssertEqual(twitchChannel.viewCount, [twitchChannelJSON[@"views"] unsignedIntegerValue]);
	XCTAssertEqual(twitchChannel.followerCount, [twitchChannelJSON[@"followers"] unsignedIntegerValue]);
	XCTAssertEqualObjects(twitchChannel.createdAt, [transformer.dateFormatter dateFromString: twitchChannelJSON[@"created_at"]]);
	XCTAssertEqualObjects(twitchChannel.updatedAt, [transformer.dateFormatter dateFromString: twitchChannelJSON[@"updated_at"]]);
}


#pragma mark - Performance

- (void)testPerformance
{
    [self measureBlock: ^
		{
		}];
}


#pragma mark - Private Methods

- (id)_jsonObjectFromFileNamed: (NSString *)filename
{
	NSBundle *bundle = [NSBundle bundleForClass: [self class]];
	NSString *path = [bundle pathForResource: filename 
		ofType: @"json"];
	NSData *data = [NSData dataWithContentsOfFile: path];
	id jsonObject = [NSJSONSerialization JSONObjectWithData: data 
		options: NSJSONReadingAllowFragments 
		error: nil];
	return jsonObject;
}

@end