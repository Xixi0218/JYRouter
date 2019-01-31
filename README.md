# JYRouter 一句话实现各个页面跳转,可解决代码冗余


## 1.想使用这个路由首先每个控制器需要遵守Routable协议并且实现它的协议

## 2.相对比  
     之前跳转控制器都要
	 let myquestion = MSMyQuestionViewController()
	 self.navigationController?.pushViewController(myquestion, animated: true)
	 现在只要
	 Router.routeTo("MSMyQuestionViewController", params: params)
	 方便之后跟服务器匹配
## 3.他有2种传参模式  
	1.var params = Parameter()  
	  params["title"] = "Keyon"  
	  params["userId"] = "123"  
	  Router.routeTo("BViewController", params: params)  
	2.params["title"] = "Keyon"  
	  params["userId"] = "123"  
	  Router.routeTo("BViewController?title=Keyon&userId=123", params: params)  

## 4.读取参数有优先级
    如果2个都传了会进行混合,而且2个有相同的字段那么会优先读取自身传进去的参数

## 5.使用(因为JYRouter被使用了)
     pod 'YJYRouter'
