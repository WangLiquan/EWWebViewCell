//
//  EWWebViewTableViewCell.swift
//  EWWebViewCell
//
//  Created by Ethan.Wang on 2018/10/29.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit
import WebKit

class EWWebViewTableViewCell: UITableViewCell {
    static let identifier = "EWWebViewTableViewCell"

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        drawMyView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawMyView() {
        webView.navigationDelegate = self
        self.addSubview(webView)
        webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.height)
    }
    func setData(webUrl: String){
        let url = URL(string: webUrl)
        if let url = url {
            self.webView.load(URLRequest(url: url))
        }
    }
}

extension EWWebViewTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// 获取完成页面的Height
        webView.evaluateJavaScript("document.body.offsetHeight") { (obj, error) in
            guard let height = obj as? Int else { return }
            self.webView.frame.size.height = CGFloat(height)
        }
        /// 当确认页面加载完成时通知TableView修改Cell高度
        self.webView.evaluateJavaScript("document.readyState") { (obj, complete) in
            if obj as? String == "complete" && !self.webView.isLoading{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "webViewHeightCallBack"), object: self.webView.frame.size.height)
            }
        }
    }

}
