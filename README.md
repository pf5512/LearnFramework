LearnFramework
==============

this repository, I will set some three framework that have learned with some notes, Improve my Object-c skills. 
/**
*  @brief  这里只是简单的介绍, 以后想单独对每个开源库专门写一个文档. (先标记)
*/

1, SDWebImage 缓存图片库,
请求图片数据, 成功缓存到memory或者disk之上,再次http请求,就会优先查询memory/disk是否有缓存数据。 
libwebp 这个同时支持有损压缩和无损压缩两个方式(google推出)

2, MBProgressHUD 加载数据
各种各样加载数据背景,功能很全, CGContext类 还不是很熟悉, 先做个标记,继续学习

3, EGOTableViewPullRefresh
下拉刷新数据, 拖动数据页面时候, scrollview触发滑动delegate数据scrollViewDidScroll,检查数据是否加载完成.

4, PWLoadMoreTableFooter
点击加载数据, tableview的footview添加view, 检查数据源, 对footview的uiview添加点击触摸事件,触发触摸事件加载更多数据

5, asi-http-request-master
网络开源库 ASI-http 学习(没看完, 先标记)

6, AFNetworking 2.0
NSURLSession代替NSURLConnection(Apple ios 7新推荐), NSURLSession三个子类(NSURLSessionDataTask获取数据, NSURLSessionUploadTask上传数据, NSURLSessionDownloadTask下载数据). AFNetworking采用的还是CF族,所以相对于更加底层的asi来说，可能处理数据性能差点, AFNetworking还有一个比较重要的特点是 只支持异步, 同步获取数据的话 需要自己手动加, AFNetworking 还支持缓存图片等功能(uikit+AFNetworking)。

7, coredataBooks(apple 官网demo)
这个是apple官网退出来学习coredata的demo,里面主要是managedObjectContext相关类的使用, 也包括了storyboard的使用, NSFetchedResultsController类对coredata的操控,以及NSFetchedResultsController类的回调方法等。在其中的详细页面 NSUndoManager (nsinvocation到Undo栈中), 运用非常巧妙. 