//
//  HMViewController.m
//  02-NSURLConnection02-POST请求
//
//  Created by apple on 14-6-26.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMViewController.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Hash.h"

@interface HMViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
- (IBAction)login;
@end

@implementation HMViewController


/**
 *  登录逻辑
 */
- (IBAction)login
{
    // 1.表单验证(输入验证)
    NSString *username = self.usernameField.text;
    if (username.length == 0) { // 没有输入用户名
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    
    NSString *pwd = self.pwdField.text;
    if (pwd.length == 0) { // 没有输入密码
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    // 弹框
    [MBProgressHUD showMessage:@"正在拼命登录中..."];
    
    // 2.发送请求给服务器(带上帐号和密码)
    // POST请求:请求体
    
    // 2.1.设置请求路径
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.200:8080/MJServer/login"];
    
    // 2.2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url]; // 默认就是GET请求
    request.timeoutInterval = 5; // 设置请求超时
    request.HTTPMethod = @"POST"; // 设置为POST请求
    
    // 通过请求头告诉服务器客户端的类型
    [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
    
#warning
    pwd = [[pwd stringByAppendingString:@"abcdefg"] md5String]; // 进行MD5加密
    
    // 设置请求体
    NSString *param = [NSString stringWithFormat:@"username=%@&pwd=%@", username, pwd];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.3.发送请求
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {  // 当请求结束的时候调用 (拿到了服务器的数据, 请求失败)
        // 隐藏HUD (刷新UI界面, 一定要放在主线程, 不能放在子线程)
        [MBProgressHUD hideHUD];
        
        /**
         解析data :
         {"error":"用户名不存在"}
         {"error":"密码不正确"}
         {"success":"登录成功"}
         */
        if (data) { // 请求成功
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *error = dict[@"error"];
            if (error) { // 登录失败
                [MBProgressHUD showError:error];
            } else { // 登录成功
                NSString *success =  dict[@"success"];
                [MBProgressHUD showSuccess:success];
            }
        } else { // 请求失败
            [MBProgressHUD showError:@"网络繁忙, 请稍后再试"];
        }
    }];
}

@end
