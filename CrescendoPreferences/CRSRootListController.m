#include "CRSRootListController.h"

@implementation CRSRootListController

- (NSArray *)specifiers {
	
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;

}

- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier properties][@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[[specifier properties][@"key"]]) ?: [specifier properties][@"default"];

}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier properties][@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:[specifier properties][@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)[specifier properties][@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}

}

- (void)reset {

	for (PSSpecifier *specifier in [self specifiers]) {
		id dflt = [specifier properties][@"default"];
		if (dflt) [self setPreferenceValue:dflt specifier:specifier];
	}
	[self reloadSpecifiers];

}

- (void)github {

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/YulkyTulky/Crescendo"] options:@{} completionHandler:nil];

}

- (void)discord {

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://discord.gg/Z8hqzXY"] options:@{} completionHandler:nil];

}

@end