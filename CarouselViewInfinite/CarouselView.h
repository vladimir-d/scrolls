//
//  CarouselView.h
//  CarouselViewInfinite
//
//  Created by Vlad on 21/03/2015.
//  Copyright (c) 2015 Vlad. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    NSInteger start;
    NSInteger end;
} CarouselViewSegment;


@class CarouselView;

@protocol CarouselViewDataSource <NSObject>

-(NSInteger)numberOfPagesForView:(CarouselView *)view;
-(NSString *)carouselView:(CarouselView *)carouselView identifierForPageAtIndex:(NSInteger)index;
-(UIView *)carouselView:(CarouselView *)carouselView viewForPageAtIndex:(NSInteger)index reusableView:(UIView *)reusableView;


@end

@interface CarouselView : UIView <UIScrollViewDelegate>

@property (nonatomic,assign) id <CarouselViewDataSource> dataSource;
@property (strong, nonatomic) UIScrollView * scrollView;
@property (assign, nonatomic) NSInteger numberOfPages;
@property (assign, nonatomic) CarouselViewSegment currentSegment;
@property (strong, nonatomic) NSMutableArray * currentViews;
@property (strong, nonatomic) NSMutableDictionary * reusableViews;
@property (nonatomic, assign) NSInteger currentViewNumber;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) BOOL autoscrollEnabled;
@property (nonatomic, assign) BOOL autoscrollForward;


-(void)updatePages;
//- (UIView *)dequeReusableViewWithIdentifier:(NSString *);

@end
