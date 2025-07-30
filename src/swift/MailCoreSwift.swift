import Foundation
import MailCore

// MARK: - Swift 包装器类
/// MailCore2 的 Swift 包装器，提供更现代的 Swift API
@objc public class MailCoreSwift: NSObject {
    
    // MARK: - 单例
    public static let shared = MailCoreSwift()
    
    private override init() {
        super.init()
    }
    
    // MARK: - 版本信息
    /// 获取 MailCore2 版本信息
    @objc public var version: String {
        return "0.6.5"
    }
    
    /// 获取支持的协议列表
    @objc public var supportedProtocols: [String] {
        return ["IMAP", "POP", "SMTP", "NNTP"]
    }
}

// MARK: - IMAP 会话扩展
extension MCOIMAPSession {
    
    /// 使用 Swift 风格的错误处理连接 IMAP 服务器
    /// - Parameters:
    ///   - hostname: 服务器主机名
    ///   - port: 端口号
    ///   - username: 用户名
    ///   - password: 密码
    ///   - completion: 完成回调
    @objc public func connectSwift(
        hostname: String,
        port: UInt32,
        username: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        self.hostname = hostname
        self.port = port
        self.username = username
        self.password = password
        
        let operation = self.checkAccountOperation()
        operation?.start { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    /// 获取邮件夹列表
    /// - Parameter completion: 完成回调
    @objc public func fetchFoldersSwift(completion: @escaping ([MCOIMAPFolder]?, Error?) -> Void) {
        let operation = self.fetchAllFoldersOperation()
        operation?.start { error, folders in
            DispatchQueue.main.async {
                completion(folders, error)
            }
        }
    }
    
    /// 获取邮件列表
    /// - Parameters:
    ///   - folder: 邮件夹名称
    ///   - completion: 完成回调
    @objc public func fetchMessagesSwift(
        folder: String,
        completion: @escaping ([MCOIMAPMessage]?, Error?) -> Void
    ) {
        let operation = self.fetchMessagesOperation(withFolder: folder)
        operation?.start { error, messages in
            DispatchQueue.main.async {
                completion(messages, error)
            }
        }
    }
}

// MARK: - SMTP 会话扩展
extension MCOSMTPSession {
    
    /// 使用 Swift 风格的错误处理连接 SMTP 服务器
    /// - Parameters:
    ///   - hostname: 服务器主机名
    ///   - port: 端口号
    ///   - username: 用户名
    ///   - password: 密码
    ///   - completion: 完成回调
    @objc public func connectSwift(
        hostname: String,
        port: UInt32,
        username: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        self.hostname = hostname
        self.port = port
        self.username = username
        self.password = password
        
        let operation = self.checkAccountOperation()
        operation?.start { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    /// 发送邮件
    /// - Parameters:
    ///   - messageData: 邮件数据
    ///   - completion: 完成回调
    @objc public func sendMessageSwift(
        messageData: Data,
        completion: @escaping (Error?) -> Void
    ) {
        let operation = self.sendOperation(with: messageData)
        operation?.start { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}

// MARK: - POP 会话扩展
extension MCOPOPSession {
    
    /// 使用 Swift 风格的错误处理连接 POP 服务器
    /// - Parameters:
    ///   - hostname: 服务器主机名
    ///   - port: 端口号
    ///   - username: 用户名
    ///   - password: 密码
    ///   - completion: 完成回调
    @objc public func connectSwift(
        hostname: String,
        port: UInt32,
        username: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        self.hostname = hostname
        self.port = port
        self.username = username
        self.password = password
        
        let operation = self.checkAccountOperation()
        operation?.start { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    /// 获取邮件列表
    /// - Parameter completion: 完成回调
    @objc public func fetchMessagesSwift(completion: @escaping ([MCOPOPMessageInfo]?, Error?) -> Void) {
        let operation = self.fetchMessagesOperation()
        operation?.start { error, messages in
            DispatchQueue.main.async {
                completion(messages, error)
            }
        }
    }
}

// MARK: - 邮件构建器扩展
extension MCOMessageBuilder {
    
    /// 创建简单的文本邮件
    /// - Parameters:
    ///   - from: 发件人
    ///   - to: 收件人
    ///   - subject: 主题
    ///   - body: 正文
    /// - Returns: 邮件数据
    @objc public static func createSimpleMessage(
        from: String,
        to: String,
        subject: String,
        body: String
    ) -> Data? {
        let builder = MCOMessageBuilder()
        builder.header.from = MCOAddress(mailbox: from)
        builder.header.to = [MCOAddress(mailbox: to)]
        builder.header.subject = subject
        builder.text = body
        
        return builder.data()
    }
    
    /// 创建带附件的邮件
    /// - Parameters:
    ///   - from: 发件人
    ///   - to: 收件人
    ///   - subject: 主题
    ///   - body: 正文
    ///   - attachments: 附件列表
    /// - Returns: 邮件数据
    @objc public static func createMessageWithAttachments(
        from: String,
        to: String,
        subject: String,
        body: String,
        attachments: [MCOAttachment]
    ) -> Data? {
        let builder = MCOMessageBuilder()
        builder.header.from = MCOAddress(mailbox: from)
        builder.header.to = [MCOAddress(mailbox: to)]
        builder.header.subject = subject
        builder.text = body
        
        for attachment in attachments {
            builder.addAttachment(attachment)
        }
        
        return builder.data()
    }
}

// MARK: - 错误处理扩展
extension NSError {
    
    /// MailCore2 错误域
    @objc public static let mailCoreErrorDomain = "com.mailcore.error"
    
    /// 创建 MailCore2 错误
    /// - Parameters:
    ///   - code: 错误代码
    ///   - description: 错误描述
    /// - Returns: 错误对象
    @objc public static func mailCoreError(code: Int, description: String) -> NSError {
        return NSError(
            domain: mailCoreErrorDomain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: description]
        )
    }
} 