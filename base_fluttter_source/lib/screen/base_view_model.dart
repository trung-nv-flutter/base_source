import 'base_screen.dart';

class BaseViewModel {
  BaseScreen screen;

  BaseViewModel(BaseScreen screen) {
    this.screen = screen;
  }

  showLoading(bool flag) async {
    await screen?.showLoading(flag);
  }

  pushScreen(BaseScreen screen) {
    print(this.screen);
    this.screen?.push(screen);
  }

  dispose() {}
}
