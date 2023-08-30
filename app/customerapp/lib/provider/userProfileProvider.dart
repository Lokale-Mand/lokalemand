import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:egrocer/models/userProfile.dart';

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
                  ApiAndParams.authUid: Constant.session.getData(SessionManager.keyAuthUid),
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
      GeneralMethods.showMessage(context, e.toString(), MessageType.success);
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
          await setUserDataInSession(mainData);
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

  Future setUserDataInSession(Map<String, dynamic> mainData) async {
    Map<String, dynamic> data =
    await mainData[ApiAndParams.data] as Map<String, dynamic>;

    Map<String, dynamic> userData =
    await data[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setBoolData(SessionManager.isUserLogin, true, false);

    Constant.session.setUserData(
      /*firebaseUid: Constant.session.getData(SessionManager.keyFirebaseId),*/
      name: userData[ApiAndParams.name],
      email: userData[ApiAndParams.email],
      profile: userData[ApiAndParams.profile].toString(),
      countryCode: userData[ApiAndParams.countryCode],
      mobile: userData[ApiAndParams.mobile],
      referralCode: userData[ApiAndParams.referralCode],
      status: int.parse(userData[ApiAndParams.status].toString()),
      token: data[ApiAndParams
          .accessToken], /*balance: userData[ApiAndParams.balance].toString()*/
    );
    profileState = ProfileState.loaded;
    notifyListeners();
  }

  updateUserDataInSession(Map<String, dynamic> mainData) async {
    Map<String, dynamic> userData =
    await mainData[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setUserData(
      /*firebaseUid: Constant.session.getData(SessionManager.keyFirebaseId),*/
      name: userData[ApiAndParams.name],
      email: userData[ApiAndParams.email],
      profile: userData[ApiAndParams.profile].toString(),
      countryCode: userData[ApiAndParams.countryCode],
      mobile: userData[ApiAndParams.mobile],
      referralCode: userData[ApiAndParams.referralCode],
      status: int.parse(userData[ApiAndParams.status].toString()),
      token: Constant.session.getData(SessionManager
          .keyToken), /*balance: Constant.session.getData(SessionManager.keyBalance)*/
    );

    profileState = ProfileState.loaded;
    notifyListeners();
  }

  getUserDetailBySessionKey({required bool isBool, required String key}) {
    return isBool == true
        ? Constant.session.getBoolData(key)
        : Constant.session.getData(key);
  }

  changeState(){
    profileState = ProfileState.initial;
    notifyListeners();
  }
}