import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:life_log_2/main.dart';

class FlutterThemeTest extends StatefulWidget {
  const FlutterThemeTest({super.key});

  @override
  State<FlutterThemeTest> createState() => _FlutterThemeTestState();
}

class _FlutterThemeTestState extends State<FlutterThemeTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M3 Color Scheme Example'),
      ),
      body: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(10),
        children: <Widget>[
          ElevatedButton(
            onPressed: () {},
            child: Text("ElevatedButton"),
          ),
          FilledButton(
            onPressed: () {},
            child: Text("FilledButton"),
          ),
          FilledButton.tonal(
            onPressed: () {},
            child: Text("FilledButton.tonal",
                style: Theme.of(context).textTheme.labelMedium),
          ),
          FilledButton.tonal(
            onPressed: () {},
            child: Text("FilledButton.tonal"),
          ),
          OutlinedButton(
            onPressed: () {},
            child: Text("OutlinedButton"),
          ),
          BackButton(
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            child: Text("TextButton"),
          ),
          TextButton(
            onPressed: () {},
            child: Text("TextButton",
                style: Theme.of(context).textTheme.labelMedium),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Text("displayMedium",
                    style: Theme.of(context).textTheme.displayLarge),
                Text("displayMedium",
                    style: Theme.of(context).textTheme.displayMedium),
                Text("displayMedium",
                    style: Theme.of(context).textTheme.displaySmall),
                Text("headlineMedium",
                    style: Theme.of(context).textTheme.headlineMedium),
                Text("titleMedium",
                    style: Theme.of(context).textTheme.titleMedium),
                Text("bodyMedium",
                    style: Theme.of(context).textTheme.bodyMedium),
                Card(
                  child: Text("cardbodyMedium",
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                Card(
                  child: Text("cardbodyMedium",
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                Text("labelMedium",
                    style: Theme.of(context).textTheme.labelMedium),
                Divider(),
                Text("labelMedium",
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          )
        ],
      ),
    );
  }
}
