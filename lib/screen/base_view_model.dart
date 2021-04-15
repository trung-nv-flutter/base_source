import 'package:flutter/material.dart';

import 'base_screen.dart';

class BaseViewModel {
  BaseScreen screen;

  BaseViewModel(BaseScreen screen) {
    this.screen = screen;
  }

  showLoading(bool flag, {Widget indicator}) async {
    await screen?.showLoading(flag,indicator: indicator);
  }

  pushScreen(BaseScreen screen) {
    print(this.screen);
    this.screen?.push(screen);
  }

  dispose() {}
}
