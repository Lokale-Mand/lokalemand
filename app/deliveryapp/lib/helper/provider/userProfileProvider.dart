
import 'package:egrocer_seller/helper/utils/generalImports.dart';

import 'package:flutter/material.dart';
enum LoginState { initial, loading, loaded, error }

enum RegisterState { initial, loading, loaded, error }

enum UpdateProfileState { initial, loading, loaded, error }

class UserProfileProvider extends ChangeNotifier {
  LoginState loginState = LoginState.initial;
  bool hidePassword = true;

  RegisterState registerState = RegisterState.initial;
  bool hideRegisterPassword = true;

  UpdateProfileState updateProfileState = UpdateProfileState.initial;
  bool hideUpdateProfilePassword = true;
  int currentPage = 0;

  Future<Map<String, dynamic>?> loginApiProvider(Map<String, String> params, BuildContext context) async {
    try {
      loginState = LoginState.loading;
      notifyListeners();

      Map<String, dynamic> loginApiResponse = await getLoginRepository(params: params);


      if (loginApiResponse[ApiAndParams.status].toString() == "1") {
        notifyListeners();
        Map<String, dynamic> map = loginApiResponse[ApiAndParams.data];
        Map<String, dynamic> mapUser = map[ApiAndParams.user];
        Constant.session.setData(SessionManager.keyAccessToken, map[ApiAndParams.accessToken], false);
        loginState = LoginState.loaded;
        notifyListeners();

        return Constant.session.isSeller() ? mapUser[ApiAndParams.seller] : mapUser[ApiAndParams.deliveryBoy];
      } else if (loginApiResponse[ApiAndParams.status].toString() == "1") {

        GeneralMethods.showSnackBarMsg(context, "${getTranslatedValue(context, "approved_message")}, ${getTranslatedValue(context, "thank_you")}");
        loginState = LoginState.loaded;
        notifyListeners();
        return {};
      } else {
        if (loginApiResponse.containsKey(ApiAndParams.data)) {
          Map<String, dynamic> data = loginApiResponse[ApiAndParams.data];
          if (data[ApiAndParams.status].toString() == "2") {
            GeneralMethods.showSnackBarMsg(context, "${getTranslatedValue(context, "request_rejected_message")} \"${data[ApiAndParams.remark]}\", ${getTranslatedValue(context, "thank_you")}");
            loginState = LoginState.loaded;
            notifyListeners();
          } else if (data[ApiAndParams.status].toString() == "3") {
            GeneralMethods.showSnackBarMsg(context, "${getTranslatedValue(context, "account_deactivated_message")} \"${data[ApiAndParams.remark]}\", ${getTranslatedValue(context, "thank_you")}");
          }
          loginState = LoginState.loaded;
          notifyListeners();
        } else {
          GeneralMethods.showSnackBarMsg(context, "${getTranslatedValue(context, "request_padding_message")}, ${getTranslatedValue(context, "thank_you")}");
        }
        loginState = LoginState.error;
        notifyListeners();
        return {};
      }
    } catch (e) {
      GeneralMethods.showSnackBarMsg(
        context,
        e.toString(),
      );
      loginState = LoginState.error;
      notifyListeners();
      return {};
    }
  }

  showHidePassword() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  showHideRegisterPassword() {
    hideRegisterPassword = !hideRegisterPassword;
    notifyListeners();
  }

  Future getRegisterUserApiProvider(Map<String, String> params, BuildContext context) async {
    try {
      registerState = RegisterState.loading;
      notifyListeners();

      Map<String, dynamic> registerApiResponse = await getRegisterUserRepository(params: params);

      if (registerApiResponse[ApiAndParams.status].toString() == "1") {
        Map<String, String> loginParams = {};

        loginParams[ApiAndParams.email] = params[ApiAndParams.email].toString();
        loginParams[ApiAndParams.password] = params[ApiAndParams.password].toString();
        loginParams[ApiAndParams.type] = Constant.session.isSeller() ? "3" : "4";
        loginParams[ApiAndParams.fcmToken] = Constant.session.getData(SessionManager.keyFCMToken);

        loginApiProvider(loginParams, context).then(
          (value) async {
            if (value != null) {
              if(Constant.session.getData(SessionManager.appThemeName).isEmpty) {
                Constant.session.setData(
                    SessionManager.appThemeName, Constant.themeList[0], true);
              }

              Constant.session.setUserData(value).then(
                (value) {
                  context.read<SettingsProvider>().getSettingsApiProvider({}, context).then(
                    (value) {
                      if (Constant.session.getData(SessionManager.status).toString() == "1") {
                        Navigator.of(context).pushNamedAndRemoveUntil(mainHomeScreen, (Route<dynamic> route) => false);
                      } else {
                        /*if (Constant.session.isSeller()) {
                          Navigator.of(context).pushNamedAndRemoveUntil(editSellerProfileScreen, (Route<dynamic> route) => false);
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(editDeliveryBoyProfileScreen, (Route<dynamic> route) => false);
                        }*/
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              );
            }
          },
        );
        registerState = RegisterState.loaded;
        notifyListeners();
      } else {
        GeneralMethods.showSnackBarMsg(context, registerApiResponse[ApiAndParams.message]);
        registerState = RegisterState.error;
        notifyListeners();
        return {};
      }
    } catch (e) {
      GeneralMethods.showSnackBarMsg(
        context,
        e.toString(),
      );
      registerState = RegisterState.error;
      notifyListeners();
      return {};
    }
  }

  moveBack() {
    currentPage--;
    notifyListeners();
  }

  moveNext() {
    currentPage++;
    notifyListeners();
  }

  showHideUpdateUserPassword() {
    hideUpdateProfilePassword = !hideUpdateProfilePassword;
    notifyListeners();
  }

  Future updateUserApiProvider({required BuildContext context, required Map<String, String> params, required List<String> fileParamsNames, required List<String> fileParamsFilesPath}) async {
    try {
      updateProfileState = UpdateProfileState.loading;
      notifyListeners();

      Map<String, dynamic> updateUserApiResponse = await updateUserApiRepository(params: params, fileParamsNames: fileParamsNames, fileParamsFilesPath: fileParamsFilesPath);

      if (updateUserApiResponse[ApiAndParams.status].toString() == "1") {
        updateProfileState = UpdateProfileState.loaded;
        notifyListeners();

        Future.delayed(
          Duration(
            seconds: 5,
          ),
          () => Constant.session.logoutUser(context, confirmationRequired: false),
        );

        GeneralMethods.showSnackBarMsg(
          context,
          updateUserApiResponse[ApiAndParams.message],
          requiredAction: true,
        );
      } else {
        GeneralMethods.showSnackBarMsg(context, updateUserApiResponse[ApiAndParams.message]);
        updateProfileState = UpdateProfileState.error;
        notifyListeners();
      }
    } catch (e) {
      GeneralMethods.showSnackBarMsg(
        context,
        e.toString(),
      );
      updateProfileState = UpdateProfileState.error;
      notifyListeners();
    }
  }
}
