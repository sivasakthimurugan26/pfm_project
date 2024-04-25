import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final bool? errorStatus;
  final TextEditingController? controller;
  final String? hintText;
  final validator;
  final onSaved;

  CustomTextFormField({Key? key, this.hintText, this.controller, this.focusNode, this.errorStatus, this.validator, this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String errorCross = 'assets/svg/errorCross.svg';
    String errorTick = 'assets/svg/errorTick.svg';

    return Stack(
      children: [
        Container(
          height: 55,
          decoration: focusNode!.hasFocus
              ? BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  boxShadow: [
                    errorStatus!
                        ? BoxShadow(
                            color: const Color(0xffFF7B65).withOpacity(0.65),
                            blurRadius: 10,
                          )
                        : BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.65),
                            blurRadius: 10,
                          ),
                  ],
                )
              : const BoxDecoration(
                  color: Color(0xffF8F7FB),
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
          // child: ,
        ),
        Container(
          height: 80,
          child: TextFormField(
            // textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            focusNode: focusNode,
            style: focusNode!.hasFocus ? TextStyle(fontFamily: 'Gilroy Medium', fontSize: 16) : TextStyle(fontFamily: 'Gilroy Light', fontSize: 16),
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              errorStyle: const TextStyle(fontFamily: 'Gilroy Medium', fontSize: 15),
              // contentPadding: EdgeInsets.only(left: 25),
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(40),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(40),
              ),
              fillColor: focusNode!.hasFocus ? Colors.white : Color(0xffF8F7FB),
              filled: true,
              suffixIcon: controller!.text.isEmpty
                  ? null
                  : RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(controller!.text)
                      ? SvgPicture.asset(
                          errorTick,
                          fit: BoxFit.scaleDown,
                        )
                      : SvgPicture.asset(
                          errorCross,
                          fit: BoxFit.scaleDown,
                        ),
            ),
            validator: validator,
            onSaved: onSaved,
          ),
        )
      ],
    );
  }
}
