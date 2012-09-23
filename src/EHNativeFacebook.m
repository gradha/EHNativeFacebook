#import "EHNativeFacebook.h"

/// Duplicated from iOS 6 SDK, actually SLServiceTypeFacebook.
static NSString *facebookConstant = @"com.apple.social.facebook";

@implementation EHNativeFacebook

/// Implements an invokation method to correctly return BOOL primitive types.
+ (BOOL)call:(id)target selector:(SEL)selector argument:(id)argument
{
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[target
		methodSignatureForSelector:selector]];
	[inv setSelector:selector];
	[inv setTarget:target];
	[inv setArgument:&argument atIndex:2];
	[inv invoke];

	// Now check the returned bool value.
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wpedantic\"") \
	NSAssert(sizeof(BOOL) == [[inv methodSignature] methodReturnLength],
		@"Bad return size!");
_Pragma("clang diagnostic pop")
	if (sizeof(BOOL) == [[inv methodSignature] methodReturnLength]) {
		BOOL ret;
		[inv getReturnValue:&ret];
		return ret;
	} else {
		return NO;
	}
}

/** Obtain the Facebook post controller with the specified comment and URL.
 * You can safely pass nil/zero length comment strings or nil urls if you don't
 * need any of them or you want to use your own @selector calls.
 *
 * \return Returns nil if there was a problem with the Facebook class, most
 * likely that Facebook is not available or not configured on the device. You
 * might want to fall back to another Facebook implementation if possible (eg.
 * old Facebook sdk or ShareKit).
 *
 * If the method is successful, the Facebook post view composer will be
 * returned so that you can call presentModalViewController:animated: with it.
 * You don't have to, though, so you can use a non nil return value to know
 * posting to facebook is actually possible.
 */
+ (id)postControllerForComment:(NSString*)comment withURL:(NSURL*)url
{
	// Is the class available?
	Class provider = NSClassFromString(@"SLComposeViewController");
	SEL is_available = @selector(isAvailableForServiceType:);
	if (!provider || ![provider
			performSelector:is_available withObject:facebookConstant])
		return nil;

	// Can we get the class please?
	id composer = [provider
		performSelector:@selector(composeViewControllerForServiceType:)
		withObject:facebookConstant];
	if (!composer)
		return nil;

	// Can we add our URL to the composer?
	if (url) {
		if (![self call:composer selector:@selector(addURL:) argument:url])
			return nil;
	}

	// Can we set an initial text?
	if (comment.length) {
		if (![self call:composer selector:@selector(setInitialText:)
				argument:comment])
			return nil;
	}

	return composer;
}

@end

// vim:tabstop=4 shiftwidth=4 syntax=objc
