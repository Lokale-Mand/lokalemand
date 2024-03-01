import 'package:lokale_mand/helper/utils/generalImports.dart';
import 'package:lokale_mand/seller/provider/sellerProductSliderImagesProvider.dart';

class SellerProductSliderImagesWidgets extends StatefulWidget {
  final List<String?> sliders;

  const SellerProductSliderImagesWidgets({Key? key, required this.sliders})
      : super(key: key);

  @override
  State<SellerProductSliderImagesWidgets> createState() =>
      _SellerProductSliderImagesWidgetsState();
}

class _SellerProductSliderImagesWidgetsState
    extends State<SellerProductSliderImagesWidgets> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (mounted) {
          if (context
                  .read<SellerSliderImagesProvider>()
                  .currentSliderImageIndex <
              (widget.sliders.length - 1)) {
            context
                .read<SellerSliderImagesProvider>()
                .setSellerSliderCurrentIndexImage((context
                        .read<SellerSliderImagesProvider>()
                        .currentSliderImageIndex +
                    1));
          } else {
            context
                .read<SellerSliderImagesProvider>()
                .setSellerSliderCurrentIndexImage(0);
          }
          _pageController.animateToPage(
              context
                  .read<SellerSliderImagesProvider>()
                  .currentSliderImageIndex,
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
        ? Consumer<SellerSliderImagesProvider>(
            builder: (context, sellerSliderImagesProvider, child) {
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
                                child: widget.sliders[index]!.startsWith("http")
                                    ? Widgets.setNetworkImg(
                                        image: widget.sliders[index] ?? "",
                                        width: 90,
                                        height: 90,
                                        boxFit: BoxFit.fill,
                                      )
                                    : Image(
                                        image: FileImage(
                                          File(
                                            widget.sliders[index] ?? "",
                                          ),
                                        ),
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.fill,
                                      ),
                              );
                            },
                            onPageChanged: (value) {
                              sellerSliderImagesProvider
                                  .setSellerSliderCurrentIndexImage(value);
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
                                        color: sellerSliderImagesProvider
                                                    .currentSliderImageIndex ==
                                                index
                                            ? Theme.of(context).cardColor
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              sellerSliderImagesProvider
                                                          .currentSliderImageIndex ==
                                                      index
                                                  ? Theme.of(context).cardColor
                                                  : Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                          radius: 5,
                                        ),
                                        elevation: sellerSliderImagesProvider
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
