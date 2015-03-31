//
//  PathUtil.h
//  ZUMenu
//
//  Created by hu yanping on 11-4-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kTempImgPath @"tempImg"

@interface FileUtil : NSObject

//根据图片文件的绝对路径返回图片
+ (UIImage *) loadImageFromResource:(NSString *) imageName ofType:(NSString *)imageType;

+ (UIImage *) loadImageFromFile:(NSString *)pathName;
+ (UIImage *) loadImageFromResource:(NSString *) imageName;

+ (UIImage *) loadImage:(NSString *) fullPath sugguestFile:(NSString *) fileName;

+ (void)loadBackImage:(UIView *)myView imageName:(NSString *)imageName viewBound:(CGRect)viewBound;

+ (UIImageView *)backImage:(UIView *)myView imageName:(NSString *)imageName viewBound:(CGRect)viewBound;

+ (NSString *)getDocPath:(NSString *)fileName;

+ (NSString *)saveData:(NSData *)data toFileName:(NSString *)fileName;

+ (NSString *)getPDFPath;

+ (NSString *)getVideoPath;
+(NSString *)getTempPath;

+ (void)deleteFileForPath:(NSString *)path;

+(NSString *)getCachePathFor:(NSString *)cachePath;
+(void)setCachePathFor;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end
