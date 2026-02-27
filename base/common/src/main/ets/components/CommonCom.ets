@ComponentV2
export struct CommonHeader {
  // 定义标题，外部传入
  @Param title: string = "";

  // 获取全局状态栏高度
  // 如果需要高度随系统动态变化，可以使用 @Monitor 监听或保持变量链接
  @Local statusBarHeight: number = AppStorage.get<number>('statusBarHeight') || 0;

  build() {
    Column() {
      // 1. 状态栏占位
      Row()
        .width('100%')
        .height(this.statusBarHeight)

      // 2. 标题内容区
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor($r('app.color.common_color_white'))
          .textAlign(TextAlign.Center)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
      }
      .width('100%')
      .height(56)
    }
    .width('100%')
    .backgroundColor($r('app.color.common_color_theme'))
  }
}