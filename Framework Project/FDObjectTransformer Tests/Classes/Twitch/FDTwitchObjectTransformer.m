#import "FDTwitchObjectTransformer.h"

#import "FDKeypath.h"
#import "FDValueTransformer.h"
#import "FDTwitchStreamSearchResults.h"


#pragma mark Constants


#pragma mark - Class Extension

@interface FDTwitchObjectTransformer ()

@end


#pragma mark - Class Variables


#pragma mark - Class Definition

@implementation FDTwitchObjectTransformer


#pragma mark - Properties


#pragma mark - Constructors

- (id)init
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	// Initialize instance variables.
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.locale = [NSLocale localeWithLocaleIdentifier: @"en_US_POSIX"];
	dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
	dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ";
	self.dateFormatter = dateFormatter;
	
	FDObjectDescriptor *twitchStreamSearchResultsDescriptor = [FDObjectDescriptor new];
	twitchStreamSearchResultsDescriptor.propertyNamingPolicy = FDObjectDescriptorPropertyNamingPolicyLowerCaseWithUnderscores;
	[twitchStreamSearchResultsDescriptor registerRemoteKeyPath: @"_total" 
		forLocalKey: @keypath(FDTwitchStreamSearchResults, total)];
	[twitchStreamSearchResultsDescriptor registerRemoteKeyPath: @"_links.next" 
		forLocalKey: @keypath(FDTwitchStreamSearchResults, next)];
	[twitchStreamSearchResultsDescriptor registerCollectionType: [FDTwitchStream class] 
		forPropertyName: @keypath(FDTwitchStreamSearchResults, streams)];
	[self registerDescriptor: twitchStreamSearchResultsDescriptor 
		forClass: [FDTwitchStreamSearchResults class]];
	
	FDObjectDescriptor *twitchStreamDescriptor = [FDObjectDescriptor new];
	twitchStreamDescriptor.propertyNamingPolicy = FDObjectDescriptorPropertyNamingPolicyLowerCaseWithUnderscores;
	[twitchStreamDescriptor registerRemoteKeyPath: @"_id" 
		forLocalKey: @keypath(FDTwitchStream, streamID)];
	[self registerDescriptor: twitchStreamDescriptor 
		forClass: [FDTwitchStream class]];
	
	FDObjectDescriptor *twitchChannelDescriptor = [FDObjectDescriptor new];
	twitchChannelDescriptor.propertyNamingPolicy = FDObjectDescriptorPropertyNamingPolicyLowerCaseWithUnderscores;;
	NSDictionary *dictionary = @{ 
		@"en" : @(FDTwitchChannelLanguageEnglish), 
		@"zh" : @(FDTwitchChannelLanguageChinese), 
		@"zh-tw" : @(FDTwitchChannelLanguageTaiwanese), 
		};
	[twitchChannelDescriptor registerEnumDictionary: dictionary 
		forLocalKey: @keypath(FDTwitchChannel, language)];
	[twitchChannelDescriptor registerEnumDictionary: dictionary 
		forLocalKey: @keypath(FDTwitchChannel, broadcasterLanguage)];
	[self registerDescriptor: twitchChannelDescriptor 
		forClass: [FDTwitchChannel class]];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end