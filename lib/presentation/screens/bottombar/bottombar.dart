import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockmate/core/constants/colors.dart';
import 'package:stockmate/core/utils/margin_text.dart';
import 'package:stockmate/core/utils/page_navigation.dart';
import 'package:stockmate/presentation/screens/add_product/add_prodcut_screen.dart';
import 'package:stockmate/presentation/screens/bottombar/cubit/bottombar_cubit.dart';
import 'package:stockmate/presentation/screens/home_page/home_screen.dart';
import 'package:stockmate/presentation/screens/inventory/inventory_page.dart';
import 'package:stockmate/presentation/widgets/custom_apptext.dart';

import '../profile/profile_screen.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    InventoryPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottombarCubit(),
      child: BlocBuilder<BottombarCubit, BottombarState>(
        builder: (context, state) {
          final cubit = context.read<BottombarCubit>();
          return Scaffold(
                      appBar: AppBar(
              backgroundColor: colorWhite,
              title: AppText(
                cubit.index == 0
                    ? "Dashboard"
                    : cubit.index == 1
                    ? "Inventory"
                    : "Profile",
                size: 18,
                weight: FontWeight.w700,
              ),
              centerTitle: true,
            ),
            backgroundColor: colorWhite,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _widgetOptions[cubit.index],
            ),
            bottomNavigationBar: BottomNavigationBar(
              iconSize: 20,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_rounded),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_rounded),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
              currentIndex: cubit.index,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(fontSize: 14),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              onTap: cubit.changeIndex,
            ),
          );
        },
      ),
    );
  }
}
