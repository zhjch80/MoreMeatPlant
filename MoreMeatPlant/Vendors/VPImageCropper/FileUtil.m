//
//  PathUtil.m
//  ZUMenu
//
//  Created by hu yanping on 11-4-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileUtil.h"
#import "DSGlobelFunc.h"

#define kCachePath @"ilpCache"
#define kImageTypePNG       @"png"

@implementation FileUtil


+ (UIImage *) loadImageFromResource:(NSString *) imageName ofType:(NSString *)imageType{
    if (imageType == nil) {
        imageType = kImageTypePNG;
    }
    NSString *fullPath = nil;
    //是否采用视网膜屏 加载高清图片
//    if (isiPhone5 || isRetina) {
//        fullPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:imageType];
//    }else{
        fullPath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
//    }
	return [UIImage imageWithContentsOfFile:fullPath];
}

+ (UIImage *) loadImageFromFile:(NSString *)pathName{
	return [UIImage imageWithContentsOfFile:pathName];
}

+(UIImage *) loadImage:(NSString *) fullPath sugguestFile:(NSString *) fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *imgDirectory = [documentsDirectory stringByAppendingPathComponent:fullPath]; 
	NSString *destPath = [imgDirectory stringByAppendingPathComponent:fileName];
	UIImage *image = [UIImage imageWithContentsOfFile:destPath];
	return image;
}

+(NSString *)getPDFPath{
    NSString *path = [[self getCachePathFor:@"pdf"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",[DSGlobelFunc gen_uuid]]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    if ([DSGlobelFunc is51Up]) {
       [FileUtil addSkipBackupAttributeToItemAtURL:[[NSURL alloc] initFileURLWithPath:path]];
    }
    return path;
}

+(NSString *)getVideoPath{
    NSString *path = [[self getCachePathFor:@"video"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[DSGlobelFunc gen_uuid]]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    if ([DSGlobelFunc is51Up]) {
        [FileUtil addSkipBackupAttributeToItemAtURL:[[NSURL alloc] initFileURLWithPath:path]];
    }
    return path;
}

+(NSString *)getTempPath{
    NSString *path = [[self getCachePathFor:@"temp"] stringByAppendingPathComponent:[DSGlobelFunc gen_uuid]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    if ([DSGlobelFunc is51Up]) {
        [FileUtil addSkipBackupAttributeToItemAtURL:[[NSURL alloc] initFileURLWithPath:path]];
    }
    return path;
}

+ (UIImage *) loadImageFromResource:(NSString *) imageName{
	NSString *fullPath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
	return [UIImage imageWithContentsOfFile:fullPath];
}

+ (void)loadBackImage:(UIView *)myView imageName:(NSString *)imageName viewBound:(CGRect)viewBound{
    UIImageView *floorView  = [[UIImageView alloc] initWithFrame:viewBound];
    floorView.userInteractionEnabled = YES;
    UIImage *floorImg  = [FileUtil loadImageFromResource:imageName ofType:nil];
    floorView.image = floorImg;
    [myView addSubview:floorView];
    [myView sendSubviewToBack:floorView];
}

+ (UIImageView *)backImage:(UIView *)myView imageName:(NSString *)imageName viewBound:(CGRect)viewBound{
    UIImageView *floorView  = [[UIImageView alloc] initWithFrame:viewBound];
    UIImage *floorImg  = [FileUtil loadImageFromResource:imageName ofType:nil];
    floorView.image = floorImg;
    [myView addSubview:floorView];
    [myView sendSubviewToBack:floorView];
    return floorView;
}

//获取document目录
+ (NSString *)getDocPath:(NSString *)fileName{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:fileName]]) {
        [fileManager createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:fileName] withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
}

+ (NSString *)saveData:(NSData *)data toFileName:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[FileUtil getCachePathFor:kTempImgPath]]) {
        [fileManager createDirectoryAtPath:[FileUtil getCachePathFor:kTempImgPath] withIntermediateDirectories:YES attributes:Nil error:Nil];
    }
    
    NSString *path = [[FileUtil getCachePathFor:kTempImgPath] stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:NULL];
    }
    
    [data writeToFile:path atomically:YES];
    
    return path;
}

+(void)deleteFileForPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

//5.1以上用document 5.1一下用Lib cache
+(NSString *)getCachePathFor:(NSString *)cachePath{
    NSString *diskCachePath = nil;
    if ([DSGlobelFunc is51Up]) {
        diskCachePath = [self getDocPath:kCachePath];
        diskCachePath = [diskCachePath stringByAppendingPathComponent:cachePath];
        //NSLog(@"%@",diskCachePath);
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }else{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:kCachePath];
        diskCachePath = [diskCachePath stringByAppendingPathComponent:cachePath];
        //NSLog(@"%@",diskCachePath);
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    }
    return diskCachePath;
}

+(void)setCachePathFor{
    NSString *diskCachePath = nil;
    if ([DSGlobelFunc is51Up]) {
        diskCachePath = [self getDocPath:kCachePath];
        //NSLog(@"%@",diskCachePath);
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        [FileUtil addSkipBackupAttributeToItemAtURL:[[NSURL alloc] initFileURLWithPath:diskCachePath]];
    }
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    //NSLog(@"%@",[URL path]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end