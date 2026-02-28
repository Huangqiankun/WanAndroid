import { HMRouterMgr } from "@hadss/hmrouter"
import { CommonHeader, FeatureHomePath, LogUtil, UserInfoResult, UserInfoResultUserInfo, UserStorageUtil } from "common"
import { UserApi } from "../net/UserApi"

@ComponentV2
export struct UserComp {
  @Local userInfoData: UserInfoResultUserInfo | null = null
  private gridData: UserGridItem[] = [{ icon: $r('app.media.user_svg_points'), title: "我的积分" },
    { icon: $r('app.media.user_svg_collect'), title: "我的收藏" },
    { icon: $r('app.media.user_svg_share'), title: "我的分享" },
    { icon: $r('app.media.user_svg_todo'), title: "TODO" }]
  @Local isLogin: boolean = false

  aboutToAppear(): void {
    //是否登录，如果登录了，请求我的信息接口，如果没登录显示去登录
    this.initData()
  }

  build() {
    Column() {
      CommonHeader({ title: "我的信息" })
      //个人信息展示
      this.userInfoView()
      // list组件列表
      this.listContentView()
    }.width('100%')
    .height('100%')
  }

  @Builder
  listContentView() {
    List({ space: 8 }) {
      Repeat<UserGridItem>(this.gridData).each((ri: RepeatItem<UserGridItem>) => {
        ListItem() {
          this.listItemView(ri.item)
        }
      })

      if (this.isLogin) {
        ListItem() {
          Text("退出登录")
            .width('100%')
            .padding({ top: 12, bottom: 12 })
            .textAlign(TextAlign.Center)
            .backgroundColor($r('app.color.common_color_white'))
            .onClick(() => {
              this.onClickLogOut()
            })
        }
      }
    }
    .margin({ top: 8 })
    .width('100%')
    .height('100%')
  }

  @Builder
  listItemView(userGridItem: UserGridItem) {
    Row() {
      Image(userGridItem.icon).width(33).height(33)
      Text(userGridItem.title).fontColor($r('app.color.common_color_theme')).margin({ left: 30 })
    }.width('100%')
    .backgroundColor($r('app.color.common_color_white'))
    .padding({ top: 6, bottom: 6, left: 30 })
  }

  @Builder
  userInfoView() {
    Column() {
      Image($r('app.media.user_default_head')).width(80).height(80)
      Text(this.userInfoData == null ? "去登录" : this.userInfoData.nickname)
        .margin({ top: 12 })
        .fontColor($r('app.color.common_color_white'))
        .fontSize(16)
        .onClick(() => {
          this.onClickLogin()
        })
    }.width('100%')
    .padding({ bottom: 16 })
    .backgroundColor($r('app.color.common_color_theme'))
    .alignItems(HorizontalAlign.Center)
  }

  onClickLogin() {
    if (this.isLogin) {
      return
    }
    HMRouterMgr.replace({ pageUrl: FeatureHomePath.LOGIN, param: { "from": "NetWork" } });
  }

  onClickLogOut() {
    UserApi.loginOut()
    UserStorageUtil.clearUserInfo()
    this.initData()
  }

  private initData() {
    const isLogin = UserStorageUtil.isLogin()
    this.isLogin = isLogin
    if (!isLogin) {
      this.userInfoData = null
      return
    }
    this.getUserInfo()
  }

  private getUserInfo() {
    UserApi.getUserInfo().then((userInfoResult: UserInfoResult) => {
      LogUtil.debug("checkLoginStatus->getUserInfo-> " + JSON.stringify(userInfoResult))
      this.userInfoData = userInfoResult.userInfo
    })
  }
}

interface UserGridItem {
  icon: Resource,
  title: string
}