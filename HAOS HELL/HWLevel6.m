//
//  level6.m
//  HAOS HELL
//
//  Created by Hao Wu on 5/25/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import "HWLevel6.h"

@interface HWLevel6 ()



@end

@implementation HWLevel6

+(id)level6:(float)barSpeed
{
    HWLevel6 *level6 = [HWLevel6 spriteNodeWithImageNamed:@"platform20_100"];
    level6.name = @"level6";
    level6.barSpeed = barSpeed;
    level6.isPositive = YES;
    level6.onMe = NO;
    return level6;
    
}





@end
