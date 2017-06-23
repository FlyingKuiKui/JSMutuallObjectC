//
//  JSMutuallyObjectC.m
//  JSMutuallObjectC
//
//  Created by 王盛魁 on 2017/6/23.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import "JSMutuallyObjectC.h"

@implementation JSMutuallyObjectC
- (void)TestNOParameter{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DelegateTestNOParameter)]) {
        [self.delegate DelegateTestNOParameter];
    }
}
- (void)TestOneParameter:(NSString *)message{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DelegateTestOneParameter:)]) {
        [self.delegate DelegateTestOneParameter:message];
    }
}
- (void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DelegateTestTowParameter:SecondParameter:)]) {
        [self.delegate DelegateTestTowParameter:message1 SecondParameter:message2];
    }
}
- (void)getDataWithDic:(NSDictionary *)dict{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DelegateGetDataWithDic:)]) {
        [self.delegate DelegateGetDataWithDic:dict];
    }
}
- (NSString *)getSomeData{
    NSString *returnString = [NSString string];
    if (self.delegate && [self.delegate respondsToSelector:@selector(DelegateGetSomeData)]) {
        returnString = [self.delegate DelegateGetSomeData];
    }
    return returnString;
}
@end
