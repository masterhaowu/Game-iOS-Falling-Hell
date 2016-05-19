//
//  HWGameData.h
//  HAOS HELL
//
//  Created by Hao Wu on 5/28/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWGameData : NSObject
@property int highscore;

+(id)data;
-(void)save;
-(void)load;

@end
