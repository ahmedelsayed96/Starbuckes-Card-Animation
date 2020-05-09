import 'package:flutter/material.dart';
import 'package:starbuckes_video/drinkCard.dart';

import 'colors.dart';
import 'drink.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  PageController pageController;
  double pageOffset = 0;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOutBack);
    pageController = PageController(viewportFraction: .8);
    pageController.addListener(() {
      setState(() {
        pageOffset = pageController.page;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildToolbar(),
            buildLogo(size),
            buildPager(size),
            buildPageIndecator()
          ],
        ),
      ),
    );
  }

  Widget buildToolbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          AnimatedBuilder(
              animation: animation,
              builder: (context, snapshot) {
                return Transform.translate(
                  offset: Offset(-200 * (1 - animation.value), 0),
                  child: Image.asset(
                    'images/location.png',
                    width: 30,
                    height: 30,
                  ),
                );
              }),
          Spacer(),
          AnimatedBuilder(
              animation: animation,
              builder: (context, snapshot) {
                return Transform.translate(
                  offset: Offset(200 * (1 - animation.value), 0),
                  child: Image.asset(
                    'images/drawer.png',
                    width: 30,
                    height: 30,
                  ),
                );
              }),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget buildLogo(Size size) {
    return Positioned(
      top: 10,
      right: size.width / 2 - 25,
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, snapshot) {
            return Transform(
              transform: Matrix4.identity()
                ..translate(0.0, size.height / 2 * (1 - animation.value))
                ..scale(1 + (1 - animation.value)),
              origin: Offset(25, 25),
              child: InkWell(
                onTap: () => controller.isCompleted
                    ? controller.reverse()
                    : controller.forward(),
                child: Image.asset(
                  'images/logo.png',
                  width: 50,
                  height: 50,
                ),
              ),
            );
          }),
    );
  }

  Widget buildPager(Size size) {
    return Container(
      margin: EdgeInsets.only(top: 70),
      height: size.height - 50,
      child: AnimatedBuilder(
          animation: animation,
          builder: (context, snapshot) {
            return Transform.translate(
              offset: Offset(400 * (1 - animation.value), 0),
              child: PageView.builder(
                  controller: pageController,
                  itemCount: getDrinks().length,
                  itemBuilder: (context, index) =>
                      DrinkCard(getDrinks()[index], pageOffset, index)),
            );
          }),
    );
  }

  List<Drink> getDrinks() {
    List<Drink> list = [];
    list.add(Drink(
        'Tirami',
        'Sù',
        'images/blur_image.png',
        'images/bean_top.png',
        'images/bean_small.png',
        'images/bean_blur.png',
        'images/cup.png',
        'then top with whipped cream and mocha drizzle to bring you endless \njava joy',
        mBrownLight,
        mBrown));
    list.add(Drink(
        'Green',
        'Tea',
        'images/green_image.png',
        'images/green_top.png',
        'images/green_small.png',
        'images/green_blur.png',
        'images/green_tea_cup.png',
        'milk and ice and top it with sweetened whipped cream to give you \na delicious boost\nof energy.',
        greenLight,
        greenDark));
    list.add(Drink(
        'Triple',
        'Mocha',
        'images/mocha_image.png',
        'images/chocolate_top.png',
        'images/chocolate_small.png',
        'images/chocolate_blur.png',
        'images/mocha_cup.png',
        'layers of whipped cream that’s infused with cold brew, white chocolate mocha and dark \ncaramel.',
        mBrownLight,
        mBrown));
    return list;
  }

  Widget buildPageIndecator() {
    return AnimatedBuilder(
      animation:controller,
      builder: (context, snapshot) {
        return Positioned(
          bottom: 10,
          left: 10,
          child: Opacity(
            opacity: controller.value,
            child: Row(
              children:
                  List.generate(getDrinks().length, (index) => buildContainer(index)),
            ),
          ),
        );
      }
    );
  }

  Widget buildContainer(int index) {
    double animate =pageOffset-index;
    double size =10;
    animate=animate.abs();
    Color color =Colors.grey;
    if(animate<=1 && animate>=0){
      size=10+10*(1-animate);
      color =ColorTween(begin: Colors.grey,end: mAppGreen).transform((1-animate));
    }

    return Container(
      margin: EdgeInsets.all(4),
      height: size,
      width: size,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20)),
    );
  }
}
