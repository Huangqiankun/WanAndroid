import { BasicDataSource, CommonHeader, LogUtil, PullToRefreshLayout, RefreshController, ToastUtil } from "common";
import { BannerResult, HomeListArticleResult, HomeListArticleResultDatas } from "../model/ResponseResult";
import { HomeApi } from "../net/HomeApi";

class MyBannerDataSource extends BasicDataSource {
  private list: BannerResult[] = [];

  totalCount(): number {
    return this.list.length
  }

  getData(index: number): BannerResult {
    return this.list[index]
  }

  setData(list: BannerResult[]) {
    this.list = list;
    this.notifyDataReload(); // 关键：数据变了，通知 Swiper 刷新
  }
}

@ComponentV2
export struct HomeComp {
  @Local page: number = 0
  private swiperController: SwiperController = new SwiperController();
  private bannerData: MyBannerDataSource = new MyBannerDataSource()
  private scrollerForList: Scroller = new Scroller();
  @Local listBanner: BannerResult[] = []
  @Local listArticle: HomeListArticleResultDatas[] = []
  /*RefreshLayout控制器*/
  private controller: RefreshController = new RefreshController()
  private hasNextPage: boolean = false

  // 组件生命周期
  aboutToAppear() {
    this.getHomeBanner()
    this.getHomeArticleList()
  }

  build() {
    Column() {
      //统一标题
      CommonHeader({ title: "首页" })
      PullToRefreshLayout({
        contentView: () => {
          this.contentView()
        },
        viewKey: "HomeComp",
        controller: this.controller,
        scroller: this.scrollerForList,
        onRefresh: () => {
          LogUtil.debug("HomeComp onRefresh")
          this.onRefreshData()
        },
        onLoad: () => {
          LogUtil.debug("HomeComp onLoad")
          this.onLoadData()
        },
        onCanPullLoad: () => {
          return this.scrollerForList.isAtEnd()
        }
      }).layoutWeight(1)
    }.width('100%').height('100%')
  }

  @Builder
  contentView() {
    List({ scroller: this.scrollerForList, space: 10 }) {
      ListItem() {
        this.swiperBuilder()
      }

      Repeat<HomeListArticleResultDatas>(this.listArticle).each((ri: RepeatItem<HomeListArticleResultDatas>) => {
        ListItem() {
          Text('' + ri.item.title)
            .width('100%')
            .height(100)
            .fontSize(16)
            .textAlign(TextAlign.Center)
            .borderRadius(10)
            .backgroundColor(0xFFFFFF)
        }
      })
    }.width('100%')
    .height('100%') // 这里的 100% 会自动扣除父容器 Tabs 占用的底部高度
    .layoutWeight(1) // 确保 List 占据剩余所有空间
    .edgeEffect(EdgeEffect.Spring) // 加上回弹效果更流畅
  }

  private async onRefreshData() {
    this.page = 0
    this.getHomeArticleList()
    this.getHomeBanner()
  }

  private async onLoadData() {
    if (!this.hasNextPage) {
      ToastUtil.showShort("没有更多数据了！")
      this.controller.loadError()
      return
    }
    this.page++
    this.getHomeArticleList()
  }

  private async getHomeArticleList() {
    LogUtil.debug('HomeCont Child getHomeArticleList');
    HomeApi.getHomeList(this.page).then((homeArticleList: HomeListArticleResult) => {
      LogUtil.debug("HomeCont getHomeArticleList:" + JSON.stringify(homeArticleList))
      if (this.page == 0) {
        this.listArticle = homeArticleList.datas
      }else{
        homeArticleList.datas.forEach((item: HomeListArticleResultDatas) => {
          this.listArticle.push(item)
        })
      }
      this.hasNextPage = homeArticleList.curPage < homeArticleList.pageCount;
      this.controller.refreshSuccess()
      this.controller.loadSuccess()
    })
  }

  private async getHomeBanner() {
    HomeApi.homeBannerLst().then((listBanner: BannerResult[]) => {
      LogUtil.debug("HomeCont getHomeBanner:" + JSON.stringify(listBanner))
      this.listBanner = listBanner
    })
  }

  // @Builder
  // ArticleListBuilder() {
  //   List({ space: 2, initialIndex: 0 }) {
  //     Repeat<HomeListArticleResultDatas>(this.listArticle).each((ri: RepeatItem<HomeListArticleResultDatas>) => {
  //       ListItem() {
  //         Text('' + ri.item.title)
  //           .width('100%')
  //           .height(100)
  //           .fontSize(16)
  //           .textAlign(TextAlign.Center)
  //           .borderRadius(10)
  //           .backgroundColor(0xFFFFFF)
  //       }
  //     })
  //   }.width('100%')
  //   .height('100%')
  // }

  @Builder
  swiperBuilder() {
    Swiper(this.swiperController) {
      // LazyForEach(this.bannerData, (item: BannerResult) => {
      //   Image(item.imagePath).width('90%').height(160)
      // })
      Repeat<BannerResult>(this.listBanner).each((ri: RepeatItem<BannerResult>) => {
        Image(ri.item.imagePath).width('100%').height(160)
      })
    }
    .cachedCount(2)
    .index(1)
    .width('100%')
    // .height('30%')
    .autoPlay(true)
    .interval(4000)
    .indicatorInteractive(true)
    .duration(1000)
    .itemSpace(5)
    // .prevMargin(35)
    // .nextMargin(35)
    .indicator( // 设置圆点导航点样式
      new DotIndicator()
        .itemWidth(15)
        .itemHeight(15)
        .selectedItemWidth(15)
        .selectedItemHeight(15)
        .color(Color.Gray)
        .selectedColor(Color.Blue))
    .displayArrow({
      // 设置导航点箭头样式
      showBackground: true,
      isSidebarMiddle: true,
      backgroundSize: 24,
      backgroundColor: Color.White,
      arrowSize: 18,
      arrowColor: Color.Blue
    }, false)
    .curve(Curve.Linear)
    .onChange((index: number) => {
      console.info(index.toString());
    })
  }
}