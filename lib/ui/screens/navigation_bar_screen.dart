import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';

class NavigationBarScreen extends StatefulWidget {
  @override
  _NavigationBarScreenState createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    ShalatScreen(),
    QuranScreen(),
    DoaScreen(),
    NabiScreen(),
  ];

  void _bottomNavigationAction(int index) {
    context.read<NavigationCubit>().changeScreen(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            extendBody: true,
            body: Stack(
              children: _screens
                  .asMap()
                  .entries
                  .map(
                    (entry) => Offstage(
                      child: entry.value,
                      offstage: entry.key != currentIndex,
                    ),
                  )
                  .toList(),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CustomNavigationBar(
                isFloating: true,
                borderRadius: Radius.circular(Measure.borderRadius),
                selectedColor: Theme.of(context).colorScheme.secondary,
                unSelectedColor: Pallette.black,
                currentIndex: currentIndex,
                onTap: _bottomNavigationAction,
                items: [
                  CustomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.home),
                    title: Text(Word.home),
                  ),
                  CustomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.clock),
                    title: Text(Word.shalat),
                  ),
                  CustomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.quran),
                    title: Text(Word.quran),
                  ),
                  CustomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.hands),
                    title: Text(Word.pray),
                  ),
                  CustomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.bookOpen),
                    title: Text(Word.prophet),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
