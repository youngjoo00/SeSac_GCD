//
//  GCDTestViewController.swift
//  SeSac_GCD
//
//  Created by youngjoo on 1/25/24.
//

import UIKit

class GCDTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //serial_sync()
        //serial_async()
        //concurrent_sync()
        concurrent_async()
    }
    

}

extension GCDTestViewController {
    
    // 여기는 일반적으로 사용하는 방식이라서 간단하다.
    // serial: 혼자서 큐에 모여있는 일을, sync: 순차적으로 해결한다.
    func serial_sync() {
        print("Start")
        
        for i in 1...10 {
            print(i, terminator: " ")
        }
        
        for i in 11...20 {
            print(i, terminator: " ")
        }
        
        print("\nEnd")
    }
    
    // queue 가 주는 일들을 혼자서, async: 순차를 무시하고 해결함
    func serial_async() {
        // 1. 여기부터 snyc 로 진행하지만..
        print("Start")
        
        // 2. 여기는 메인이 잠깐 멈춰서 큐한테 일 분배 시키고
        // 5. 순차적으로 일이 끝났더니, 큐가 메인한테 일을 다시 시키는겨
        DispatchQueue.main.async {
            for i in 1...10 {
                print(i, terminator: " ")
            }
        }
        
        // 3. 여기 진행하고..
        for i in 11...20 {
            print(i, terminator: " ")
        }
        
        // 4. 여기 진행하고..
        print("\nEnd")
    }
    
    // concurrent: 큐가 주는일을 여러명이서, sync: 순차는 지킴
    func concurrent_sync() {
        // 1. 메인이 순차적으로 시작함
        print("Start")
       
        // 2. 큐한테 일 분배시켜놨더니 sync 로 처리해야함
        // 3. 어 그럼 어짜피 누가해도 처리 시간이 똑같으니 main 이 하렴
        DispatchQueue.global().sync {
            for i in 1...10 {
                print(i, terminator: " ")
            }
        }
        
        // 4.
        for i in 11...20 {
            print(i, terminator: " ")
        }
      
        // 5.
        print("\nEnd")
    }
    
    // concurrent: 큐가 준 일을 여러명이서, async: 순서 무시하고 해결
    func concurrent_async() {
        // 1. 메인이 순차적으로 시작함
        print("Start")
       
        // 2. queue 한테 일 던져줌
        // 3. queue가 글로벌한테 순서무시하고 시켜서 얘도 동시에 하고 있음
        DispatchQueue.global().async {
            for _ in 1...10 {
                print("2", terminator: " ")
            }
        }
        
        // 3. main 은 이걸 실행함
        for _ in 11...20 {
            print("3", terminator: " ")
        }
      
        // 4. queue 한테 일 던져줌
        // 5. queue가 글로벌한테 일 동시에 시킴
        DispatchQueue.global().async {
            for _ in 21...30 {
                print("4", terminator: " ")
            }
        }
        
        // 5. main 도 동시에 이거 함
        for _ in 31...40 {
            print("5", terminator: " ")
        }
        
        // 6. queue 한테 일 던져줌
        // 7. 얘도 이거 동시에 실행함
        DispatchQueue.global().async {
            for _ in 41...50 {
                print("6", terminator: " ")
            }
        }
        
        // 7. 메인은 이거 실행함
        print("\nEnd")
    }
}
