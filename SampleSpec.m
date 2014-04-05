#import "Kiwi.h"
#import "CFRReviverWod.h"

SPEC_BEGIN(MathSpec)

describe(@"test", ^{
    CFRReviverWod *wod = [[CFRReviverWod alloc] init];
    wod.title = @"Wod";
    it(@"for wod title", ^{
        [[wod.title should] containString:@"Wod"];
    });
});

SPEC_END
