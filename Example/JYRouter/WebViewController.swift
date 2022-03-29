//
//  WebViewController.swift
//  JYRouter
//
//  Created by Keyon on 2019/1/23.
//  Copyright © 2019 Keyon. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKUIDelegate {

	private var webView:WKWebView!
	
	var navTitle:String?
	var urlStr:String?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = navTitle
		self.setupWebView()
    }
	
	private func setupWebView() {
		let configuration = WKWebViewConfiguration()
		let preferences = WKPreferences()
		preferences.javaScriptCanOpenWindowsAutomatically = true
		configuration.preferences = preferences
		webView = WKWebView(frame: self.view.bounds, configuration: configuration)
		webView.backgroundColor = UIColor.white
		self.view.addSubview(webView)
		
		if let urlStr = urlStr {
			var request:URLRequest!
			if let url = URL(string: urlStr) {
				if !UIApplication.shared.canOpenURL(url) {
					let _urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
					let secondUrl = URL(string: _urlStr!)
					request = URLRequest(url: secondUrl!)
				} else {
					request = URLRequest(url: url)
				}
			}
			webView.load(request)
		}
	}
	
	
	
	//MARK: -- back是我们和前端商量好的方法名 注册之后一定要注意removeScriptMessageHandlerForName
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		webView.navigationDelegate = self
		webView.uiDelegate = self
		let userContentController = webView.configuration.userContentController
		userContentController.add(self, name: "back")
		webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "title" {
			if let object = object as? WKWebView {
				if object == self.webView {
					if let navTitle = self.navTitle {
						self.title = navTitle
					} else {
						self.title = self.webView.title
					}
				}
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		let userContentController = webView.configuration.userContentController
		userContentController.removeScriptMessageHandler(forName: "back")
		webView.removeObserver(self, forKeyPath: "title", context: nil)
	}
	
	deinit {
		clear()
	}
	
	private func clear() {
		let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
		let dateFrom = Date(timeIntervalSince1970: 0)
		WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) {
		}
	}
	
}

extension WebViewController:WKNavigationDelegate {
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		let url = navigationAction.request.url?.absoluteString
		if let url = url {
			debugPrint(url)
		}
		decisionHandler(.allow)
	}
	
	func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let space = challenge.protectionSpace
		if let serverTrust = space.serverTrust {
			let credential = URLCredential(trust: serverTrust)
			completionHandler(.useCredential,credential)
		} else {
			completionHandler(.useCredential,nil)
		}
	}
}

extension WebViewController:WKScriptMessageHandler {
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		debugPrint(message.name, message.body)
		if (message.name == "back") {
			//可以做相应的处理
		}
	}
}
