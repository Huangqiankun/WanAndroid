import { BasicDataSource, ListView, LogUtil } from "common";
import { BannerResult, HomeListArticleResult } from "../model/ResponseResult";
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
  @Local page: number = 1
  private swiperController: SwiperController = new SwiperController();
  private bannerData: MyBannerDataSource = new MyBannerDataSource()
  private scrollerForScroll: Scroller = new Scroller();
  private scrollerForList: Scroller = new Scroller();
  @Local listBanner: BannerResult[] = []

  private async getHomeArticleList() {
    LogUtil.debug('HomeCont Child getHomeArticleList');
    HomeApi.getHomeList(this.page).then((homeArticleList: HomeListArticleResult) => {
      LogUtil.debug("HomeCont getHomeArticleList:" + JSON.stringify(homeArticleList))
    })
  }

  private async getHomeBanner() {
    HomeApi.homeBannerLst().then((listBanner: BannerResult[]) => {
      LogUtil.debug("HomeCont getHomeBanner:" + JSON.stringify(listBanner))
      this.bannerData.setData(listBanner)
      this.listBanner = listBanner
    })
  }

  // 组件生命周期
  onDidBuild() {
    LogUtil.debug('HomeCont Child onDidBuild');
  }

  // 组件生命周期
  aboutToAppear() {
    LogUtil.debug('HomeCont Child aboutToAppear');
    this.getHomeBanner()
    this.getHomeArticleList()
  }

  // 组件生命周期
  aboutToDisappear() {
    LogUtil.debug('HomeCont Child aboutToDisappear');
  }

  build() {
    Scroll(this.scrollerForScroll) {
      Column() {
        // banner
        this.swiperBuilder()
        //列表
        this.ArticleListBuilder()
        
      }.width('100%')
      .height('100%')
    }.width('100%')
    .height('100%')

  }

  @Builder
  ArticleListBuilder() {
    // List({ space: 20, initialIndex: 0 }) {
    //
    // }

  }

  @Builder
  swiperBuilder() {
    Swiper(this.swiperController) {
      // LazyForEach(this.bannerData, (item: BannerResult) => {
      //   Image(item.imagePath).width('90%').height(160)
      // })
      Repeat<BannerResult>(this.listBanner).each((ri: RepeatItem<BannerResult>) => {
        Image(ri.item.imagePath).width('90%').height(160)
      })
    }
    .cachedCount(2)
    .index(1)
    .width('100%')
    .height(160)
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