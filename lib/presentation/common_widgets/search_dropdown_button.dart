import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SearchDropdownButton extends StatefulWidget {
  final List<String> items;
  final String hint;
  final String searchHint;
  final TextEditingController textEditingController;

  const SearchDropdownButton({
    Key? key,
    required this.items,
    required this.hint,
    required this.searchHint,
    required this.textEditingController,
  }) : super(key: key);

  @override
  State<SearchDropdownButton> createState() => _SearchDropdownButtonState();
}

class _SearchDropdownButtonState extends State<SearchDropdownButton> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Text(
          widget.hint,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: widget.items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
        },
        buttonHeight: 40,
        buttonWidth: 200,
        itemHeight: 40,
        dropdownMaxHeight: 200,
        searchController: widget.textEditingController,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 50,
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 4,
            right: 8,
            left: 8,
          ),
          child: TextFormField(
            expands: true,
            maxLines: null,
            controller: widget.textEditingController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              hintText: widget.searchHint,
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) {
          return (item.value.toString().contains(searchValue));
        },
        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            widget.textEditingController.clear();
          }
        },
      ),
    );
  }
}
