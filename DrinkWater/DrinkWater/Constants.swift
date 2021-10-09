//
//  Constants.swift
//  DrinkWater
//
//  Created by 민선기 on 2021/10/08.
//

import Foundation

struct Constants {
    
    struct UserDefaultsKeys {
        static let currentWater = "KEY_CURRENT_WATER"
        static let userDefault = "KEY_USER_DEFAULT"
    }
    
    struct EmptyInfo {
        static let mainText = """
                        얼마나 마셔야 될까요?
                        정보를 입력해주세요.
                        """
        static let recommendText = "물 섭취량 계산을 위해 유저 정보를 입력해주세요."
    }
    
    struct HasInfo {
        static let mainText = """
            잘하셨어요!
            오늘 마신 양은
            """
        static let recommendText = "님의 하루 물 권장 섭취량은 2.1L입니다."
        static let confirmText = "물 마시기"
        static let textFieldPlaceholder = "얼마나 마셨나요?"
    }
    
    struct ProfileViewControllerText {
        static let nicknameText = "닉네임을 설정해주세요"
        static let heightText = "키(cm)을 설정해주세요"
        static let weightText = "몸무게(kg)를 설정해주세요"
    }
}
