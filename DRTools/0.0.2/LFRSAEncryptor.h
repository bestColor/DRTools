//
//  LFRSAEncryptor.h
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//


/* publick_key.der 和 private_key_p12 生成命令行
 
 1、生成公钥私钥。
 
 1）打开终端，在终端中cd到你想保存公钥私钥的文件夹
 
 2）生成模长为1024bit的私钥文件private_key.pem
 
 openssl genrsa -out private_key.pem 1024
 
 3）生成证书请求文件rsaCertReq.csr
 
 openssl req -new -key private_key.pem -out rsaCerReq.csr
 
 PS：这一步会提示输入国家、省份、mail等信息，可以根据实际情况填写，或者全部不用填写，直接全部敲回车.
 
 4) 生成证书rsaCert.crt，并设置有效时间为1年
 
 openssl x509 -req -days 3650 -in rsaCerReq.csr -signkey private_key.pem -out rsaCert.crt
 
 5）生成供iOS使用的公钥文件public_key.der
 
 openssl x509 -outform der -in rsaCert.crt -out public_key.der
 
 6）生成供iOS使用的私钥文件private_key.p12
 
 openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt
 
 注意：这一步会提示给私钥文件设置密码，直接输入想要设置密码即可，然后敲回车，然后再验证刚才设置的密码，再次输入密码，然后敲回车，完毕！
 
 在解密时，private_key.p12文件需要和这里设置的密码配合使用，因此需要牢记此密码.
 
 PS:正常来说公钥是加密使用，私钥是解密使用，我们做数据加密可以跟后台要公钥，然后将数据加密后给后台，让后台利用私钥解密，因为现在没有后台，此时我们自己生成公钥私钥
 
 2、新建工程, 并导入Security.framework框架
 
 */


/*
        使用方法
 
 
 - (void)RSAEncryptorTest
 {
 NSString *password = @"123456";
 
 //使用.der和.p12中的公钥私钥加密解密，本级的我放在1111_小说文件夹里了
 NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
 NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
 
 NSString *encryptPassword = [LFRSAEncryptor encryptString:password publicKeyWithContentsOfFile:public_key_path];
 NSString *decryptPassword = [LFRSAEncryptor decryptString:encryptPassword privateKeyWithContentsOfFile:private_key_path password:@"jjjjj"];
 NSLog(@"解密后的内容是 = %@",decryptPassword);
 }
 
 
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFRSAEncryptor : NSObject

/**
 加密方法
 
 @param str 需要加密的字符串
 @param path ‘.der’格式的公钥文件路径
 @return 加密之后的字符串
 */
+ (NSString *)encryptString:(NSString *)str publicKeyWithContentsOfFile:(NSString *)path;

/**
 解密方法
 
 @param str 需要解密的字符串
 @param path ‘.p12’格式的私钥文件路径
 @param password  私钥文件的密码
 @return 解密之后的字符串
 */
+ (NSString *)decryptString:(NSString *)str privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 *  加密方法
 *
 *  @param str    需要加密的字符串
 *  @param pubKey 公钥字符串
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;

/**
 *  解密方法
 *
 *  @param str    需要解密的字符串
 *  @param privateKey 私钥字符串
 */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privateKey;


@end

NS_ASSUME_NONNULL_END
