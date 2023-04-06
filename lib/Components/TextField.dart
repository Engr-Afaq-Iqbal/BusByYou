import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppFormField extends StatefulWidget {
  final String? labelText;
  final String? title;
  final bool isLabel;
  final IconData? icon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isPasswordField;
  final bool enabled;
  final double? height;
  final int maxLines;
  final Function()? onTap;
  final bool readOnly;
  final bool isOutlineBorder;
  final bool isBorderColorApply;
  final List<TextInputFormatter>? inputFormatterList;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function()? onEditingComp;
  final int? maxLength;
  final double? width;
  final Widget? child;

  AppFormField({
    Key? key,
    this.labelText,
    this.title,
    this.isLabel = true,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.isPasswordField = false,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.height,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.isOutlineBorder = true,
    this.isBorderColorApply = true,
    this.inputFormatterList,
    this.validator,
    this.onChanged,
    this.margin,
    this.padding = const EdgeInsets.only(bottom: 15),
    this.prefixIcon,
    this.suffixIcon,
    this.onEditingComp,
    this.maxLength,
    this.width,
    this.child,
  }) : super(key: key);
  @override
  _AppFormFieldState createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: widget.width,
      constraints: BoxConstraints(
        /// TODO: TextField Responsiveness
        minWidth:
            // (ResponsiveWrapper.of(context).isLargerThan('TABLET_S') )
            //     ?
            widget.width ?? 300
        // : 300
        ,
        maxWidth: widget.width ?? double.infinity,
      ),
      margin: widget.margin,
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Text(widget.title!, style: TextStyle(fontWeight: FontWeight.w500)),
          widget.child ??
              TextFormField(
                maxLength: widget.maxLength,
                focusNode: widget.focusNode,
                validator: widget.validator,
                decoration: InputDecoration(
                  isDense: true,
                  // filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  labelText: (widget.isLabel && widget.title == null)
                      ? widget.labelText
                      : null,
                  hintText: (!widget.isLabel || widget.title != null)
                      ? widget.labelText
                      : null,
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFA8ADB7),
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFA8ADB7),
                  ),
                  prefixIcon: (widget.prefixIcon != null)
                      ? widget.prefixIcon
                      : (widget.icon != null)
                          ? Icon(widget.icon,
                              color: Colors.grey.withOpacity(0.4))
                          : null,
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatterList ??
                    ((widget.keyboardType == TextInputType.number)
                        ? [
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9-+.]"))
                          ]
                        : (widget.keyboardType == TextInputType.phone)
                            ? [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9+]"))
                              ]
                            : []),

                cursorColor: Theme.of(context).primaryColor,
                obscureText: widget.isPasswordField ? _obscureText : false,
                controller: widget.controller,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                onTap: widget.onTap,
                readOnly: widget.readOnly,
                onChanged: widget.onChanged,
                onEditingComplete: widget.onEditingComp,
                // onFieldSubmitted: widget.onFieldSub,
                textCapitalization: (widget.keyboardType ==
                            TextInputType.emailAddress ||
                        widget.keyboardType == TextInputType.visiblePassword)
                    ? TextCapitalization.none
                    : (widget.keyboardType == TextInputType.name)
                        ? TextCapitalization.words
                        : TextCapitalization.sentences,
              ),
        ],
      ),
    );
  }

  Widget _buildPasswordFieldVisibilityToggle() {
    return IconButton(
      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey),
      onPressed: () => setState(() => _obscureText = !_obscureText),
    );
  }
}
