#import "OntoDialogsPopup.h"
    
@interface OntoDialogsPopup ()

@end

@implementation OntoDialogsPopup

- (void) skipReceiveOffCustompaint: (NSString *)graphicLikeParam
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UISegmentedControl *reactiveMenuBorder = [[UISegmentedControl alloc] init];
		[reactiveMenuBorder insertSegmentWithTitle:graphicLikeParam atIndex:0 animated:YES];
		reactiveMenuBorder.selected = YES;
		reactiveMenuBorder.enabled = NO;
		CALayer * delegateStateLocation = [[CALayer alloc] init];
		delegateStateLocation.bounds = CGRectMake(122, 154, 963, 618);
		delegateStateLocation.backgroundColor = [UIColor blackColor].CGColor;
		delegateStateLocation.borderColor = [UIColor grayColor].CGColor;
		//NSLog(@"sets= bussiness5 gen_str %@", bussiness5);
	});
}


@end
        