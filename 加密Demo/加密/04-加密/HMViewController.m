//
//  HMViewController.m
//  04-加密
//
//  Created by apple on 14-6-26.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"
#import "NSString+Hash.h"

#define Salt @"fsdhjkfhjksdhjkfjhkd546783765"

@interface HMViewController ()

@end

@implementation HMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self digest4:@"123"]; //
    
    
    [self digest4:@"abc"];
    [self digest4:@"456"];
}

/**
 *  直接用MD5加密
 */
- (NSString *)digest:(NSString *)str
{
    NSString *anwen = [str md5String];
    NSLog(@"%@ - %@", str, anwen);
    return anwen;
}

/**
 *  加盐
 */
- (NSString *)digest2:(NSString *)str
{
    str = [str stringByAppendingString:Salt];
    
    NSString *anwen = [str md5String];
    NSLog(@"%@ - %@", str, anwen);
    return anwen;
}

/**
 *  多次MD5
 */
- (NSString *)digest3:(NSString *)str
{
    NSString *anwen = [str md5String];
    
    anwen = [anwen md5String];
    
    NSLog(@"%@ - %@", str, anwen);
    return anwen;
}

/**
 *  先加密, 后乱序
 */
- (NSString *)digest4:(NSString *)str
{
    NSString *anwen = [str md5String];
    
    // 注册:  123 ----  2CB962AC59075B964B07152D234B7020
    
    // 登录: 123 --- 202CB962AC59075B964B07152D234B70
    
    NSString *header = [anwen substringToIndex:2];
    NSString *footer = [anwen substringFromIndex:2];
    
    anwen = [footer stringByAppendingString:header];
    
    
    NSLog(@"%@ - %@", str, anwen);
    
    return anwen;
}

@end
