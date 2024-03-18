import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/providers/localization_provider.dart';
import 'package:notes_app/utils/localization/app_localization.dart';

class SwitchLanguageWidget extends StatelessWidget {
  const SwitchLanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('language'.tr(context),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                )),
        const SizedBox(
          height: 10,
        ),
        const _SwitchListTile('en', 'English'),
        const _SwitchListTile('ar', 'عربية'),
      ],
    );
  }
}

class _SwitchListTile extends ConsumerStatefulWidget {
  const _SwitchListTile(this.languageCode, this.title, {super.key});

  final String languageCode;
  final String title;

  @override
  ConsumerState<_SwitchListTile> createState() => _SwitchListTileNotifier();
}

class _SwitchListTileNotifier extends ConsumerState<_SwitchListTile> {
  late Locale locale;
  late bool value;

  @override
  Widget build(BuildContext context) {
    locale = ref.watch(localizationProvider);
    value = locale.languageCode == widget.languageCode ? true : false;
    return SwitchListTile(
        title: Text(widget.title),
        value: value,
        onChanged: (newValue) {
          setState(() => value = newValue);
          if (value) {
            ref
                .read(localizationProvider.notifier)
                .setLocal(widget.languageCode);
          }
        });
  }
}
