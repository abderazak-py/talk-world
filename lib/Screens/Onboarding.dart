import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:talk_world/Screens/Login.dart';
import 'package:talk_world/component/OnboardingPage.dart';
import 'package:talk_world/component/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return Column(
            children: [
              Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Align(
                  alignment: Alignment.topRight,
                  child: isLastPage
                      ? Text(
                          '',
                          style: TextStyle(fontSize: 20),
                        )
                      : GestureDetector(
                          onTap: () => controller.animateToPage(2,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut),
                          child: Text(
                            'Skip',
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 550,
                child: PageView(
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() => isLastPage = index == 2);
                  },
                  children: const [
                    OnboardingPictureText(
                        image: 'assets/images/1.png',
                        subtitle: 'Talk with all users at the same time !'),
                    OnboardingPictureText(
                        image: 'assets/images/2.png',
                        subtitle: 'Meet people from all over the world'),
                    OnboardingPictureText(
                        image: 'assets/images/3.png',
                        subtitle: 'Keep your data safe'),
                  ],
                ),
              ),
              Spacer(flex: 1),
              SmoothPageIndicator(controller: controller, count: 3),
              Spacer(flex: 1),
              isLastPage
                  ? CustomButton(
                      text: 'Join',
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('showHome', true);
                        if (!mounted) return;
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      })
                  : CustomButton(
                      text: 'Next',
                      onPressed: () {
                        controller.animateToPage((controller.page!.toInt() + 1),
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      }),
              Spacer(flex: 3),
            ],
          );
        }),
      ),
    );
  }
}
