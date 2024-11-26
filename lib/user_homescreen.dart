import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  int _currentPage = 0;

  final List<String> sliderImages = [
    'https://res.cloudinary.com/dm7uq1adt/image/upload/v1732168773/du29n0aligtxzqsz8mzv.png',
    'https://res.cloudinary.com/dm7uq1adt/image/upload/v1732168773/du29n0aligtxzqsz8mzv.png',
    'https://res.cloudinary.com/dm7uq1adt/image/upload/v1732168773/du29n0aligtxzqsz8mzv.png'
  ];

  final List<Map<String, dynamic>> links = [
    {"label": "Browser Link 1", "icon": Icons.link, "url": "https://example.com"},
    {"label": "Browser Link 2", "icon": Icons.link, "url": "https://example.com"},
    {"label": "Browser Link 3", "icon": Icons.link, "url": "https://example.com"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home Screen"),
        backgroundColor: Color(0xFFffc200),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                height: 250.h,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: sliderImages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                      }

                      return Center(
                        child: SizedBox(
                          height: Curves.easeInOut.transform(value) * 200,
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                    onTap: () {
                    /// Add tap behavior here
                    },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          image: DecorationImage(
                            image: NetworkImage(sliderImages[index]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(height: 16),
          // Slider Indicator
          SmoothPageIndicator(
            controller: _pageController,
            count: sliderImages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: Color(0xFF000000),
              dotColor: Color(0xFFB0B0B0),
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
            ),
          ),
          Spacer(),
          Expanded(
            child: SizedBox(
              height: 120.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(links.length, (index) {
                    final link = links[index];
                    return Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          // Add click navigation to the link URL here
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: Color(0xFFffc200),
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 4),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                link["icon"],
                                color: Color(0xFF000000),
                                size: 40.r,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                link["label"],
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
