import 'package:lokale_mand/helper/utils/generalImports.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({Key? key}) : super(key: key);

  @override
  IntroSliderScreenState createState() => IntroSliderScreenState();
}

class IntroSliderScreenState extends State<IntroSliderScreen> {
  final _pageController = PageController();
  int currentPosition = 0;

  /// Intro slider list ...
  /// You can add or remove items from below list as well
  /// Add svg images into asset > svg folder and set name here without any extension and image should not contains space
  static List introSlider = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildPageView(),
    );
  }

  _buildPageView() {
    introSlider = [
      {
        "image": "location",
        "title": getTranslatedValue(
          context,
          "intro_title_1",
        ),
        "description": getTranslatedValue(
          context,
          "intro_description_1",
        ),
      },
      {
        "image": "order",
        "title": getTranslatedValue(
          context,
          "intro_title_2",
        ),
        "description": getTranslatedValue(
          context,
          "intro_description_2",
        ),
      },
      {
        "image": "delivered",
        "title": getTranslatedValue(
          context,
          "intro_title_3",
        ),
        "description": getTranslatedValue(
          context,
          "intro_description_3",
        ),
      },
    ];

    return Stack(
      children: [
        pageWidget(currentPosition),
        PageView.builder(
          itemCount: introSlider.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            return Container();
          },
          onPageChanged: (int index) {
            currentPosition = index;
            setState(
              () {},
            );
          },
        ),
        Positioned(
          bottom: 50,
          left: currentPosition == introSlider.length - 1 ? 80 : 0,
          right: currentPosition == introSlider.length - 1 ? 80 : 0,
          child: buttonWidget(currentPosition),
        ),
      ],
    );
  }

  pageWidget(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Widgets.defaultImg(
            padding: EdgeInsetsDirectional.all(Constant.size15),
            image: introSlider[index]["image"],
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                child: infoWidget(index),
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsetsDirectional.only(
                  start: 20,
                  end: 20,
                  bottom: 10,
                ),
                margin: const EdgeInsetsDirectional.only(
                  start: 20,
                  end: 20,
                  bottom: 20,
                  top: 50,
                ),
                decoration: DesignConfig.boxDecoration(
                  ColorsRes.appColor,
                  30,
                ),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: ShapeDecoration(
                  color: ColorsRes.appColor,
                  shape: CircleBorder(
                    side: BorderSide(
                      width: 5,
                      color: ColorsRes.appColor,
                    ),
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: ColorsRes.appColorWhite,
                  child: Widgets.defaultImg(
                    image: "logo",
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  infoWidget(int index) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: CustomTextLabel(
              text: introSlider[index]["title"],
              softWrap: true,
              style: TextStyle(
                  color: ColorsRes.appColorWhite,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
          ),
          CustomTextLabel(
            text: introSlider[index]["description"],
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorsRes.appColorWhite,
                fontSize: 20,
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  buttonWidget(int index) {
    return GestureDetector(
      onTap: () {
        if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
            Constant.session.getBoolData(SessionManager.isUserLogin)) {
          Navigator.pushReplacementNamed(
            context,
            mainHomeScreen,
          );
        } else {
          Navigator.pushReplacementNamed(context, userTypeSelectionScreen);
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: 45,
        margin: const EdgeInsets.only(top: 80),
        decoration: DesignConfig.boxDecoration(
            index == introSlider.length - 1 ? Colors.white : Colors.transparent,
            10),
        child: index == introSlider.length - 1
            ? CustomTextLabel(
                text: getTranslatedValue(
                  context,
                  "get_started",
                ),
                softWrap: true,
                style: TextStyle(
                    color: ColorsRes.appColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              )
            : dotWidget(),
      ),
    );
  }

  dotWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(introSlider.length, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            margin: const EdgeInsetsDirectional.only(end: 10.0),
            width: currentPosition == index ? 30 : 10,
            height: currentPosition == index ? 10 : 10,
            decoration: DesignConfig.boxDecoration(Colors.white, 10),
          );
        }),
      ),
    );
  }
}
