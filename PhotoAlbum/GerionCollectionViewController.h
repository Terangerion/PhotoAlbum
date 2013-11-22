//
//  GerionCollectionViewController.h
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

static NSMutableArray *assetList;

@interface GerionCollectionViewController : UICollectionViewController

// @property  NSMutableArray *assetList;
//+ (NSMutableArray *)assetList;

+ (NSURL *)prevAssetUrl:(NSURL *)assetUrl;
+ (NSURL *)nextAssetUrl:(NSURL *)assetUrl;

@end
