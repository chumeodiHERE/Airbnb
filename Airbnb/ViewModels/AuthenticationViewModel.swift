//
//  AuthenticationViewModel.swift
//  Airbnb
//
//  Created by Gia Huy on 15/04/2024.
//

import Foundation
import FirebaseAuth

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    @Published var flow: AuthenticationFlow = .login

    @Published var isValid  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: User?
    @Published var displayName = ""
    
    init() {
        registerAuthStateHandler()
        
        $flow
          .combineLatest($email, $password, $confirmPassword)
          .map { flow, email, password, confirmPassword in
            flow == .login
              ? !(email.isEmpty || password.isEmpty)
              : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
          }
          .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?

    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? "uname"
          }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let result = try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            user = result.user
            authenticationState = .authenticated
            let defaults = UserDefaults.standard
            defaults.set(user?.uid, forKey: "userId")
//            defaults.set("sucess", forKey: "statusLogin")
            return true
        }
        catch {
            errorMessage = "Account or password is incorrect"
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            if password != confirmPassword {
                errorMessage = "Confirm password does not match"
                authenticationState = .unauthenticated
                return false
            } else {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                user = result.user
                authenticationState = .authenticated
                return true
            }
        }
        catch {
            errorMessage = "Email already exists"
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
        do {
          try Auth.auth().signOut()
        }
        catch {
          print(error)
          errorMessage = error.localizedDescription
        }
    }
}

