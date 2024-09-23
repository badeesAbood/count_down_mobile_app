//
//  ViewController.swift
//  countDown
//
//  Created by MASARAT on 22/9/2024.
//

import UIKit

class MainViewController: UIViewController {
    var timer: Timer?
    var countdownDuration: TimeInterval = 0 // Duration in seconds
    var isTimerStartd = false
    private var currnetTime = "00:00"
    var label : UILabel = {
        var l = UILabel()
        l.text = "Timer"
        l.font = .systemFont(ofSize: 32 , weight: .bold)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    var timerLabel = UILabel()
    private let  resetButton : UIButton = {
       var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("RESET", for: .normal)
        button.configuration?.titlePadding = 15
        button.backgroundColor = UIColor(hex: "#303030")
        button.setTitleColor(.white , for: .normal)
        button.layer.cornerRadius = 10
        
        return button
        
    }()
    var startPauseButton = UIButton()
    private let timePicker : UIDatePicker = {
       var picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.minimumDate = .now
        picker.tintColor = .white
        picker.backgroundColor = .white
        return picker
    }()
    private let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#184D6C")!
        view.layer.cornerRadius = 40
        view.translatesAutoresizingMaskIntoConstraints = false
    
        return view
    }()
    
    var circularView = CircularProgressView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 200)))
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        
        view.addSubview(label)
        
        timerLabel.text = currnetTime
        timerLabel.textColor = .white
        timerLabel.font = .systemFont(ofSize: 55 , weight: .bold)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timerLabel)
        
       
        view.addSubview(resetButton)
        
        
        view.addSubview(containerView)
        
        view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(onSelectTime), for: .valueChanged)

        circularView.translatesAutoresizingMaskIntoConstraints = false
        circularView.setProgressColor =  UIColor(hex: "#36DCF8")!
        circularView.setTrackColor = UIColor(hex: "#11374D")!
        
        containerView.addSubview(circularView)

        
        startPauseButton.setImage(UIImage(named: "playIcon")?.resized(to: CGSize(width: 50, height: 50)), for: .normal)
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        startPauseButton.addTarget(self, action: #selector(onStartTimer), for: .touchUpInside)
        
        
        resetButton.addTarget(self, action: #selector(onResetTimer), for: .touchUpInside)
        containerView.addSubview(startPauseButton)
        setUpConstraints()
        
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50) ,
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 20)
        
        ])
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            timePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 20)
        
        ])
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 30) ,
            timerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor , constant: 20)
        ])
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: timerLabel.bottomAnchor , constant: 100) ,
            resetButton.centerXAnchor.constraint(equalTo:  timerLabel.centerXAnchor , constant: 20) ,
            resetButton.widthAnchor.constraint(equalToConstant: 120),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
                    containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                  containerView.widthAnchor.constraint(equalToConstant: 350),
              ])
        
        NSLayoutConstraint.activate([
            circularView.topAnchor.constraint(equalTo: containerView.topAnchor ,constant:  80) ,
            circularView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor , constant: -100)
        ])
        
        NSLayoutConstraint.activate([
            startPauseButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            startPauseButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    
    }
    
    
    @objc func onStartTimer(){
        if countdownDuration == 0 {
            return
        }
            startPauseButton.setImage(UIImage(named: "pause")?.resized(to: CGSize(width: 50, height: 50)), for: .normal)
            circularView.setProgressWithAnimation(duration: countdownDuration , value: 1)
            isTimerStartd = !isTimerStartd
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }

    }
    
    @objc func updateTimer() {
        if countdownDuration > 0 {
            countdownDuration -= 1 // Decrease countdown duration by 1 second
            
            // Convert to hours, minutes, and seconds
            let hours = Int(countdownDuration) / 3600
            let minutes = (Int(countdownDuration) % 3600) / 60
            let seconds = Int(countdownDuration) % 60
            
            // Update the timerLabel
            timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            // Timer finished
            timer?.invalidate()
            timer = nil
            timerLabel.text = "Time's up!"
            
        }
    }
    @objc func onResetTimer() {
        circularView.stopAnimation()
        startPauseButton.setImage(UIImage(named: "playIcon")?.resized(to: CGSize(width: 50, height: 50)), for: .normal)
        timer?.invalidate()
        timer = nil
        countdownDuration = 0
        timerLabel.text = "00:00:00" // R
    }

    
    @objc func onSelectTime(_ sender: UIDatePicker){
        let selectedTime = sender.date
          let currentTime = Date() // Get the current date and time

          countdownDuration = selectedTime.timeIntervalSince(currentTime)

          let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute , .second], from: currentTime, to: selectedTime)

        if let hour = components.hour, let minute = components.minute , let seconds = components.second {
             timerLabel.text = String(format: "%02d:%02d:%02d", hour, minute ,seconds)
          }
    }


 
}


extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine what ratio to use to ensure the image is scaled correctly
        let ratio = min(widthRatio, heightRatio)
        
        // Calculate the new size based on the ratio
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        // Resize the image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
