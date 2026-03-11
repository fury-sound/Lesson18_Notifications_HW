//
//  MainViewController.swift
//  Lesson18_Notifications_HW
//
//  Created by Valery Zvonarev on 08.03.2026.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Properties
    private var buttonBottom: NSLayoutConstraint?
    private var textFieldYValue: NSLayoutConstraint?

    // MARK: - Subviews
    private lazy var myLabel : UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        return label
    }()

    private lazy var myTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter text"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 10
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 12
        return textField
    }()

    private lazy var myButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap me", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewProperties()
        setupSubviews()
        setupConstraints()
        setupNotifications()
        setupGestures()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Layout
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupViewProperties(){
        view.backgroundColor = .systemBackground

    }

    private func setupGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didSingleTap))
        view.addGestureRecognizer(singleTap)
    }

    private func setupSubviews() {
        myTextField.delegate = self
//        myTextField.becomeFirstResponder()
        myTextField.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        myButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        [myLabel, myTextField, myButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupConstraints(){
        buttonBottom = myButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        textFieldYValue = myTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        guard let buttonBottom, let textFieldYValue else { return }
        NSLayoutConstraint.activate([
            myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            textFieldYValue,
            myTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            myTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            myTextField.heightAnchor.constraint(equalToConstant: 50),
            //            myButton.topAnchor.constraint(equalTo: myTextField.bottomAnchor, constant: 100),
            myButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myButton.heightAnchor.constraint(equalToConstant: 50),
            myButton.widthAnchor.constraint(equalToConstant: 150),
            buttonBottom
        ])
    }

    @objc private func didShowKeyboard(_ notification: Notification) {
        //        print("keyboard is showing")
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        //        print(keyboardFrame.height, keyboardFrame.width)
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom + 10
        buttonBottom?.constant = -bottomInset
        //        let buttonTop = bottomInset + 50 + 20
        let buttonTopY = view.bounds.height - bottomInset - 50
        //        print(view.bounds.height, view.center.y, myTextField.frame.maxY, myButton.frame.minY, bottomInset, buttonTopY)
        //        if (view.center.y + 25) > buttonTopConstant {
        if (myTextField.frame.maxY + 25) > buttonTopY {
            let newYValue = buttonTopY - view.center.y + 25
            textFieldYValue?.constant = -newYValue
            //            print("pinch", myTextField.frame.maxY)
        }

        //        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseOut]) {
        UIView.animate() {
            self.view.layoutIfNeeded()
            //            print("myButton.frame.minY", self.myButton.frame.minY)
        }
    }

    @objc private func willHideKeyboard(_ notification: Notification) {
        print("keyboard is hiding")
        //        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 1.25
        //        let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int ?? 0
        ////        let animationCurve = UIView.AnimationOptions(rawValue: curveValue << 16)
        //        let animationOptions = UIView.AnimationOptions(rawValue: UInt(curveValue))

        self.buttonBottom?.constant = -50
        self.textFieldYValue?.constant = 0

        //        UIView.performWithoutAnimation {
        //            self.view.layoutIfNeeded()
        //        }

        //        UIView.animate(withDuration: duration, delay: 0, options: animationOptions) {
        UIView.animate() {
            self.view.layoutIfNeeded()
        }
        //        UIView.animate(withDuration: 2.5, delay: 0, options: [.curveEaseOut]) {
        //            self.buttonBottom?.constant = -50
        //            self.textFieldYValue?.constant = 0
        //            self.view.layoutIfNeeded()
        //        }
    }

    @objc private func textFieldTapped() {
        myTextField.becomeFirstResponder()
    }

    @objc private func didSingleTap(_ gesture: UITapGestureRecognizer) {
        //        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut]) {
        self.myTextField.resignFirstResponder()
        //        }
    }

    @objc private func didTapButton() {
        let myText: String
        if let text = myTextField.text, !text.isEmpty {
            myText = text
        } else {
            myText = "No text"
        }
        print(myText)
        myLabel.text = myText
    }
}

extension MainViewController: UITextFieldDelegate {
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        print("editing completed")
    //    }

//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        textField.becomeFirstResponder()
//        return true
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("in textFieldShouldReturn")
        myTextField.resignFirstResponder()
        return true
    }
}

#Preview {
    MainViewController()
}


