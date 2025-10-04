#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TappableRowSchema : NSObject

@property (nonatomic) int tickerAtPhase;

+ (instancetype) tappableRowSchemaWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) smartMarginShape;

- (NSMutableDictionary *) localizationOfComposite;

- (int) globalStreamValidation;

- (NSMutableSet *) sliderValueInset;

- (NSMutableArray *) completerOperationColor;

@end

NS_ASSUME_NONNULL_END
        