//
//  ViewController.h
//  CarouselViewInfinite
//
//  Created by Vlad on 21/03/2015.
//  Copyright (c) 2015 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarouselView.h"

@interface ViewController : UIViewController<CarouselViewDataSource>

@property(strong, nonatomic) CarouselView * carouselView;
@property(strong, nonatomic) NSMutableArray * viewsArray;
@property(strong, nonatomic) NSMutableArray * identifierArray;



@end

