import 'package:lokale_mand/helper/utils/generalImports.dart';

class ProductSliderImagesWidgets extends StatefulWidget {
  final List<String> sliders;

  const ProductSliderImagesWidgets({Key? key, required this.sliders})
      : super(key: key);

  @override
  State<ProductSliderImagesWidgets> createState() =>
      _ProductSliderImagesWidgetsState();
}

class _ProductSliderImagesWidgetsState
    extends State<ProductSliderImagesWidgets> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (mounted) {
          if (context.read<SliderImagesProvider>().currentSliderImageIndex <
              (widget.sliders.length - 1)) {
            context.read<SliderImagesProvider>().setSliderCurrentIndexImage(
                (context.read<SliderImagesProvider>().currentSliderImageIndex +
                    1));
          } else {
            context.read<SliderImagesProvider>().setSliderCurrentIndexImage(0);
          }
          _pageController.animateToPage(
              context.read<SliderImagesProvider>().currentSliderImageIndex,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.sliders.length != 0)
        ? Consumer<SliderImagesProvider>(
            builder: (context, sliderImagesProvider, child) {
              return Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.34,
                          width: MediaQuery.sizeOf(context).width,
                          child: PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.sliders.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: Constant.borderRadius10,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Widgets.setNetworkImg(
                                  image: widget.sliders[index],
                                  boxFit: BoxFit.fitHeight,
                                ),
                              );
                            },
                            onPageChanged: (value) {
                              sliderImagesProvider
                                  .setSliderCurrentIndexImage(value);
                            },
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        bottom: 15,
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          child: Align(
                            alignment: Alignment.center,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  widget.sliders.length,
                                  (index) {
                                    return Padding(
                                      padding: EdgeInsetsDirectional.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: PhysicalModel(
                                        color: sliderImagesProvider
                                                    .currentSliderImageIndex ==
                                                index
                                            ? Theme.of(context).cardColor
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CircleAvatar(
                                          backgroundColor: sliderImagesProvider
                                                      .currentSliderImageIndex ==
                                                  index
                                              ? Theme.of(context).cardColor
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                          radius: 5,
                                        ),
                                        elevation: sliderImagesProvider
                                                    .currentSliderImageIndex ==
                                                index
                                            ? 5
                                            : 0,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          )
        : Container();
  }
}
