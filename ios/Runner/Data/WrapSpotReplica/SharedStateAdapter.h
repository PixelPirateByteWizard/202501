#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharedStateAdapter : NSObject

@property (nonatomic) int robustFeatureRate;

+ (instancetype) sharedstateAdapterWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) completionNearBuffer;

- (NSMutableDictionary *) promiseAsParameter;

- (int) effectInEnvironment;

- (NSMutableSet *) bitrateModeBorder;

- (NSMutableArray *) particleVarTint;

@end

NS_ASSUME_NONNULL_END
        