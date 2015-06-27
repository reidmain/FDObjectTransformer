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
	
	FDJSONObjectTransformerAdapter *twitchStreamSearchResultsJSONAdapter = [FDJSONObjectTransformerAdapter adapterForClass: [FDTwitchStreamSearchResults class]];
	twitchStreamSearchResultsJSONAdapter.propertyNamingPolicy = FDDictionaryObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores;
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
	[self registerJSONAdapter: twitchStreamSearchResultsJSONAdapter];
	
	FDJSONObjectTransformerAdapter *twitchStreamJSONAdapter = [FDJSONObjectTransformerAdapter adapterForClass: [FDTwitchStream class]];
	twitchStreamJSONAdapter.propertyNamingPolicy = FDDictionaryObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores;
	[twitchStreamJSONAdapter registerRemoteKey: @"_id" 
		forLocalKey: @keypath(FDTwitchStream, streamID)];
	[self registerJSONAdapter: twitchStreamJSONAdapter];
	
	FDJSONObjectTransformerAdapter *twitchChannelJSONAdapter = [FDJSONObjectTransformerAdapter adapterForClass: [FDTwitchChannel class]];
	twitchChannelJSONAdapter.propertyNamingPolicy = FDDictionaryObjectTransformerAdapterPropertyNamingPolicyLowerCaseWithUnderscores;;
	NSDictionary *dictionary = @{ 
		@"en" : @(FDTwitchChannelLanguageEnglish), 
		@"zh" : @(FDTwitchChannelLanguageChinese), 
		@"zh-tw" : @(FDTwitchChannelLanguageTaiwanese), 
		};
	[twitchChannelJSONAdapter registerEnumDictionary: dictionary 
		forLocalKey: @keypath(FDTwitchChannel, language)];
	[twitchChannelJSONAdapter registerEnumDictionary: dictionary 
		forLocalKey: @keypath(FDTwitchChannel, broadcasterLanguage)];
	[self registerJSONAdapter: twitchChannelJSONAdapter];
	
	// Return initialized instance.
	return self;
}


#pragma mark - Public Methods


#pragma mark - Overridden Methods


#pragma mark - Private Methods


@end