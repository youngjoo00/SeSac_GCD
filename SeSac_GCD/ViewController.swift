//
//  ViewController.swift
//  SeSac_GCD
//
//  Created by youngjoo on 1/25/24.
//

import UIKit

class ViewController: UIViewController {

    let topView = UIView()
    let syncBtn = UIButton()
    let asyncBtn = UIButton()
    let oneImageView = UIImageView()
    let twoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        configureView()
    }

    @objc func didSyncBtnTapped() {
        // 이 함수도 마찬가지로 serial + sync 형태로 진행
        syncDownloadImage(oneImageView, value: "one")
        syncDownloadImage(twoImageView, value: "two")
    }
    
    @objc func didAsyncBtnTapped() {
        // 여기 함수 호출 순서는 serial + sync 니까 순서대로 메인이 진행함
        print("one : 함수 호출할게요")
        asyncDownloadImage(oneImageView, value: "one")
        print("two : 함수 호출할게요")
        asyncDownloadImage(twoImageView, value: "two")
    }
}

extension ViewController {
    
    func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(topView)
        topView.addSubview(syncBtn)
        topView.addSubview(asyncBtn)
        view.addSubview(oneImageView)
        view.addSubview(twoImageView)
        
        topView.frame = CGRect(x: 16, y: 50, width: UIScreen.main.bounds.width - 32, height: 50)
        syncBtn.frame = CGRect(x: 0, y: 0, width: topView.frame.width/2, height: 50)
        asyncBtn.frame = CGRect(x: syncBtn.frame.width, y: 0, width: topView.frame.width/2, height: 50)
        oneImageView.frame = CGRect(x: UIScreen.main.bounds.width/4, y: 200, width: 200, height: 200)
        twoImageView.frame = CGRect(x: UIScreen.main.bounds.width/4, y: 500, width: 200, height: 200)
        
        syncBtn.configuration = .myBtnStyle(title: "Sync", baseBackgorundColor: .systemFill, baseForegroundColor: .systemBlue)
        asyncBtn.configuration = .myBtnStyle(title: "Async", baseBackgorundColor: .systemMint, baseForegroundColor: .systemBlue)
        
        syncBtn.addTarget(self, action: #selector(didSyncBtnTapped), for: .touchUpInside)
        asyncBtn.addTarget(self, action: #selector(didAsyncBtnTapped), for: .touchUpInside)
        
        oneImageView.image = UIImage(systemName: "star")
        twoImageView.image = UIImage(systemName: "star")
    }
    
    // serial: 혼자서 queue에 쌓여있는 일을, sync: 순차적으로 진행한다.
    func syncDownloadImage(_ imageView: UIImageView, value: String) {
        
        let url = Nasa.randomImageURL
        
        do {
            let data = try Data(contentsOf: url)
            imageView.image = UIImage(data: data)
        } catch {
            imageView.image = UIImage(systemName: "star.fill")
        }
        
    }
    
    // concurrent: 여럿이서 queue 쌓여있는 일을, async: 순서에 상관없이 제각각 처리한다.
    func asyncDownloadImage(_ imageView: UIImageView, value: String) {
        
        // 1.
        print("\(value) : 1")
        let url = Nasa.randomImageURL
        
        // try-catch 문을 깨지 않기 위해 바깥에서 global 에게 일을 수행시킴
        DispatchQueue.global().async {
            do {
                // 3.
                print("\(value) : 3")
                let data = try Data(contentsOf: url)
                
                // 근데 뷰는 무조건 메인쓰레드 시켜야함!!!!!!!!!!!!!!!!
                DispatchQueue.main.async {
                    // 4.
                    print("\(value) : 4")
                    imageView.image = UIImage(data: data)
                }
            } catch {
                imageView.image = UIImage(systemName: "star.fill")
            }
        }
        // 2.
        print("\(value) : 222222함수 끝났어!!!!!!!")
        print("\(value) : 222222함수 끝났어!!!!!!!")
        print("\(value) : 222222함수 끝났어!!!!!!!")
        print("\(value) : 222222함수 끝났어!!!!!!!")
        print("\(value) : 222222함수 끝났어!!!!!!!")
        print("\(value) : 222222함수 끝났어!!!!!!!")
    }
}
