import 'package:lokale_mand/customer/models/userProfile.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

enum ProfileState { initial, loading, loaded }

class UserProfileProvider extends ChangeNotifier {
  ProfileState profileState = ProfileState.initial;

  Future updateUserProfile(
      {required BuildContext context,
      required String selectedImagePath,
      required Map<String, String> params}) async {
    var returnValue;
    try {
      profileState = ProfileState.loading;
      notifyListeners();

      List<String> fileParamsNames = [];
      List<String> fileParamsFilesPath = [];
      if (selectedImagePath.isNotEmpty) {
        fileParamsNames.add(ApiAndParams.profile);
        fileParamsFilesPath.add(selectedImagePath);
      }

      await getUpdateProfileApi(
              apiName: ApiAndParams.apiUpdateProfile,
              params: params,
              fileParamsNames: fileParamsNames,
              fileParamsFilesPath: fileParamsFilesPath,
              context: context)
          .then(
        (value) {
          if (value != {}) {
            if (value.isNotEmpty) {
              if (value[ApiAndParams.status].toString() == "1") {
                loginApi(context: context, params: {
                  ApiAndParams.mobile:
                      Constant.session.getData(SessionManager.keyPhone),
                  // ApiAndParams.authUid: "123456",
                  // Temp used for testing
                  ApiAndParams.authUid:
                      Constant.session.getData(SessionManager.keyAuthUid),
                  // In live this will use
                });
                returnValue = true;
              } else {
                GeneralMethods.showMessage(
                  context,
                  value[ApiAndParams.message],
                  MessageType.warning,
                );
                profileState = ProfileState.loaded;
                notifyListeners();

                returnValue = value[ApiAndParams.message];
              }
            }
          } else {
            GeneralMethods.showMessage(
              context,
              value[ApiAndParams.message],
              MessageType.warning,
            );
            profileState = ProfileState.loaded;
            notifyListeners();

            returnValue = value;
          }
        },
      );
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
      profileState = ProfileState.loaded;
      notifyListeners();
      returnValue = "";
    }
    return returnValue;
  }

  Future loginApi(
      {required BuildContext context,
      required Map<String, String> params}) async {
    try {
      UserProfile? userProfile;
      await getLoginApi(context: context, params: params)
          .then((mainData) async {
        userProfile = UserProfile.fromJson(mainData);

        if (userProfile?.status == "1") {
          Constant.session.setData(SessionManager.keyToken,
              userProfile?.data?.accessToken.toString() ?? "", false);
          await context
              .read<AddressProvider>()
              .getAddressProvider(context: context)
              .then((value) async {
            await setUserDataInSession(userProfile);
          });
        } else {
          GeneralMethods.showMessage(
            context,
            mainData[ApiAndParams.message],
            MessageType.warning,
          );
        }
      });
      return userProfile!.data?.user?.status ?? "0";
    } catch (e) {
      return "0";
    }
  }

  Future setUserDataInSession(UserProfile? userProfile) async {
    Constant.session.setBoolData(SessionManager.isUserLogin, true, false);

    Constant.session.setUserData(
      firebaseUid: Constant.session.getData(SessionManager.keyAuthUid),
      name: userProfile?.data?.user?.name ?? "",
      id: userProfile?.data?.user?.id ?? "",
      email: userProfile?.data?.user?.email ?? "",
      profile: userProfile?.data?.user?.profile ?? "",
      countryCode: userProfile?.data?.user?.countryCode ?? "",
      mobile: userProfile?.data?.user?.mobile ?? "",
      referralCode: userProfile?.data?.user?.referralCode ?? "",
      status: int.parse(
        userProfile?.data?.user?.status ?? "0",
      ),
      token: userProfile?.data?.accessToken ?? "",
      isUserSeller: false,
      /*balance: userData[ApiAndParams.balance].toString()*/
    );

    profileState = ProfileState.loaded;
    notifyListeners();
  }

  getUserDetailBySessionKey({required bool isBool, required String key}) {
    return isBool == true
        ? Constant.session.getBoolData(key)
        : Constant.session.getData(key);
  }

  changeState() {
    profileState = ProfileState.initial;
    notifyListeners();
  }
}
