import 'package:image_cropper/image_cropper.dart';
import 'package:lokale_mand/helper/utils/generalImports.dart';

class EditProfile extends StatefulWidget {
  final String? from;

  const EditProfile({Key? key, this.from}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController edtUsername = TextEditingController();
  late TextEditingController edtEmail = TextEditingController();
  late TextEditingController edtMobile = TextEditingController();
  bool isLoading = false;
  String tempName = "";
  String tempEmail = "";
  String selectedImagePath = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      tempName = context.read<UserProfileProvider>().getUserDetailBySessionKey(
          isBool: false, key: SessionManager.keyUserName);
      tempEmail = context.read<UserProfileProvider>().getUserDetailBySessionKey(
          isBool: false, key: SessionManager.keyEmail);

      edtUsername = TextEditingController(text: tempName);
      edtEmail = TextEditingController(text: tempEmail);
      edtMobile = TextEditingController(
          text: Constant.session.getData(SessionManager.keyPhone));
      selectedImagePath = "";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            text: widget.from == "register"
                ? getTranslatedValue(
                    context,
                    "register",
                  )
                : getTranslatedValue(
                    context,
                    "edit_profile",
                  ),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorsRes.mainTextColor,
            ),
          ),
          showBackButton: widget.from != "register"),
      body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size15),
          children: [
            imgWidget(),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.size10, vertical: Constant.size15),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  userInfoWidget(),
                  const SizedBox(height: 50),
                  proceedBtn()
                ]),
              ),
            ),
          ]),
    );
  }

  proceedBtn() {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, _) {
        return userProfileProvider.profileState == ProfileState.loading
            ? const Center(child: CircularProgressIndicator())
            : Widgets.gradientBtnWidget(
                context,
                10,
                title: getTranslatedValue(
                  context,
                  "update",
                ),
                callback: () {
                  try {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      Map<String, String> params = {};
                      params[ApiAndParams.name] = edtUsername.text.trim();
                      params[ApiAndParams.email] = edtEmail.text.trim();
                      userProfileProvider
                          .updateUserProfile(
                              context: context,
                              selectedImagePath: selectedImagePath,
                              params: params)
                          .then(
                        (value) {
                          if (value as bool) {
                              if (widget.from == "register" ||
                                  widget.from == "header") {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  mainHomeScreen,
                                  (Route<dynamic> route) => false,
                                );
                              } else if (widget.from == "add_to_cart") {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                GeneralMethods.showMessage(
                                  context,
                                  getTranslatedValue(
                                      context, "profile_updated_successfully"),
                                  MessageType.success,
                                );
                              }

                            userProfileProvider.changeState();
                          } else {
                            userProfileProvider.changeState();
                            GeneralMethods.showMessage(
                              context,
                              value.toString(),
                              MessageType.warning,
                            );
                          }
                        },
                      );
                    }
                  } catch (e) {
                    userProfileProvider.changeState();
                    GeneralMethods.showMessage(
                      context,
                      e.toString(),
                      MessageType.error,
                    );
                  }
                },
              );
      },
    );
  }

  userInfoWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          editBoxWidget(
            context,
            edtUsername,
            GeneralMethods.emptyValidation,
            getTranslatedValue(
              context,
              "user_name",
            ),
            getTranslatedValue(
              context,
              "enter_user_name",
            ),
            TextInputType.text,
          ),
          SizedBox(height: Constant.size15),
          editBoxWidget(
            context,
            edtEmail,
            GeneralMethods.validateEmail,
            getTranslatedValue(
              context,
              "email",
            ),
            getTranslatedValue(
              context,
              "enter_valid_email",
            ),
            TextInputType.text,
            isEditable: false,
          ),
          SizedBox(height: Constant.size15),
          editBoxWidget(
            context,
            edtMobile,
            GeneralMethods.phoneValidation,
            getTranslatedValue(
              context,
              "mobile_number",
            ),
            getTranslatedValue(
              context,
              "enter_valid_mobile",
            ),
            TextInputType.text,
          ),
        ],
      ),
    );
  }

  imgWidget() {
    return Center(
      child: Stack(children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 15, end: 15),
          child: ClipRRect(
            borderRadius: Constant.borderRadius10,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: selectedImagePath.isEmpty
                ? Widgets.setNetworkImg(
                    height: 100,
                    width: 100,
                    boxFit: BoxFit.fill,
                    image:
                        Constant.session.getData(SessionManager.keyUserImage))
                : Image(
                    image: FileImage(File(selectedImagePath)),
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () async {
              // Single file path
              FilePicker.platform
                  .pickFiles(
                      allowMultiple: false,
                      allowCompression: true,
                      type: FileType.image,
                      lockParentWindow: true)
                  .then((value) {
                cropImage(value!.paths.first.toString());
              });
            },
            child: Container(
              decoration: DesignConfig.boxGradient(5),
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsetsDirectional.only(end: 8, top: 8),
              child: Widgets.defaultImg(
                  image: "edit_icon",
                  iconColor: ColorsRes.mainIconColor,
                  height: 15,
                  width: 15),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> cropImage(String filePath) async {
    await ImageCropper()
        .cropImage(
      sourcePath: filePath,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      maxHeight: 1024,
      maxWidth: 1024,
    )
        .then((croppedFile) {
      if (croppedFile != null) {
        setState(() {
          selectedImagePath = croppedFile.path;
        });
      }
    });
  }
}
