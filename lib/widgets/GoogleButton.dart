import 'package:flutter/material.dart';

Padding GoogleThing(
    {required BuildContext context, required void Function()? onTap}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        divider(context),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(500),
            ),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/Google.png"),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 17,
            ),
          ),
        ),
        divider(context),
      ],
    ),
  );
}

Container divider(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 5),
    height: 3,
    width: 125,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
