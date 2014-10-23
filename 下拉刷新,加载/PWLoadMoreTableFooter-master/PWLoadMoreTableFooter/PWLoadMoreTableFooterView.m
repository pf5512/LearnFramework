//
//  PWLoadMoreTableFooter.m
//  PWLoadMoreTableFooter
//
//  Created by Puttin Wong on 3/31/13.
//  Copyright (c) 2013 Puttin Wong. All rights reserved.
//

#import "PWLoadMoreTableFooterView.h"

@interface PWLoadMoreTableFooterView (Private)
- (void)setState:(PWLoadMoreState)aState;
@end

@implementation PWLoadMoreTableFooterView

@synthesize delegate=_delegate;

- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor lightGrayColor];
        
		UILabel *label = nil;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(50, 12, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		
		[self setState:PWLoadMoreLoading];      //wait for the data source to tell me he has loaded all data
    }
	
    return self;
	
}

/**
 *  @brief 设置状态,提示是否可以加载数据,设置触发方法, 这里最重要
 *
 *  @param aState 状态值
 */
- (void)setState:(PWLoadMoreState)aState
{
	switch (aState) {
		case PWLoadMoreNormal:
            [self addTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"加载数据", @"Load More items");
			[_activityView stopAnimating];
			
			break;
		case PWLoadMoreLoading:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"正在加载中...", @"Loading items");
			[_activityView startAnimating];
			
			break;
		case PWLoadMoreDone:
            [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
			_statusLabel.text = NSLocalizedString(@"没有更多数据", @"There is no more item");
			[_activityView stopAnimating];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)pwLoadMoreTableDataSourceDidFinishedLoading {
    if ([self delegateIsAllLoaded]) {
        [self noMore];
    } else {
        [self canLoadMore];
    }
}

/**
 *  @brief 通过检查是否还有数据需要加载
 *
 *  @return 检查是否还要数据需要加载的标识
 */
- (BOOL)delegateIsAllLoaded {
    BOOL _allLoaded = NO;
    if ([_delegate respondsToSelector:@selector(pwLoadMoreTableDataSourceAllLoaded)]) {
        _allLoaded = [_delegate pwLoadMoreTableDataSourceAllLoaded];
    }
    return _allLoaded;
}

/**
 *  @brief  监测数据源, 再重新设置
 */
- (void)resetLoadMore {
    if ([self delegateIsAllLoaded]) {
        [self noMore];
    } else
        [self canLoadMore];
}

- (void)canLoadMore {
    [self setState:PWLoadMoreNormal];
}

- (void)noMore {
    [self setState:PWLoadMoreDone];
}

- (void)realCallDelegateToLoadMore
{ //temporary
    if ([_delegate respondsToSelector:@selector(pwLoadMore)]) {
        [_delegate pwLoadMore];
        [self setState:PWLoadMoreLoading];
    }
}

-(void) updateStatus:(NSTimer *)timer{
    if ([_delegate respondsToSelector:@selector(pwLoadMoreTableDataSourceIsLoading)]) {
        if ([_delegate pwLoadMoreTableDataSourceIsLoading]) {
            //Do nothing
        } else {
            [timer invalidate];
            [self pwLoadMoreTableDataSourceDidFinishedLoading];
        }
    } else {
        //Do nothing
    }
}

- (void)callDelegateToLoadMore
{
    if (_state == PWLoadMoreNormal) {
        if ([_delegate respondsToSelector:@selector(pwLoadMoreTableDataSourceIsLoading)]) {
            if ([_delegate pwLoadMoreTableDataSourceIsLoading]) {
                [self removeTarget:self action:@selector(callDelegateToLoadMore) forControlEvents:UIControlEventTouchUpInside];
                _statusLabel.text = NSLocalizedString(@"Not available now...", @"Wait until it's safe to load more");
                [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(updateStatus:) userInfo:nil repeats:YES];
            } else {
                [self realCallDelegateToLoadMore];
            }
        } else
            [self realCallDelegateToLoadMore];//temporary
    } else {
        //Do nothing
    }
}
#pragma mark -
#pragma mark Dealloc
- (void)dealloc {
	
	_delegate=nil;
}
@end
