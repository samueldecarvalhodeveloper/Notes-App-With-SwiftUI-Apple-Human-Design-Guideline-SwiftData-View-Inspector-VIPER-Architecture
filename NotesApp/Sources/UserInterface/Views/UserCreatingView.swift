import SwiftUI

@MainActor
struct UserCreatingView: View {
    @State var userPresenter: UserPresenter
    @State private var userToBeCreatedUsername = ""
    @State private var userCreatingErrorMessage = ""
    let onUserExisting: (Int) -> Void
    var didAppear: ((Self) throws -> Void)?
    var didUpdate: ((Self) throws -> Void)?

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Create new user")
                    .padding(.bottom, 16)
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(NEUTRALS_900)
                VStack(alignment: .leading, spacing: 3.5) {
                    TextField(
                        "",
                        text: $userToBeCreatedUsername,
                        prompt:
                            Text("username")
                            .font(.system(size: 16))
                            .foregroundStyle(NEUTRALS_300)
                    )
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .foregroundColor(NEUTRALS_900)
                    .background(NEUTRALS_100)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(NEUTRALS_200, lineWidth: 1))
                    if !userCreatingErrorMessage.isEmpty {
                        Text(userCreatingErrorMessage)
                            .padding(.leading, 16)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .lineLimit(1)
                    }
                }
                .padding(.bottom, 8)
                Button("Create user") {
                    userPresenter.createUser(
                        username: userToBeCreatedUsername, onUserCreated: onUserExisting)
                }.frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(NEUTRALS_100)
                    .background(PRIMARY_500)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .circular))
            }
            .padding(24)
            .background(NEUTRALS_100)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .circular))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        .background(NEUTRALS_200)
        .onAppear {
            userPresenter.verifyIfUserExists(onUserCreated: onUserExisting)

            try? self.didAppear?(self)
        }
        .onChange(of: userPresenter.isUserUsernameInvalid, initial: false) {
            userCreatingErrorMessage = NOT_VALID_USERNAME_ERROR_MESSAGE
        }
        .onChange(of: userPresenter.isInternetErrorRisen, initial: false) {
            userCreatingErrorMessage = NO_AVAILABLE_INTERNET_ERROR_MESSAGE
        }
        .onChange(of: userCreatingErrorMessage) {
            try? self.didUpdate?(self)
        }
    }
}
