#import "Kiwi.h"
#import "CFRReviverWod.h"

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

describe(@"test", ^{
    CFRReviverWod *wod = [[CFRReviverWod alloc] init];
    wod.title = @"Wod";
    it(@"for wod title", ^{
        [[wod.title should] containString:@"Wod"];
    });
});

SPEC_END
