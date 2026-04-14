//
//  AuthRepository.swift
//  nAble
//
//  Created by Eorime on 14.04.26.
//


import UIKit
import FirebaseAuth

/* 
sign up
 sign in w google es mere
 log in
 log out
 delete account
 
 */

protocol AuthRepository {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func logout(completion: @escaping (Result<User, Error>) -> Void)
    func signUp(email: String, password: String, username: String, fullName: String, completion: @escaping(Result<User, Error>) -> Void)
    func changePassword(currentPassword: String?, newPassword: String?, completion: @escaping (Result<User, Error>) -> Void)
    func deleteAccount(password: String?, completion: @escaping (Result<User, Error>) -> Void) //will probably need a presenting controller parameter too
}
