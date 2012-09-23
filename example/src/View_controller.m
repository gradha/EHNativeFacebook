#import "View_controller.h"

#import "EHNativeFacebook.h"


#define _ALERT_MESSAGE	@"Could not obtain facebook composer class, sorry!"
#define _ALERT_TITLE	@"Facebook not available"
#define _CANCEL_BUTTON	@"Meh"
#define _TEXT			@"Look ma, no Social Framework linked and but posting on Facebook compiled on a previous SDK version"
#define _URL			@"https://github.com/gradha/EHNativeFacebook"


@implementation View_controller

- (void)viewDidLoad
{
	UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	b.frame = CGRectInset(self.view.bounds, 50, 50);
	[b setTitle:@"Post on facebook" forState:UIControlStateNormal];
	[b addTarget:self action:@selector(post)
		forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:b];
}

- (void)post
{
	id composer = [EHNativeFacebook postControllerForComment:_TEXT
		withURL:[NSURL URLWithString:_URL]];
	if (composer) {
		[self presentModalViewController:composer animated:YES];
	} else {
		UIAlertView *alert = [[UIAlertView alloc]
			initWithTitle:_ALERT_TITLE message:_ALERT_MESSAGE delegate:nil
			cancelButtonTitle:_CANCEL_BUTTON otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

@end

// vim:tabstop=4 shiftwidth=4 syntax=objc
