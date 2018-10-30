# EWWebViewTableViewCell
<h3>Cell中添加WKWebView,Cell高度根据WebView加载页面自适应</h3>


主要功能代码:
----
#### 1.Cell内实现WKNavigationDelegate中didFinish方法,通过document.body.offsetHeight字段获取加载页面Height.通过document.readyState字段判断页面加载完成,发送通知.
```
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
```
#### 2.tableView类获取通知,调用更新Cell高度方法
```
@objc private func reloadWebViewCell(_ notification: NSNotification){
    let info: Int = notification.object as! Int
    /// 修改cell高度
    self.webViewCellHeight = info
    /*  重置tableViewCell.height.
    如果使用reloadData()或者reloadRow()会导致webView重新加载.陷入循环.
    使用beginUpdates只更新frame,并不重新加载
    */
    tableView.beginUpdates()
    tableView.endUpdates()
}
```
    

![效果图预览](https://github.com/WangLiquan/EWWebViewTableViewCell/raw/master/images/demonstration.gif)
