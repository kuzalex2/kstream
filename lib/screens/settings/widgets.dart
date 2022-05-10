import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({
    Key? key,
    required this.title,
    required this.disabled,
    required this.value,
    required this.onChanged
  }) : super(key: key);

  final String title;
  final bool disabled;
  final bool value;
  final Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return  SettingsRow(
      left: null,
      title: Text(title, overflow: TextOverflow.ellipsis, softWrap: false,),
      right: CupertinoSwitch(
        activeColor: Colors.blue,
        onChanged: disabled ? null : onChanged,
        value: value,
      ),
      isActive: !disabled,
    );
  }
}

class SettingsOption extends StatelessWidget {
  const SettingsOption({
    Key? key,
    this.iconData,
    required this.title,
    this.rightTitle,
    required this.disabled,
    required this.onTap,
  }) : super(key: key);
  final IconData? iconData;
  final String title;
  final String? rightTitle;

  final bool disabled;
  final Function() onTap;





  @override
  Widget build(BuildContext context) {
    return  SettingsRow(
      left: iconData!=null ? Icon(iconData) : null,
      title: Text(title),
      rightTitle: rightTitle!=null ? Text("( $rightTitle )") : null,

      onTap: disabled ? null : onTap,
      right: const Icon(Icons.arrow_right),

      // decoration: const BoxDecoration(
      //   color: Colors.blueGrey ,
      // ),

    );
  }
}



class SettingsLine extends StatelessWidget {
  const SettingsLine({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: text!=null ? const EdgeInsets.symmetric(vertical: 16, horizontal: 16) : null,
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.blue))),
        child: Text(text ?? "")
    );
  }
}


// [ left | title       rightTitle | right ]

class SettingsRow extends StatelessWidget {
  final Widget? left;
  final Widget? title;
  final Widget? right;
  final Widget? rightTitle;

  final Function()? onTap;
  final Decoration? decoration;
  final bool _isActive;


  const SettingsRow({
    Key? key,
    this.left,
    this.title,
    this.right,
    this.rightTitle,
    this.onTap,
    this.decoration,
    bool isActive = false,
  }) : _isActive = isActive || onTap!=null, super(key: key);

  @override
  Widget build(BuildContext context) {

    ;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: decoration,
        padding: const EdgeInsets.all(16),
        child: IconTheme(
          data: IconThemeData(color: _isActive ? DefaultTextStyle.of(context).style.color : Theme.of(context).disabledColor),

          child: DefaultTextStyle(
            style: TextStyle(color: _isActive ? null : Theme.of(context).disabledColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: left,
                      ),
                      title ?? const SizedBox.shrink(),
                    ],
                  ),
                ),

                Row(children: [
                  rightTitle ?? const SizedBox.shrink(),
                  right ?? const SizedBox.shrink(),
                ],)

              ],
            ),
          ),
        ),
      ),
    );
  }

}

