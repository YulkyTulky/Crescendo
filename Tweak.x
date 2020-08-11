#import "Crescendo.h"

%hook SBVolumeControl

- (float)volumeStepUp {

	return enabled ? stepUp : %orig;

}

- (float)volumeStepDown {

	return enabled ? stepDown : %orig;

}

%end

static void loadPrefs() {

	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yulkytulky.crescendo.plist"];

	enabled = [preferences objectForKey:@"enabled"] ? [[preferences objectForKey:@"enabled"] boolValue] :  YES;

	stepUp = [preferences objectForKey:@"stepUp"] ? [[preferences objectForKey:@"stepUp"] floatValue] :  6.25;
	stepDown = [preferences objectForKey:@"stepDown"] ? [[preferences objectForKey:@"stepDown"] floatValue] :  6.25;

	stepUp /= 100; // Percent -> Decimal
	stepDown /= 100; // Percent -> Decimal

}

%ctor {

	loadPrefs(); // Load preferences into variables
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.yulkytulky.crescendo/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce); // Listen for preference changes

	%init;

}