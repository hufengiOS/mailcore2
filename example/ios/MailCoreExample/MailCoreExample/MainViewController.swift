import UIKit
import MailCore

class MainViewController: UIViewController {
    
    // MARK: - UI 元素
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let versionLabel = UILabel()
    private let protocolsLabel = UILabel()
    
    private let imapButton = UIButton(type: .system)
    private let smtpButton = UIButton(type: .system)
    private let popButton = UIButton(type: .system)
    
    private let statusLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - 属性
    private var imapSession: MCOIMAPSession?
    private var smtpSession: MCOSMTPSession?
    private var popSession: MCOPOPSession?
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        displayMailCoreInfo()
    }
    
    // MARK: - UI 设置
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "MailCore2 示例"
        
        // 设置滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 设置标题标签
        titleLabel.text = "MailCore2 Swift 示例"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        // 设置版本标签
        versionLabel.text = "版本: \(MailCoreSwift.shared.version)"
        versionLabel.font = .systemFont(ofSize: 16)
        versionLabel.textAlignment = .center
        versionLabel.textColor = .secondaryLabel
        contentView.addSubview(versionLabel)
        
        // 设置协议标签
        let protocols = MailCoreSwift.shared.supportedProtocols.joined(separator: ", ")
        protocolsLabel.text = "支持的协议: \(protocols)"
        protocolsLabel.font = .systemFont(ofSize: 14)
        protocolsLabel.textAlignment = .center
        protocolsLabel.textColor = .secondaryLabel
        protocolsLabel.numberOfLines = 0
        contentView.addSubview(protocolsLabel)
        
        // 设置按钮
        imapButton.setTitle("测试 IMAP 连接", for: .normal)
        imapButton.backgroundColor = .systemBlue
        imapButton.setTitleColor(.white, for: .normal)
        imapButton.layer.cornerRadius = 8
        contentView.addSubview(imapButton)
        
        smtpButton.setTitle("测试 SMTP 连接", for: .normal)
        smtpButton.backgroundColor = .systemGreen
        smtpButton.setTitleColor(.white, for: .normal)
        smtpButton.layer.cornerRadius = 8
        contentView.addSubview(smtpButton)
        
        popButton.setTitle("测试 POP 连接", for: .normal)
        popButton.backgroundColor = .systemOrange
        popButton.setTitleColor(.white, for: .normal)
        popButton.layer.cornerRadius = 8
        contentView.addSubview(popButton)
        
        // 设置状态标签
        statusLabel.text = "准备就绪"
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        contentView.addSubview(statusLabel)
        
        // 设置活动指示器
        activityIndicator.hidesWhenStopped = true
        contentView.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        protocolsLabel.translatesAutoresizingMaskIntoConstraints = false
        imapButton.translatesAutoresizingMaskIntoConstraints = false
        smtpButton.translatesAutoresizingMaskIntoConstraints = false
        popButton.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 滾動視圖約束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 內容視圖約束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 標題標籤約束
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 版本標籤約束
            versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            versionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            versionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 協議標籤約束
            protocolsLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 10),
            protocolsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            protocolsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // IMAP 按鈕約束
            imapButton.topAnchor.constraint(equalTo: protocolsLabel.bottomAnchor, constant: 30),
            imapButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imapButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imapButton.heightAnchor.constraint(equalToConstant: 50),
            
            // SMTP 按鈕約束
            smtpButton.topAnchor.constraint(equalTo: imapButton.bottomAnchor, constant: 15),
            smtpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            smtpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            smtpButton.heightAnchor.constraint(equalToConstant: 50),
            
            // POP 按鈕約束
            popButton.topAnchor.constraint(equalTo: smtpButton.bottomAnchor, constant: 15),
            popButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            popButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            popButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 狀態標籤約束
            statusLabel.topAnchor.constraint(equalTo: popButton.bottomAnchor, constant: 30),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 活動指示器約束
            activityIndicator.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        imapButton.addTarget(self, action: #selector(testIMAPConnection), for: .touchUpInside)
        smtpButton.addTarget(self, action: #selector(testSMTPConnection), for: .touchUpInside)
        popButton.addTarget(self, action: #selector(testPOPConnection), for: .touchUpInside)
    }
    
    // MARK: - 显示信息
    private func displayMailCoreInfo() {
        print("MailCore2 版本: \(MailCoreSwift.shared.version)")
        print("支持的协议: \(MailCoreSwift.shared.supportedProtocols)")
    }
    
    // MARK: - 测试连接
    @objc private func testIMAPConnection() {
        showLoading("正在测试 IMAP 连接...")
        
        imapSession = MCOIMAPSession()
        imapSession?.hostname = "imap.gmail.com"
        imapSession?.port = 993
        imapSession?.username = "your-email@gmail.com"
        imapSession?.password = "your-password"
        imapSession?.connectionType = .TLS
        
        imapSession?.connectSwift(
            hostname: "imap.gmail.com",
            port: 993,
            username: "your-email@gmail.com",
            password: "your-password"
        ) { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoading()
                if let error = error {
                    self?.showError("IMAP 连接失败: \(error.localizedDescription)")
                } else {
                    self?.showSuccess("IMAP 连接成功！")
                }
            }
        }
    }
    
    @objc private func testSMTPConnection() {
        showLoading("正在测试 SMTP 连接...")
        
        smtpSession = MCOSMTPSession()
        smtpSession?.hostname = "smtp.gmail.com"
        smtpSession?.port = 587
        smtpSession?.username = "your-email@gmail.com"
        smtpSession?.password = "your-password"
        smtpSession?.connectionType = .StartTLS
        
        smtpSession?.connectSwift(
            hostname: "smtp.gmail.com",
            port: 587,
            username: "your-email@gmail.com",
            password: "your-password"
        ) { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoading()
                if let error = error {
                    self?.showError("SMTP 连接失败: \(error.localizedDescription)")
                } else {
                    self?.showSuccess("SMTP 连接成功！")
                }
            }
        }
    }
    
    @objc private func testPOPConnection() {
        showLoading("正在测试 POP 连接...")
        
        popSession = MCOPOPSession()
        popSession?.hostname = "pop.gmail.com"
        popSession?.port = 995
        popSession?.username = "your-email@gmail.com"
        popSession?.password = "your-password"
        popSession?.connectionType = .TLS
        
        popSession?.connectSwift(
            hostname: "pop.gmail.com",
            port: 995,
            username: "your-email@gmail.com",
            password: "your-password"
        ) { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoading()
                if let error = error {
                    self?.showError("POP 连接失败: \(error.localizedDescription)")
                } else {
                    self?.showSuccess("POP 连接成功！")
                }
            }
        }
    }
    
    // MARK: - UI 辅助方法
    private func showLoading(_ message: String) {
        statusLabel.text = message
        activityIndicator.startAnimating()
        imapButton.isEnabled = false
        smtpButton.isEnabled = false
        popButton.isEnabled = false
    }
    
    private func hideLoading() {
        activityIndicator.stopAnimating()
        imapButton.isEnabled = true
        smtpButton.isEnabled = true
        popButton.isEnabled = true
    }
    
    private func showSuccess(_ message: String) {
        statusLabel.text = message
        statusLabel.textColor = .systemGreen
    }
    
    private func showError(_ message: String) {
        statusLabel.text = message
        statusLabel.textColor = .systemRed
    }
} 