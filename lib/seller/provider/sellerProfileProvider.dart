import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/model/sellerProfile.dart';
import 'package:lokale_mand/seller/repositories/sellerLoginApi.dart';

enum SellerProfileState { initial, loading, loaded }

class SellerProfileProvider extends ChangeNotifier {
  SellerProfileState sellerProfileState = SellerProfileState.initial;

  Future updateSellerProfile(
      {required BuildContext context,
      required String selectedImagePath,
      required Map<String, String> params}) async {
    var returnValue;
    try {
      sellerProfileState = SellerProfileState.loading;
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
                sellerLoginApi(context: context, params: {
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
                sellerProfileState = SellerProfileState.loaded;
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
            sellerProfileState = SellerProfileState.loaded;
            notifyListeners();

            returnValue = value;
          }
        },
      );
    } catch (e) {
      GeneralMethods.showMessage(context, e.toString(), MessageType.warning);
      sellerProfileState = SellerProfileState.loaded;
      notifyListeners();
      returnValue = "";
    }
    return returnValue;
  }

  Future sellerLoginApi(
      {required BuildContext context,
      required Map<String, String> params}) async {
    // try {
    Map<String, dynamic> getSellerData =
        await getSellerLoginRepository(context: context, params: params);

    print(">>>>>>>>>>>>>>>> $getSellerData");
    if (getSellerData[ApiAndParams.status].toString() == "1") {
      SellerProfile sellerProfile = SellerProfile.fromJson(getSellerData);
      await setSellerDataInSession(sellerProfile);

      return sellerProfile.data?.user?.status.toString() ?? "";
    } else {
      GeneralMethods.showMessage(
        context,
        getSellerData[ApiAndParams.message],
        MessageType.warning,
      );
      return "0";
    }
    // } catch (e) {
    //   GeneralMethods.showMessage(
    //     context,
    //     e.toString(),
    //     MessageType.warning,
    //   );
    //   return "0";
    // }
  }

  Future setSellerDataInSession(SellerProfile sellerProfile) async {
    Constant.session.setBoolData(SessionManager.isUserLogin, true, false);
    SellerProfileUser? user = sellerProfile.data?.user;

    if (user != null) {
      Constant.session.setUserData(
        firebaseUid: Constant.session.getData(SessionManager.keyAuthUid),
        name: user.username.toString(),
        email: user.email.toString(),
        profile: sellerProfile.data?.user?.seller?.logoUrl.toString() ?? "",
        countryCode: "",
        mobile: user.seller?.mobile.toString() ?? "",
        referralCode: "",
        status: int.parse(user.status.toString()),
        token: sellerProfile.data?.accessToken.toString() ?? "", isUserSeller: true,
        /*balance: userData[ApiAndParams.balance].toString()*/
      );
      sellerProfileState = SellerProfileState.loaded;
      notifyListeners();
    }
  }

  updateSellerDataInSession(Map<String, dynamic> mainData) async {
    Map<String, dynamic> userData =
        await mainData[ApiAndParams.user] as Map<String, dynamic>;

    Constant.session.setUserData(
      firebaseUid: Constant.session.getData(SessionManager.keyAuthUid),
      name: userData[ApiAndParams.name],
      email: userData[ApiAndParams.email],
      profile: userData[ApiAndParams.profile].toString(),
      countryCode: userData[ApiAndParams.countryCode],
      mobile: userData[ApiAndParams.mobile],
      referralCode: userData[ApiAndParams.referralCode],
      status: int.parse(userData[ApiAndParams.status].toString()),
      token: Constant.session.getData(
        SessionManager.keyToken,
      ),
      isUserSeller:
          true, /*balance: Constant.session.getData(SessionManager.keyBalance)*/
    );

    sellerProfileState = SellerProfileState.loaded;
    notifyListeners();
  }

  getSellerDetailBySessionKey({required bool isBool, required String key}) {
    return isBool == true
        ? Constant.session.getBoolData(key)
        : Constant.session.getData(key);
  }

  changeState() {
    sellerProfileState = SellerProfileState.initial;
    notifyListeners();
  }
}
