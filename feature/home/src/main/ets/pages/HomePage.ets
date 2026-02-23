import { HMRouter } from "@hadss/hmrouter";
import { FeatureHomePath } from "common";

@HMRouter({ pageUrl: FeatureHomePath.HOME })
@ComponentV2
@Preview
export struct HomePage {
  @Local selectedIndex: number = 0;

  private controller: TabsController = new TabsController();

  @Builder
  tabBuilder(title: string, targetIndex: number, iconStr: Resource, selectIconStr: Resource) {
    Column() {
      Image(this.selectedIndex === targetIndex ? selectIconStr : iconStr)
        .width(24)
        .height(24)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(title).fontColor(this.selectedIndex === targetIndex ? $r('app.color.common_color_theme') : $r('app.color.common_color_no_select'))
    }.width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.selectedIndex, controller: this.controller }) {
        TabContent() {
          Column() {
            Text('首页的内容')
          }.width('100%').height('100%').backgroundColor('#00CB87').justifyContent(FlexAlign.Center)
        }.tabBar(this.tabBuilder('首页', 0, $r('app.media.home_tab_main'), $r('app.media.home_tab_select_main')))

        TabContent() {
          Column() {
            Text('广场的内容')
          }.width('100%').height('100%').backgroundColor('#007DFF').justifyContent(FlexAlign.Center)
        }.tabBar(this.tabBuilder('广场', 1, $r('app.media.home_tab_square'), $r('app.media.home_tab_select_square')))

        TabContent() {
          Column() {
            Text('课程的内容')
          }.width('100%').height('100%').backgroundColor('#FFBF00').justifyContent(FlexAlign.Center)
        }.tabBar(this.tabBuilder('课程', 2, $r('app.media.home_tab_course'), $r('app.media.home_tab_select_course')))

        TabContent() {
          Column() {
            Text('我的内容')
          }.width('100%').height('100%').backgroundColor('#E67C92').justifyContent(FlexAlign.Center)
        }.tabBar(this.tabBuilder('我的', 3, $r('app.media.home_tab_my'), $r('app.media.home_tab_select_my')))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      // .barWidth('100%')
      .barHeight(60)
      .animationDuration(0)
      .onChange((index: number) => {
        this.selectedIndex = index;
      })
      // .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
      .scrollable(true)
      .padding({bottom:30})

    }
    .width('100%')

  }
}
