#import <Foundation/Foundation.h>
#import "MKLLRootListController.h"

@implementation MKLLRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

@end
