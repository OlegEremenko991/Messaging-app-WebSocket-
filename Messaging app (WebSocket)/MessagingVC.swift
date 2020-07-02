//
//  ViewController1.swift
//  Messaging app (WebSocket)
//
//  Created by Олег Еременко on 02.07.2020.
//  Copyright © 2020 Oleg Eremenko. All rights reserved.
// TARGET: ws://pm.tada.team/ws?name=test123

import UIKit
import Starscream
import SwiftyJSON

class MessagingVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var connectionButton: UIBarButtonItem!
    
    var username = ""

    var socket: WebSocket!
    var isConnected = false
    
    let server = WebSocketServer()
    
    var messageArray: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        socket = WebSocket(request: URLRequest(url: URL(string: "ws://pm.tada.team/ws?name=" + "\(username)")!))
        socket = WebSocket(request: URLRequest(url: URL(string: "ws://pm.tada.team/ws?name=testUser")!))
        socket.delegate = self
        socket.connect()
        
        // Обрабатываем тап по таблице, чтобы вернуть вниз поле для ввода текста
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
    }
    deinit {
      socket.disconnect()
      socket.delegate = nil
    }
    
    // Возвращаем вниз поле для ввода текста
    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    
    // Поднимаем над клавиатурой поле для ввода текста
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 295
            self.view.layoutIfNeeded()
        }
    }
    // Опускаем поле для ввода текста
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func sendMessage(_ message: String) {
      socket.write(string: message)
        print("Send this: \(message)")
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        messageTextfield.endEditing(false)
        sendMessage(messageTextfield.text!)
        messageTextfield.text = ""
    }
    
    func messageRecieved(jsonMessage: String){
        if let data = jsonMessage.data(using: .utf8) {
            if let json = try? JSON(data: data) {
                let resultName = json["name"].stringValue
                let resultText = json["text"].stringValue
                let testMessage = Message(name: resultName, text: resultText)
                messageArray.append(testMessage)
            }
        }
    }
    
    @IBAction func connectionPressed(_ sender: UIBarButtonItem) {
        if isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
}


