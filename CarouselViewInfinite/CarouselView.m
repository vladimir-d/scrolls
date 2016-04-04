//
//  CarouselView.m
//  CarouselViewInfinite
//
//  Created by Vlad on 21/03/2015.
//  Copyright (c) 2015 Vlad. All rights reserved.
//

#import "CarouselView.h"

@implementation CarouselView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.scrollView];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.insets = UIEdgeInsetsMake(100, 100, 100, 100);
    [self reloadPages];
    //[self autoscrollStart];
    return self;
}

-(void)reloadPages
{
    NSInteger numberOfPages = [self.dataSource numberOfPagesForView:self];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * (numberOfPages + 1), self.scrollView.bounds.size.height);
}

-(void)updatePages
{
    
    self.currentViewNumber = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    NSInteger deltaBegin, deltaEnd, counter;
    NSInteger currentLength = self.currentSegment.end - self.currentSegment.start;
    CarouselViewSegment newSegment = [self newViewsSegment];
    NSDictionary * currentViewWithIdentifier;
    UIView * currentView;
    NSString * currentIdentifier;
    NSMutableSet * set;
    deltaBegin = newSegment.start - self.currentSegment.start;
    deltaEnd = newSegment.end - self.currentSegment.end;
    if (deltaBegin < 0)
    {
        for (counter = 0; counter > deltaBegin; counter--)
        {
            NSInteger number = self.currentSegment.start + counter - 1;
            if (number > -1)
            {
                currentViewWithIdentifier = [self placeViewOnPageOnIndex:self.currentSegment.start + counter - 1];
                [self.currentViews insertObject:currentViewWithIdentifier atIndex:0];
            }
            
        }
    }
    else
    {
        for (counter = 0; (counter < deltaBegin) && (counter < currentLength); counter++)
        {
            currentViewWithIdentifier = [self.currentViews objectAtIndex:counter];
            currentView = [currentViewWithIdentifier objectForKey:@"view"];
            currentIdentifier = [currentViewWithIdentifier objectForKey:@"identifier"];
            set = [self.reusableViews objectForKey:currentIdentifier];
            [set addObject:currentView];
            [currentView removeFromSuperview];
            [self.currentViews removeObjectAtIndex:counter];
        }
    }
    if (deltaEnd < 0)
    {
        for (counter = 0; (counter > deltaEnd) && (counter + currentLength > 0); counter--)
        {
            currentViewWithIdentifier = [self.currentViews lastObject];
            currentView = [currentViewWithIdentifier objectForKey:@"view"];
            currentIdentifier = [currentViewWithIdentifier objectForKey:@"identifier"];
            set = [self.reusableViews objectForKey:currentIdentifier];
            [set addObject:currentView];
            [currentView removeFromSuperview];
            [self.currentViews removeLastObject];
        }
    }
    else
    {
        for (counter = 0; counter < deltaEnd; counter++)
        {
            NSInteger number = self.currentSegment.end + counter;
            currentViewWithIdentifier = [self placeViewOnPageOnIndex:number];
            [self.currentViews addObject:currentViewWithIdentifier];
        }
    }
    self.currentSegment = newSegment;
}

-(CarouselViewSegment)newViewsSegment
{
    CarouselViewSegment segment;
    CGFloat leftMargin = self.scrollView.bounds.origin.x + self.scrollView.frame.size.width;
    if (leftMargin > self.scrollView.contentSize.width)
    {
        [self.scrollView setContentOffset:CGPointMake(leftMargin - self.scrollView.contentSize.width, self.bounds.origin.y) animated:NO];
    }
    if (self.scrollView.bounds.origin.x < 0)
    {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.origin.x + self.scrollView.contentSize.width - self.scrollView.bounds.size.width, self.bounds.origin.y) animated:NO];
    }
    segment.start = floor(self.scrollView.bounds.origin.x / self.bounds.size.width);
    segment.end = ceil(leftMargin / self.scrollView.frame.size.width);
    return segment;
}

-(NSDictionary *)placeViewOnPageOnIndex:(NSInteger)index
{
    UIView * currentView;
    NSString * identifier = [self.dataSource carouselView:self identifierForPageAtIndex:index];
    NSSet * set = [self.reusableViews objectForKey:identifier];
    if (set.count > 0)
    {
        currentView = [set anyObject];
    }
    else
    {
        currentView = nil;
    }
    currentView = [self.dataSource carouselView:self viewForPageAtIndex:index reusableView:currentView];
    CGRect newRect = CGRectMake(self.bounds.size.width*index, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    currentView.frame = UIEdgeInsetsInsetRect(newRect, self.insets);
    [self.scrollView addSubview:currentView];
    NSMutableDictionary * currentViewWithIdentifier = [NSMutableDictionary dictionaryWithCapacity:2];
    [currentViewWithIdentifier setObject:currentView forKey:@"view"];
    [currentViewWithIdentifier setObject:identifier forKey:@"identifier"];
    return currentViewWithIdentifier;
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updatePages];
    NSLog(@"scrollView:%@",scrollView);
    
    if ((int)scrollView.contentOffset.x%50 == 0) {
        NSLog(@"[scrollView subviews]:%@",[scrollView subviews]);
    }
}

-(void)autoscrollNext
{
    if (self.autoscrollEnabled)
    {
        CGPoint newOffset;
        if (self.autoscrollForward)
        {
            newOffset = CGPointMake(self.scrollView.bounds.origin.x + self.scrollView.bounds.size.width, self.bounds.origin.y);
        }
        else
        {
            newOffset = CGPointMake(self.scrollView.bounds.origin.x + self.scrollView.bounds.size.width, self.bounds.origin.y);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView setContentOffset:newOffset animated:YES];
            [self autoscrollNext];
        });
    }
}

-(void)autoscrollStart
{
    self.autoscrollEnabled = YES;
    [self autoscrollNext];
}

-(void)autoscrollEnd
{
    self.autoscrollEnabled = NO;
}

@end
