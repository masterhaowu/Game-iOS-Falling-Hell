//
//  HWGameData.m
//  HAOS HELL
//
//  Created by Hao Wu on 5/28/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import "HWGameData.h"

@interface HWGameData ()
@property NSString *filePath;

@end

@implementation HWGameData


+(id)data
{
    HWGameData *data = [HWGameData new];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = @"archive.data";
    data.filePath = [path stringByAppendingPathComponent:fileName];
    return data;
}

-(void)save
{
    NSNumber *highScoreObject = [NSNumber numberWithInteger:self.highscore];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:highScoreObject];
    [data writeToFile:self.filePath atomically:YES];
    
}

-(void)load
{
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    NSNumber *highScoreObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.highscore = highScoreObject.intValue;
    
}

@end
