//
//  GerionCollectionViewController.h
//  PhotoAlbum
//
//  Created by user1 on 2013/11/17.
//  Copyright (c) 2013年 terangerion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GerionCollectionViewController : UICollectionViewController {
    @private
    ALAssetsLibrary *library;
    int itemCount;
}
#warning 推奨：インスタンス変数はヘッダに必要な情報ではないので、書かないほうが良いです

@property  NSMutableArray *assetList;
@end
