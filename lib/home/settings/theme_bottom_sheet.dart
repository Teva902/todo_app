import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/providers/app_config_provider.dart';

class ThemeBottomSheet extends StatefulWidget {
  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
              onTap: () {
                provider.changeTheme(ThemeMode.dark);
              },
              child: provider.isDark()
                  ? getSelecetdItem(AppLocalizations.of(context)!.dark)
                  : getUnSelectedItem(AppLocalizations.of(context)!.dark)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          InkWell(
            onTap: () {
              provider.changeTheme(ThemeMode.light);
            },
            child: provider.isDark()
                ? getUnSelectedItem(AppLocalizations.of(context)!.light)
                : getSelecetdItem(AppLocalizations.of(context)!.light),
          )
        ],
      ),
    );
  }

  Widget getSelecetdItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.primaryColor),
        ),
        Icon(
          Icons.check,
          color: AppColors.primaryColor,
          size: 30,
        )
      ],
    );
  }

  Widget getUnSelectedItem(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
