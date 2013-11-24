//
//  TagModel.h
//  PhotoAlbum
//
//  Created by user1 on 2013/11/24.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetailImageModel;

@interface TagModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) DetailImageModel *detailImageModel;

@end
