// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "appTitle" : MessageLookupByLibrary.simpleMessage("Feed the Parrot"),
    "conflictCodeErrorMessage" : MessageLookupByLibrary.simpleMessage("There was an error with the code. Please generate another and try again."),
    "deleteDialogConfirmationContent" : MessageLookupByLibrary.simpleMessage("Are you sure you want to delete the following elements?"),
    "deleteDialogConfirmationTitle" : MessageLookupByLibrary.simpleMessage("Are you sure?"),
    "englishLanguage" : MessageLookupByLibrary.simpleMessage("English"),
    "expiredCodeErrorMessage" : MessageLookupByLibrary.simpleMessage("The code has expired"),
    "feedFormEditTitle" : MessageLookupByLibrary.simpleMessage("Edit feed"),
    "feedFormNewTitle" : MessageLookupByLibrary.simpleMessage("New feed"),
    "filterCategoryField" : MessageLookupByLibrary.simpleMessage("Category"),
    "filterMatchAll" : MessageLookupByLibrary.simpleMessage("All"),
    "filterMatchAny" : MessageLookupByLibrary.simpleMessage("Any"),
    "filterTextField" : MessageLookupByLibrary.simpleMessage("Text"),
    "filterWordField" : MessageLookupByLibrary.simpleMessage("Word"),
    "filtersFieldGroup" : MessageLookupByLibrary.simpleMessage("Filters"),
    "invalidCodeErrorMessage" : MessageLookupByLibrary.simpleMessage("The code is not valid"),
    "itemLimitField" : MessageLookupByLibrary.simpleMessage("Item limit"),
    "itemLimitHint" : MessageLookupByLibrary.simpleMessage("Max number of items this feed should return"),
    "languageField" : MessageLookupByLibrary.simpleMessage("Language"),
    "loginButtonTooltip" : MessageLookupByLibrary.simpleMessage("Login"),
    "loginInputEmptyErrorMessage" : MessageLookupByLibrary.simpleMessage("The code must not be empty"),
    "loginInputHint" : MessageLookupByLibrary.simpleMessage("Input the code you got from the Alexa skill"),
    "loginInputLabel" : MessageLookupByLibrary.simpleMessage("Code"),
    "nameField" : MessageLookupByLibrary.simpleMessage("Name"),
    "newButtonTooltip" : MessageLookupByLibrary.simpleMessage("New"),
    "noFeedNameProvidedErrorMessage" : MessageLookupByLibrary.simpleMessage("At least one name has to be provided"),
    "optionsTileTitle" : MessageLookupByLibrary.simpleMessage("Options"),
    "readFullContentField" : MessageLookupByLibrary.simpleMessage("Read full content"),
    "requiredValueErrorMessage" : MessageLookupByLibrary.simpleMessage("Required"),
    "spanishLanguage" : MessageLookupByLibrary.simpleMessage("Spanish"),
    "truncateContentAtField" : MessageLookupByLibrary.simpleMessage("Truncate content at"),
    "truncateContentAtHint" : MessageLookupByLibrary.simpleMessage("Max number of characters the content should have"),
    "unknownErrorMessage" : MessageLookupByLibrary.simpleMessage("An error has occured"),
    "valueShouldBeANumberErrorMessage" : MessageLookupByLibrary.simpleMessage("This should be a number"),
    "valueShouldBeUniqueErrorMessage" : MessageLookupByLibrary.simpleMessage("This value already exists. Use another")
  };
}
