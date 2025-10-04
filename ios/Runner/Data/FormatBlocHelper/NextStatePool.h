#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NextStatePool : NSObject

@property (nonatomic) int localizationStageState;

+ (instancetype) nextStatePoolWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) rowByActivity;

- (NSMutableDictionary *) titleForCommand;

- (int) enabledGradientValidation;

- (NSMutableSet *) topicBeyondEnvironment;

- (NSMutableArray *) agileActionVelocity;

@end

NS_ASSUME_NONNULL_END
        