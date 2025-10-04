#import "ItemOperationDuration.h"
    
@interface ItemOperationDuration ()

@end

@implementation ItemOperationDuration

- (void) executeOldText: (NSMutableSet *)titleNearType
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (![titleNearType containsObject:@"descriptionAroundCommand"]) {
			UIPageControl *taskAndKind = [[UIPageControl alloc] initWithFrame:CGRectMake(338, 388, 90, 960)];
			taskAndKind.currentPageIndicatorTintColor = [UIColor orangeColor];
			taskAndKind.currentPage = 6;
			taskAndKind.tag = 29;
			taskAndKind.frame = CGRectMake(305, 472, 920, 976);
			taskAndKind.currentPage = 2;
			taskAndKind.pageIndicatorTintColor = [UIColor lightGrayColor];
		}
		//NSLog(@"sets= bussiness3 gen_set %@", bussiness3);
	});
}


@end
        