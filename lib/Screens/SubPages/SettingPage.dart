// ignore_for_file: prefer_const_constructors, file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:instagram_clone/Services/FirebaseAuth.dart';
import 'package:instagram_clone/Themes/ThemeProvider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    //* refrenses
    AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            //* the app bar sort of
            PageTitle(context),

            //* the settings
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //* how to user instagram:
                SectionTtile(text: "How you use Instagram :"),

                //* profile button
                SettingButton(
                  onTap: () {},
                  beforeIcon: Icons.person,
                  text: "Accounts Center",
                  arrow: true,
                ),

                //* notifications button
                SettingButton(
                  onTap: () {},
                  beforeIcon: Icons.notifications,
                  text: "Notifications",
                  arrow: true,
                ),

                //* saved button
                SettingButton(
                  onTap: () {},
                  beforeIcon: Provider.of<ThemeProvider>(context).isDarkMode
                      ? Icons.dark_mode_sharp
                      : Icons.light_mode,
                  text: Provider.of<ThemeProvider>(context).isDarkMode
                      ? "Dark Mode"
                      : "light Mode",
                  arrow: false,
                  afterAction: Switch(
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(),
                  ),
                ),

                //* More info and Support:
                SectionTtile(text: "More info and Support :"),

                //* help button
                SettingButton(
                  onTap: () {},
                  beforeIcon: Icons.support_sharp,
                  text: "Help",
                  arrow: true,
                ),

                //* privacy and security button
                SettingButton(
                  onTap: () {},
                  beforeIcon: Icons.admin_panel_settings,
                  text: "Privacy and Security",
                  arrow: true,
                ),

                //* account status button
                SettingButton(
                  onTap: () {},
                  beforeIcon: Icons.analytics,
                  text: "Account Status",
                  arrow: true,
                ),

                //* about button
                SettingButton(
                  onTap: () {},
                  beforeIcon: Icons.info,
                  text: "About",
                  arrow: true,
                ),

                //* login info:
                SectionTtile(text: "Login Info :"),

                //* version button
                SettingButton(
                  onTap: () {},
                  beforeIcon: Icons.info,
                  text: "Version 1.7.3",
                  arrow: false,
                ),

                //* sign out button
                SettingButton(
                  onTap: () {
                    setState(() {
                      authService.sighOutfromGoogle();
                      Navigator.pop(context);
                    });
                  },
                  beforeIcon: Icons.logout,
                  text: "Sign Out",
                  arrow: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding SectionTtile({required String text}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Row PageTitle(BuildContext context) {
    return Row(
      children: [
        //* back arrow
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),

        SizedBox(width: 30),

        //* setting text
        Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ],
    );
  }

  GestureDetector SettingButton({
    required void Function()? onTap,
    required String text,
    required bool arrow,
    required IconData beforeIcon,
    Widget? afterAction,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  beforeIcon,
                  size: 30,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                SizedBox(width: 15),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            arrow
                ? Icon(Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).colorScheme.secondary)
                : afterAction ?? Container(),
          ],
        ),
      ),
    );
  }
}
