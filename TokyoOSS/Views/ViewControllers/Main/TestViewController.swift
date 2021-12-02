import UIKit
import WebKit

class TestViewController: UIViewController {
    var webView:WKWebView!
    override func loadView() {
        // 2 WKWebViewConfiguration の生成
              let webConfiguration = WKWebViewConfiguration()
              // 3 WKWebView に Configuration を引き渡し initialize
              webView = WKWebView(frame: .zero, configuration: webConfiguration)
              // 4 WKUIDelegate の移譲先として self を登録
              webView.uiDelegate = self
              // 5 WKNavigationDelegate の移譲先として self を登録
              webView.navigationDelegate = self
              // 6 view に webView を割り当て
        view = webView
//        view.addSubview(webView)
//        webView.anchor(top:view.topAnchor,leading: view.leadingAnchor,bottom: view.bottomAnchor,trailing: view.trailingAnchor,paddingBottom: 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 7 URLオブジェクトを生成
             let myURL = URL(string:"https://tokyo-oss-ad760.web.app")
             // 8 URLRequestオブジェクトを生成
             let myRequest = URLRequest(url: myURL!)

             // 9 URLを WebView にロード
             webView.load(myRequest)
    }



}
extension TestViewController: WKUIDelegate {
    // delegate
}

// MARK: - 11 WKWebView WKNavigation delegate
extension TestViewController: WKNavigationDelegate {
    // delegate
}
