import { HMRouter, HMRouterMgr, IHMLifecycle } from "@hadss/hmrouter";
import { FeatureMainPath, LogUtil, ProductPhonePath } from "common";
import { HomeComp } from "home";
import { UserComp } from "user";
import { MainLifeCycle } from "../lifecycle/MainLifeCycle";

@HMRouter({ pageUrl: FeatureMainPath.MAIN, lifecycle: MainLifeCycle.lifeCycleName })
@ComponentV2
export struct MainPage {
  @Local selectedIndex: number = 0;
  private controller: TabsController = new TabsController();

  // 定义一个私有方法或 getter 来获取强转后的实例
  private getLifecycleInstance(): MainLifeCycle | undefined {
    const lifecycle: IHMLifecycle | undefined = HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle();

    // 使用 instanceof 进行安全检查并强转
    if (lifecycle instanceof MainLifeCycle) {
      return lifecycle as MainLifeCycle;
    }
    return undefined;
  }

  onPageShow(): void {
    LogUtil.debug("MainPage onPageShow")
  }

  onPageHide(): void {
    LogUtil.debug("MainPage onPageHide")
  }

  @Computed
  get viewModel():MainLifeCycle{
    return HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle() as MainLifeCycle
  }

  aboutToAppear(): void {
    LogUtil.debug("MainLifeCycle aboutToAppear" + HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle())

    const myLifecycle = this.getLifecycleInstance();
    myLifecycle?.test()

    this.viewModel.test2()
  }

  aboutToDisappear(): void {
    LogUtil.debug("MainLifeCycle aboutToDisappear")
  }

  @Builder
  tabBuilder(title: string, targetIndex: number, iconStr: Resource, selectIconStr: Resource) {
    Column() {
      Image(this.selectedIndex === targetIndex ? selectIconStr : iconStr)
        .width(24)
        .height(24)
        .margin({ bottom: 4 })
        .objectFit(ImageFit.Contain)
      Text(title)
        .fontColor(this.selectedIndex === targetIndex ? $r('app.color.common_color_theme') :
          $r('app.color.common_color_no_select'))
    }.width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.selectedIndex, controller: this.controller }) {
        TabContent() {
          Column() {
            HomeComp()
          }.width('100%').height('100%').backgroundColor($r('app.color.common_color_grey_d2')).justifyContent(FlexAlign.Center)
        }.tabBar(this.tabBuilder('首页', 0, $r('app.media.main_tab_main'), $r('app.media.main_tab_select_main')))

        TabContent() {
          Column() {
            Text('广场的内容')
          }.width('100%').height('100%').backgroundColor('#007DFF').justifyContent(FlexAlign.Center)
        }.tabBar(this.tabBuilder('广场', 1, $r('app.media.main_tab_square'), $r('app.media.main_tab_select_square')))

        TabContent() {
          Column() {
            Text('课程的内容')
          }.width('100%').height('100%').backgroundColor('#FFBF00').justifyContent(FlexAlign.Center)
        }.tabBar(this.tabBuilder('课程', 2, $r('app.media.main_tab_course'), $r('app.media.main_tab_select_course')))

        TabContent() {
          Column() {
            UserComp()
          }.width('100%').height('100%').backgroundColor('#E67C92').justifyContent(FlexAlign.Center)
        }.tabBar(this.tabBuilder('我的', 3, $r('app.media.main_tab_my'), $r('app.media.main_tab_select_my')))
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
      .padding({ bottom: 30 })
    }
    .width('100%')

  }
}