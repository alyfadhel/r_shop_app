import 'package:flutter/material.dart';
import 'package:r_shop_app/network/local/cache_helper.dart';
import 'package:r_shop_app/styles/themes/bloc/cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../login/login_screen.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

List<BoardingModel> boarding = [
  BoardingModel(
    image: 'assets/images/on_boarding.jpg',
    title: 'On Board 1 Title',
    body: 'On Board 1 Body',
  ),
  BoardingModel(
    image: 'assets/images/on_boarding.jpg',
    title: 'On Board 2 Title',
    body: 'On Board 2 Body',
  ),
  BoardingModel(
    image: 'assets/images/on_boarding.jpg',
    title: 'On Board 3 Title',
    body: 'On Board 3 Body',
  ),
];

var boardController = PageController();

bool isLast = false;

void submit(context) {
  CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
    if (value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop App',
        ),
        actions: [
          TextButton(
            onPressed: () {
              submit(context);
            },
            child: const Text(
              'SKIP',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                controller: boardController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boarding.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 10.0,
                    dotWidth: 10.0,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.deepOrange,
                    expansionFactor: 1.1,
                    spacing: 4,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit(context);
                    }
                    boardController.nextPage(
                      duration: const Duration(milliseconds: 750),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(
              model.image,
            ),
          ),
          Text(
            model.title,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 24.0,
                ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            model.body,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 20.0,
                ),
          ),
        ],
      );
}
