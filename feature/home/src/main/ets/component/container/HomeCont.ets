import { LogUtil } from "common";

@ComponentV2
export struct HomeCont{
  @Local title: string = 'Hello World';

  // 组件生命周期
  aboutToDisappear() {
    LogUtil.debug('HomeCom Child aboutToDisappear');
  }
  // 组件生命周期
  onDidBuild() {
    LogUtil.debug('HomeCom Child onDidBuild');
  }
  // 组件生命周期
  aboutToAppear() {
    LogUtil.debug('HomeCom Child aboutToAppear');
  }

  build() {
    Text(this.title)
      .fontSize(50)
      .margin(20)
      .onClick(() => {
        this.title = 'Hello ArkUI';
      })
  }
}