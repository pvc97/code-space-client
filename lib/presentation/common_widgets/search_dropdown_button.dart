import 'package:diacritic/diacritic.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:code_space_client/constants/app_sizes.dart';
import 'package:code_space_client/models/dropdown_item.dart';

class SearchDropdownButton<T extends BaseDropdownItem> extends StatefulWidget {
  final List<T> items;
  final String hint;
  final String searchHint;
  final TextEditingController textEditingController;
  final ValueChanged<T?>? onChanged;

  const SearchDropdownButton({
    Key? key,
    required this.items,
    required this.hint,
    required this.searchHint,
    required this.textEditingController,
    this.onChanged,
  }) : super(key: key);

  @override
  State<SearchDropdownButton> createState() => _SearchDropdownButtonState<T>();
}

class _SearchDropdownButtonState<T extends BaseDropdownItem>
    extends State<SearchDropdownButton> {
  T? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.s8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        isExpanded: true,
        hint: Text(
          widget.hint,
          style: TextStyle(
            fontSize: Sizes.s16,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: widget.items
            .map((item) => DropdownMenuItem<T>(
                  value: item as T?,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: Sizes.s16,
                        ),
                      ),
                      if (item.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: Sizes.s4),
                          child: Text(
                            item.subtitle!,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ))
            .toList(),
        value: _selectedValue,
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
          widget.onChanged?.call(value);
        },
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
        searchMatchFn: (DropdownMenuItem<T> item, String searchValue) {
          final value = removeDiacritics(searchValue.toLowerCase());
          final title = item.value?.title.toLowerCase();
          final subtitle = item.value?.subtitle?.toLowerCase();
          final formattedTitle = title != null ? removeDiacritics(title) : null;
          final formattedSubtitle =
              subtitle != null ? removeDiacritics(subtitle) : null;

          return (formattedTitle?.contains(value) == true ||
              formattedSubtitle?.contains(value) == true);
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
