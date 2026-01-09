import 'package:flutter/material.dart';

import 'dummy/dummy_issues.dart';
import 'models/issue.dart';

ValueNotifier<int> bottomBarIndex = ValueNotifier<int>(0);

ValueNotifier<List<Issue>> issuesNotifier = ValueNotifier<List<Issue>>(
  dummyIssues,
);
