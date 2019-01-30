# JYRouter


1.想使用这个路由首先每个控制器需要遵守Routable协议并且实现它的协议


2.他有2种传参模式
	1.var params = Parameter()
	   params["title"] = "Keyon"
	   params["userId"] = "123"
	   Router.routeTo("BViewController", params: params)
	2.params["title"] = "Keyon"
	   params["userId"] = "123"
	   Router.routeTo("BViewController?title=Keyon&userId=123", params: params)

3.读取参数有优先级
    如果2个都传了,而且2个有相同的字段那么会优先读取自身传进去的参数
