//
//  RMPublicModel.m
//  RMVideo
//
//  Created by 润华联动 on 14-10-30.
//  Copyright (c) 2014年 runmobile. All rights reserved.
//

#import "RMPublicModel.h"

@implementation RMPublicModel

- (id)init{
    if(self == [super init]){
        _imgs = [[NSMutableArray alloc]init];
        _body = [[NSMutableArray alloc]init];
        _classs = [[NSMutableArray alloc]init];
    }
    return self;
}

//#pragma mark NSCoding
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:_name forKey:@"name"];
//    [aCoder encodeObject:_downLoadURL forKey:@"downLoadURL"];
//    [aCoder encodeObject:_pic forKey:@"pic"];
//    [aCoder encodeObject:_cacheProgress forKey:@"cacheProgress"];
//    [aCoder encodeObject:_totalMemory forKey:@"totalMemory"];
//    [aCoder encodeObject:_alreadyCasheMemory forKey:@"alreadyCasheMemory"];
//    [aCoder encodeObject:_downLoadState forKey:@"downLoadState"];
//    [aCoder encodeObject:_cashData forKey:@"cashData"];
//    [aCoder encodeObject:_actors forKey:@"actors"];
//    [aCoder encodeObject:_directors forKey:@"directors"];
//    [aCoder encodeObject:_hits forKey:@"hits"];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.downLoadURL = [aDecoder decodeObjectForKey:@"downLoadURL"];
//        self.pic = [aDecoder decodeObjectForKey:@"pic"];
//        self.cacheProgress = [aDecoder decodeObjectForKey:@"cacheProgress"];
//        self.totalMemory = [aDecoder decodeObjectForKey:@"totalMemory"];
//        self.alreadyCasheMemory = [aDecoder decodeObjectForKey:@"alreadyCasheMemory"];
//        self.downLoadState = [aDecoder decodeObjectForKey:@"downLoadState"];
//        self.cashData = [aDecoder decodeObjectForKey:@"cashData"];
//        self.actors = [aDecoder decodeObjectForKey:@"actors"];
//        self.directors = [aDecoder decodeObjectForKey:@"directors"];
//        self.hits = [aDecoder decodeObjectForKey:@"hits"];
//    }
//    return self;
//}
//
//#pragma mark NSCoping
//- (id)copyWithZone:(NSZone *)zone {
//    RMPublicModel *copy = [[[self class] allocWithZone:zone] init];
//    copy.name = [self.name copyWithZone:zone];
//    copy.pic = [self.pic copyWithZone:zone];
//    copy.cacheProgress = [self.cacheProgress copyWithZone:zone];
//    copy.totalMemory = [self.totalMemory copyWithZone:zone];
//    copy.alreadyCasheMemory = [self.alreadyCasheMemory copyWithZone:zone];
//    copy.downLoadURL = [self.downLoadURL copyWithZone:zone];
//    copy.downLoadState = [self.downLoadState copyWithZone:zone];
//    copy.cashData = [self.cashData copyWithZone:zone];
//    copy.actors = [self.actors copyWithZone:zone];
//    copy.directors = [self.directors copyWithZone:zone];
//    copy.hits = [self.hits copyWithZone:zone];
//    return copy;
//}

@end
