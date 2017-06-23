//
//  JSMutuallyObjectC.h
//  JSMutuallObjectC
//
//  Created by 王盛魁 on 2017/6/23.
//  Copyright © 2017年 WangShengKui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSMutuallyObjectCProtocol <JSExport>

- (void)TestNOParameter;
- (void)TestOneParameter:(NSString *)message;
- (void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2;
- (void)getDataWithDic:(NSDictionary *)dict;
- (NSString *)getSomeData;

@end


@protocol JSMutuallyObjectCDelegate <NSObject>

- (void)DelegateTestNOParameter;
- (void)DelegateTestOneParameter:(NSString *)message;
- (void)DelegateTestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2;
- (void)DelegateGetDataWithDic:(NSDictionary *)dict;
- (NSString *)DelegateGetSomeData;

@end

@interface JSMutuallyObjectC : NSObject <JSMutuallyObjectCProtocol>

@property (nonatomic,weak) id <JSMutuallyObjectCDelegate> delegate;

@end
