import { HMRouter, HMRouterMgr } from "@hadss/hmrouter";
import {
  CommonHeader,
  FeatureUserPath,
  getViewModel,
  LogUtil,
  PullToRefreshLayout,
  RefreshController,
  ToastUtil
} from "common";
import { CollectListLifeCycle } from "../lifecycle/CollectListLifeCycle";
import { CollectListResultDatas } from "../model/UserReponseResult";


@HMRouter({ pageUrl: FeatureUserPath.COLLECT, lifecycle: CollectListLifeCycle.lifeCycleName })
@ComponentV2
export struct CollectListPage {
  //获取 'viewModel' 方式一 《推荐用 该方式》
  @Computed
  private get viewModel(): CollectListLifeCycle {
    return HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle() as CollectListLifeCycle
  }

  //获取 'viewModel' 方式二
  private viewModel2 = getViewModel<CollectListLifeCycle>()
  private controller: RefreshController = new RefreshController();
  private scrollerForList: Scroller = new Scroller();


  /**
   * 通过Monitor 监听 ViewModel 里的请求触发器
   */
  @Monitor('viewModel.requestTrigger')
  // 注意：方式一 变量名为：viewModel

  // @Monitor('viewModel2.requestTrigger')
  //  注意：方式二 变量名为：viewModel2
  onDataRequestFinished() {
    if (!this.viewModel) { //注意变量
      return
    }
    LogUtil.debug("CollectListPage onDataRequestFinished")
    // 根据 VM 里的状态来控制 UI Controller
    const isSuccess = this.viewModel.loadStatus === 'SUCCESS';
    const hasMore = this.viewModel.hasMore;
    this.stopRefreshOrLoadAnim(isSuccess, hasMore)
  }

  aboutToAppear(): void {
    LogUtil.debug("CollectListPage aboutToAppear")
    // this.onRefreshData()
  }

  aboutToReuse(): void {
    LogUtil.debug("CollectListPage aboutToReuse")
  }

  aboutToDisappear(): void {
    LogUtil.debug("CollectListPage aboutToDisappear")
  }

  build() {
    Column() {
      CommonHeader({ title: "我的收藏" })
      PullToRefreshLayout({
        contentView: () => {
          this.contentView()
        },
        viewKey: "CollectPage",
        controller: this.controller,
        scroller: this.scrollerForList,
        onRefresh: () => {
          LogUtil.debug("CollectPage onRefresh")
          this.onRefreshData()
        },
        onLoad: () => {
          LogUtil.debug("CollectPage onLoad")
          this.onLoadData()
        },
        onCanPullLoad: () => {
          return this.scrollerForList.isAtEnd()
        }
      }).layoutWeight(1)
    }.width('100%').height('100%').backgroundColor($r('app.color.common_color_grey_d2'))
  }

  private async onRefreshData() {
    this.viewModel.page = 0
    this.viewModel.collectArticleList2()
    // this.viewModel.collectArticleList(this.page, (success, hasMore) => {
    //   this.stopRefreshOrLoadAnim(success, hasMore)
    // })
  }

  private async onLoadData() {
    if (!this.viewModel.hasMore) {
      ToastUtil.showShort("没有更多数据了！")
      this.controller.loadError()
      return
    }
    this.viewModel.page++
    this.viewModel.collectArticleList2()
    // this.viewModel.collectArticleList(this.page, (success, hasMore) => {
    //   this.stopRefreshOrLoadAnim(success, hasMore)
    // })
  }

  @Builder
  contentView() {
    List({ scroller: this.scrollerForList, space: 8 }) {
      Repeat<CollectListResultDatas>(this.viewModel.listArticle).each((ri: RepeatItem<CollectListResultDatas>) => {
        ListItem() {
          Text(ri.item.title)
            .width('100%')
            .height(100)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .borderRadius(10)
            .backgroundColor(0xFFFFFF)
            .padding({ left: 10, right: 10 })
        }.margin({ left: 8, right: 8 })
      })
    }
    .width('100%')
    .margin({ top: 8 })
    .height('100%') // 这里的 100% 会自动扣除父容器 Tabs 占用的底部高度
    .layoutWeight(1) // 确保 List 占据剩余所有空间
    .edgeEffect(EdgeEffect.Spring) // 加上回弹效果更流畅
  }

  private stopRefreshOrLoadAnim(isSuccess: boolean, hasMore: boolean) {
    // 停止刷新与加载更多动画
    if (isSuccess) {
      this.controller.refreshSuccess();
    } else {
      this.controller.refreshError();
    }
    this.controller.loadComplete(isSuccess, hasMore);
  }
}