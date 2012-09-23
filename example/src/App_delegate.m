#import "App_delegate.h"

#import "View_controller.h"


@implementation App_delegate

@synthesize controller;
@synthesize window;

- (BOOL)application:(UIApplication *)application
	didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	controller = [View_controller new];
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	if ([self.window respondsToSelector:@selector(setRootViewController:)])
		self.window.rootViewController = self.controller;
	else
		[self.window addSubview:self.controller.view];
	[self.window makeKeyAndVisible];

	return YES;
}

- (void)dealloc
{
	[controller release];
	[window release];
	[super dealloc];
}

@end

// vim:tabstop=4 shiftwidth=4 syntax=objc
