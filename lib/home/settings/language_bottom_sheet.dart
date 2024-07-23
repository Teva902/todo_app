import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/providers/app_config_provider.dart';

class LanguageBottomSheet extends StatefulWidget {
  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
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
                provider.changeLanguage('en');
              },
              child: provider.appLanguage == 'en'
                  ? getSelecetdItem(AppLocalizations.of(context)!.english)
                  : getUnSelectedItem(AppLocalizations.of(context)!.english)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          InkWell(
            onTap: () {
              provider.changeLanguage('ar');
            },
            child: provider.appLanguage == 'ar'
                ? getSelecetdItem(AppLocalizations.of(context)!.arabic)
                : getUnSelectedItem(AppLocalizations.of(context)!.arabic),
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
