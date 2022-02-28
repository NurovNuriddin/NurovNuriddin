//
//  ViewController.swift
//  uiview
//
//  Created by Nuriddin Nurov on 13/01/22.
//
import UIKit
import AVFoundation
class ViewController: UIViewController {
    var array = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"," "]
    var step = 0
    let customView1 = UIView()
    let text = UILabel()
    let ressBtn = UIButton()
    let undoBut = UIButton()
    var arr:[Tags] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        ressButton()
        undoButton()
        view.backgroundColor = .systemFill
        _ = customView1.frame.width
        _ = (UIScreen.main.bounds.height)
        addTestViews()
        view.addSubview(text)
        text.text = "0"
        text.textColor = .systemMint
        text.font = UIFont(name: "AvenirNextCondensed-Heavy", size: (UIScreen.main.bounds.width)/10)
        text.frame = CGRect(x: 0, y: ((UIScreen.main.bounds.width)*10/100), width: UIScreen.main.bounds.width, height: ((UIScreen.main.bounds.width)*30/100))
        text.textAlignment = .center
    }
    func addTestViews() {
        customView1.backgroundColor = .systemMint
        customView1.layer.cornerRadius = 15
        customView1.frame = CGRect(x: ((UIScreen.main.bounds.width)*2/100), y: ((UIScreen.main.bounds.height)*5/100), width: ((UIScreen.main.bounds.width)*96/100), height:((UIScreen.main.bounds.width)*96/100))
        view.addSubview(customView1)
        customView1.center = view.center
        array.shuffle()
        addButton()
    }
    func addButton(){
        var x = Int(customView1.frame.width)*2/100
        var y = Int(customView1.frame.width)*2/100
        var count = 0
        for _ in 0...3 {
            for _ in 0...3 {
                let button = UIButton()
                button.backgroundColor = .darkGray
                button.frame = CGRect (x: x, y: y, width: Int((customView1.frame.width)*24/100), height: Int((customView1.frame.width)*24/100))
                customView1.addSubview(button)
                button.layer.cornerRadius = 15
                button.tag = count + 1
                button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Heavy", size: (button.frame.width)/2)
                button.setTitle(array[count], for: .normal)
                if array[count] == " "{
                    button.backgroundColor = .clear
                }
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                x += Int(button.frame.width)+1
                count += 1
            }
            y += x*24/100+3
            x = Int(customView1.frame.width)*2/100
        }
    }
    func ressButton(){
        ressBtn.setBackgroundImage(UIImage(named: "restart"), for: .normal)
        ressBtn.frame = CGRect(x: ((UIScreen.main.bounds.width)/2 - ((UIScreen.main.bounds.width)/12)), y: ((UIScreen.main.bounds.height)*80/100), width: ((UIScreen.main.bounds.width)/6), height: ((UIScreen.main.bounds.width)/6))
        view.addSubview(ressBtn)
        ressBtn.addTarget(self, action: #selector(ressTapped), for: .touchUpInside)
    }
    func undoButton(){
        undoBut.setBackgroundImage(UIImage(named: "undo"), for: .normal)
        undoBut.frame = CGRect(x: ((UIScreen.main.bounds.width)/2 + ((UIScreen.main.bounds.width)/4)), y: ((UIScreen.main.bounds.height)*80/100), width: ((UIScreen.main.bounds.width)/6), height: ((UIScreen.main.bounds.width)/6))
        view.addSubview(undoBut)
        undoBut.addTarget(self, action: #selector(undoTapped), for: .touchUpInside)
        undoBut.isEnabled = false
    }
    @objc func undoTapped(sender: UIButton){
        if arr.count != 0{
            let tag = arr[arr.count - 1]
            if let btn = customView1.viewWithTag(tag.btnOneTag ?? 0) as? UIButton,
               let btn2 = customView1.viewWithTag(tag.btnTwoTag ?? 0) as? UIButton{
                swapView(btn: btn, sender: btn2, isUndo: true)
                arr.removeLast()
            }
        }
        if arr.count == 0 {
            self.undoBut.isEnabled = false
        }
    }
    @objc func ressTapped(sender: UIButton){
        AppDelegate.resetViewController()
        AudioServicesPlaySystemSound (1305)
    }
    @objc func buttonTapped(sender:UIButton){
        if sender.currentTitle != " "{
            if let btn = customView1.viewWithTag(sender.tag - 1) as? UIButton, btn.currentTitle == " "{
                swapView(btn: btn, sender: sender, isUndo: false)
            } else if let btn = customView1.viewWithTag(sender.tag - 4) as? UIButton, btn.currentTitle == " "{
                swapView(btn: btn, sender: sender, isUndo: false)
            } else if let btn =  customView1.viewWithTag(sender.tag + 1) as? UIButton, btn.currentTitle == " "{
                swapView(btn: btn, sender: sender, isUndo: false)
            } else if let btn =  customView1.viewWithTag(sender.tag + 4) as? UIButton, btn.currentTitle == " "{
                swapView(btn: btn, sender: sender, isUndo: false)
            }
        }
    }
    func swapView(btn:UIButton, sender:UIButton, isUndo:Bool){
        if !isUndo {
            arr.append(Tags(btnOneTag: btn.tag, btnTwoTag: sender.tag))
            self.undoBut.isEnabled = true
        }
        UIView.animate(withDuration: 0.2){
        (sender.tag, btn.tag) = (btn.tag, sender.tag)
        (btn.center, sender.center) = (sender.center, btn.center)
        }
        step = isUndo ? step - 1 : step + 1
        text.text = String(step)
        AudioServicesPlaySystemSound (1306)
    }
}
struct Tags {
    var btnOneTag:Int?
    var btnTwoTag:Int?
}
