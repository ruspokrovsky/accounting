import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback? categoryPressed;
  final VoidCallback? onTapBack;
  final VoidCallback? onTapJoinPosition;
  final VoidCallback? onTapCart;
  final bool? isAvatarGlow;
  final bool? isAdditionalBtn;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
    this.categoryPressed,
    this.onTapBack,
    this.onTapJoinPosition,
    this.onTapCart,
    this.isAvatarGlow,
    this.isAdditionalBtn,
  }) : super(key: key);

  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      height: 50,
      //margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
        border: Border.all(color: Theme.of(context).primaryColor,width: 3.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          icon: widget.isAdditionalBtn!
            ?GestureDetector(
              onTap: widget.onTapBack,
              child: Icon(Icons.arrow_back_ios_new, color: style.color))
          :
          null,
          suffixIcon:
          controller.text.isNotEmpty
          ?
          GestureDetector(
            child: Icon(
              Icons.close,
                color: style.color
            ),
            onTap: () {
              controller.clear();
              widget.onChanged('');
              FocusScope.of(context).requestFocus(FocusNode());
            },
          )
          :
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.search, color: style.color),
              if(widget.isAdditionalBtn!)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Icon(Icons.search, color: style.color),
                  IconButton(
                    tooltip: 'Показать все',
                      onPressed: widget.onTapJoinPosition,
                      icon: Icon(Icons.join_inner, color: style.color)),
                  IconButton(
                      tooltip: 'Фильтр по категориям',
                      onPressed: widget.categoryPressed,
                  icon: Icon(Icons.category, color: style.color)),
                  // AvatarGlow(
                  //   animate: widget.isAvatarGlow?? false,
                  //   endRadius: 20.0,
                  //   glowColor: Colors.deepOrange,
                  //   duration: const Duration(milliseconds: 2000),
                  //   child: Center(
                  //     child: IconButton(
                  //         tooltip: 'Корзина',
                  //         onPressed: widget.onTapCart,
                  //         icon: Icon(Icons.shopping_cart_outlined,
                  //
                  //             color: widget.isAvatarGlow??false
                  //             ?
                  //             Colors.deepOrange
                  //             :
                  //             style.color)),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}


