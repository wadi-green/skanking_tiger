import 'package:flutter/material.dart';

import '../../utils/strings.dart';
import '../../utils/validators.dart';
import '../custom_card.dart';

class SearchBox extends StatefulWidget {
  final void Function(String) onSubmit;
  final String initialQuery;

  const SearchBox({Key key, @required this.onSubmit, this.initialQuery})
      : assert(onSubmit != null),
        super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _searchController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: Strings.search,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _searchController,
            onFieldSubmitted: submit,
            validator: (val) => Validators.searchInput(val),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, size: 22),
              hintText: Strings.findAnActivity,
              isDense: true,
              // keep the extra space under the input box to avoid spacing
              // changes when an error is displayed
              helperText: '',
            ),
          ),
        ),
      ],
    );
  }

  void submit(String query) {
    if (query == null || query.isEmpty) {
      // The user didn't search for anything, just close the keyboard
      _formKey.currentState.reset();
      return;
    }
    if (_formKey.currentState.validate()) {
      widget.onSubmit(_searchController.text);
    }
  }
}
